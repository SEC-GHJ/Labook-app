# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('account') do |routing|
      routing.on do
        # GET /account
        routing.get do
          if @current_account.logged_in?
            posts_list = FetchPosts.new(App.config).my_posts(@current_account)
            posts = Posts.new(posts_list) unless posts_list.nil?
            view :account, locals: { current_account: @current_account, all_posts: posts }
          else
            routing.redirect '/auth/login'
          end
        end

        # Post /account/<registration_token>
        routing.post String do |registration_token|
          passwords = Form::Passwords.new.call(routing.params)
          raise Form.message_values(passwords) if passwords.failure?

          profile_info = Form::Profile.new.call(routing.params)
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
      end
    end
  end
end
