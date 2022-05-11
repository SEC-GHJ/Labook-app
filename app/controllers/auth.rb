# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            account: routing.params['account'],
            password: routing.params['password']
          )

          session[:current_account] = account
          flash[:notice] = "Welcome back #{account['account']}!"
          routing.redirect '/'
        rescue StandardError
          flash.now[:error] = 'Account and password did not match our records'
          response.status = 400
          view :login
        end
      end

      routing.on 'logout' do
        routing.get do
          session[:current_account] = nil
          routing.redirect @login_route
        end
      end
    end
  end
end
