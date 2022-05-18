# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @credentials = { account: 'a1', password: 'password1' }
    @mal_credentials = { account: 'a1', password: 'wrongpassword' }
    @api_account = { attributes:
                       { account: 'a1', gpa: 3.4, ori_school: 'NTHU', ori_department: 'CS', email:'a1@gmail.com' } }
  end

  after do
    WebMock.reset!
  end

  describe 'Find authenticated account' do
    it 'HAPPY: should find an authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @credentials.to_json)
             .to_return(body: @api_account.to_json,
                        headers: { 'content-type' => 'application/json' })

      account = Labook::AuthenticateAccount.new(app.config).call(**@credentials)
      _(account).wont_be_nil
      _(account['account']).must_equal @api_account[:attributes][:account]
      _(account['gpa']).must_equal @api_account[:attributes][:gpa]
      _(account['ori_school']).must_equal @api_account[:attributes][:ori_school]
      _(account['ori_department']).must_equal @api_account[:attributes][:ori_department]
      _(account['email']).must_equal @api_account[:attributes][:email]
    end

    it 'BAD: should not find a false authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @mal_credentials.to_json)
             .to_return(status: 403)
      _(proc {
        Labook::AuthenticateAccount.new(app.config).call(**@mal_credentials)
      }).must_raise Labook::AuthenticateAccount::UnauthorizedError
    end
  end
end
