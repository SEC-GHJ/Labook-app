# frozen_string_literal: true

require 'roda'
require_relative './app'
require 'uri'

module Labook
  # Web controller for Labook API
  class App < Roda
    def line_oauth_url(config)
      url = config.LINE_OAUTH_URL
      @state = SecureRandom.hex(10)
      data = {
        response_type: 'code',
        client_id: config.LINE_CHANNEL_ID,
        redirect_uri: config.LINE_REDIRECT_URI,
        scope: config.LINE_SCOPE,
        state: @state
      }
      query = URI.encode_www_form(data).gsub('+', '%20')
      "#{url}/?#{query}"
    end

    route('auth') do |routing|
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          credentials = Form::LoginCredentials.new.call(routing.params)

          if credentials.failure?
            flash[:error] = 'Please enter both account and password'
            routing.redirect @login_route
          end

          authenticated = AuthenticateAccount.new(App.config).call(**credentials.values)

          current_account = Account.new(
            authenticated[:account],
            authenticated[:auth_token]
          )

          CurrentSession.new(session).current_account = current_account

          flash[:notice] = "Welcome back #{current_account.account}!"
          routing.redirect '/'
        rescue AuthenticateAccount::UnauthorizedError
          flash.now[:error] = 'Account and password did not match our records'
          response.status = 401
          view :login
        rescue AuthenticateAccount::ApiServerError => e
          App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          response.status = 500
          routing.redirect @login_route
        end
      end

      @logout_route = '/auth/logout'
      routing.on 'logout' do
        # Get /auth/logout
        routing.get do
          CurrentSession.new(session).delete
          flash[:notice] = "You've been logged out"
          routing.redirect @login_route
        end
      end

      @register_route = '/auth/register'
      routing.on 'register' do
        routing.is do
          # Get /auth/register
          routing.get do
            view :register, locals: { line_oauth_url: line_oauth_url(App.config) }
          end

          # Post /auth/register
          routing.post do
            registration = Form::Registration.new.call(routing.params)

            if registration.failure?
              flash[:error] = Form.validation_errors(registration)
              routing.redirect @register_route
            end

            VerifyRegistration.new(App.config).call(registration.to_h)

            flash[:notice] = 'Please check your email for a verification link'
            routing.redirect '/'
          rescue VerifyRegistration::ApiServerError => e
            App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Our servers are not responding -- please try later'
            routing.redirect @register_route
          rescue StandardError => e
            App.logger.error "Could not verify registration: #{e.inspect}"
            flash[:error] = 'Please use English characters for account only'
            routing.redirect @register_route
          end
        end

        # Get /auth/register/<token>
        routing.get(String) do |registration_token|
          flash.now[:notice] = 'Email Verified! Please choose a new password'
          new_account = SecureMessage.decrypt(registration_token)
          view :register_confirm,
               locals: { new_account:, registration_token: }
        end
      end

      routing.on 'line_callback' do
        puts routing.params
        puts @state

        # check state is the same
        authorized = AuthorizeLineAccount
                     .new(App.config)
                     .call(routing.params['code'])

        current_account = Account.new(
          authorized[:account],
          authorized[:auth_token]
        )
        
        CurrentSession.new(session).current_account = current_account
        flash[:notice] = "Welcome #{current_account.email}!"
        routing.redirect '/'
      end
    end
  end
end
