# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('account') do |routing|
      @account_route = '/account'
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
            redirect back
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

        routing.on 'setting' do
          # POST /account/setting
          routing.post do
            params = SetDefaultSettingParams.call(routing.params)
            setting = Form::AccountSetting.new.call(params)

            if setting.failure?
              flash[:error] = 'Can\'t update account setting'
              routing.redirect "/account"
            end
            
            new_account_setting = UpdateSetting.new(App.config, @current_account)
                                               .call(setting.values)

            @current_account.update_account_setting(new_account_setting)
            CurrentSession.new(session).current_account = @current_account

            flash[:notice] = "Successfully Update your setting."
            routing.redirect @account_route
          rescue UpdateSetting::NoUpdate
            flash[:notice] = "No need to update for setting."
            routing.redirect @account_route
          rescue StandardError => e
            flash[:error] = e.message
            routing.redirect @account_route
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
