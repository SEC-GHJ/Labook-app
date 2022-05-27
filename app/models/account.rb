# frozen_string_literal: true

module Labook
  # Behaviors of the currently logged in account
  class Account
    def initialize(account_info, auth_token = nil)
      @account_info = account_info
      @auth_token = auth_token
    end

    attr_reader :account_info, :auth_token

    def account
      @account_info ? @account_info['account'] : nil
    end

    def ori_department
      @account_info ? @account_info['ori_department'] : nil
    end

    def gpa
      @account_info ? @account_info['gpa'] : nil
    end

    def ori_school
      @account_info ? @account_info['ori_school'] : nil
    end

    def email
      @account_info ? @account_info['email'] : nil
    end

    def logged_out?
      @account_info.nil?
    end

    def logged_in?
      !logged_out?
    end
  end
end
