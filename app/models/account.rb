# frozen_string_literal: true

module Labook
  # Behaviors of the currently logged in account
  class Account
    def initialize(account_info, auth_token = nil, giving_policies=false)
      if giving_policies
        @account_info = account_info['attributes']
        process_policies(account_info['policies'])
      else
        @account_info = account_info
      end
      @auth_token = auth_token
    end

    attr_reader :account_info, :auth_token, :policies

    def update_account_setting(new_account_info)
      @account_info = new_account_info
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def username
      @account_info ? @account_info['username'] : nil
    end

    def nickname
      @account_info ? @account_info['nickname'] : nil
    end

    def account_id
      @account_info ? @account_info['account_id'] : nil
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

    def can_notify?
      @account_info ? @account_info['can_notify'] : false
    end

    def show_all?
      return false if @account_info.nil?
      @account_info['show_all'].zero? ? false : true
    end

    def accept_mail?
      return false if @account_info.nil?
      @account_info['accept_mail'].zero? ? false : true
    end

    def logged_out?
      @account_info.nil?
    end

    def logged_in?
      !logged_out?
    end
  end
end
