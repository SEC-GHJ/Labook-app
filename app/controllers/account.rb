# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('account') do |routing|
      routing.on do
        routing.get do
          # GET /account/[account_id]
          routing.on String do |account_id|
            if @current_account.logged_in? & @current_account.account_id == account_id
              routing.redirect '/account'
            elsif @current_account.logged_in?
              others_account = FetchOthersAccount.new(App.config, @current_account).call(account_id)
              raise('Unauthorized to access this account information.') if others_account.nil?
  
              others_account_obj = Account.new(others_account, nil, true)
  
              view :account, locals: { current_account: others_account_obj,
                                       all_posts: nil,
                                       line_notify_oauth_url: nil }
            else
              routing.redirect '/auth/login'
            end
          rescue StandardError => e
            flash[:error] = e.message
            routing.redirect '/'
          end

          # GET /account
          routing.is do
            if @current_account.logged_in?
              posts_list = FetchPosts.new(App.config).my_posts(@current_account)
              posts = Posts.new(posts_list) unless posts_list.nil?
              view :account, locals: { current_account: @current_account,
                                       all_posts: posts,
                                       line_notify_oauth_url: GenerateLineNotifyAuth.new(App.config).call }
            else
              routing.redirect '/auth/login'
            end
          end
        end

        # Post /account/<registration_token>
        routing.post String do |registration_token|
          passwords = Form::Passwords.new.call(routing.params)
          raise Form.message_values(passwords) if passwords.failure?
          
          profile_info = Form::Profile.new.call(routing.params)
          if profile_info.failure?
            flash[:error] = Form.validation_errors(profile_info)
            routing.redirect "/auth/register/#{registration_token}"
          end

          new_account = SecureMessage.decrypt(registration_token)

          CreateAccount.new(App.config).call(
            email: new_account['email'],
            username: new_account['username'],
            nickname: profile_info['nickname'],
            gpa: profile_info['gpa'],
            ori_department: profile_info['ori_department'],
            ori_school: profile_info['ori_school'],
            password: passwords['password']
          )
          flash[:notice] = 'Account created! Please login'
          routing.redirect '/auth/login'
        rescue CreateAccount::InvalidAccount => e
          flash[:error] = e.message
          routing.redirect '/auth/register'
        rescue StandardError => e
          flash[:error] = e.message
          routing.redirect(
            "#{App.config.APP_URL}/auth/register/#{registration_token}"
          )
        end

        routing.on 'line' do
          # Post /account/line/<registration_token>
          routing.post String do |registration_token|
            profile_info = Form::LineProfile.new.call(routing.params)

            if profile_info.failure?
              flash[:error] = Form.validation_errors(profile_info)
              routing.redirect "/account/line/#{registration_token}"
            end

            line_info = SecureMessage.decrypt(registration_token)

            CreateLineAccount.new(App.config).call(
              profile_info:, line_info:
            )
            flash[:notice] = 'Account created! Please login'
            routing.redirect '/auth/login'
          rescue CreateAccount::InvalidAccount => e
            flash[:error] = e.message
            routing.redirect '/'
          rescue StandardError => e
            flash[:error] = e.message
            routing.redirect(
              "#{App.config.APP_URL}/auth/register/line/#{registration_token}"
            )
          end
        end
      end
    end
  end
end
