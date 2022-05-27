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
            posts_list = FetchPosts.new(App.config).myPosts(@current_account)
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

          new_account = SecureMessage.decrypt(registration_token)
          CreateAccount.new(App.config).call(
            email: new_account['email'],
            account: new_account['account'],
            gpa: new_account['gpa'],
            ori_department: new_account['ori_department'],
            ori_school: new_account['ori_school'],
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
