# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('account') do |routing|
      routing.on do
        # GET /account/(username)
        routing.get String do |account|
          if @current_account && @current_account.account == account
            view :account, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/login'
          end
        end

        # Post /account/<registration_token>
        routing.post String do |registration_token|
          raise 'Passwords do not match or empty' if
            routing.params['password'].empty? ||
            routing.params['password'] != routing.params['password_confirm']

          new_account = SecureMessage.decrypt(registration_token)
          CreateAccount.new(App.config).call(
            email: new_account['email'],
            account: new_account['account'],
            gpa: new_account['gpa'],
            ori_department: new_account['ori_department'],
            ori_school: new_account['ori_school'],
            password: routing.params['password']
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
