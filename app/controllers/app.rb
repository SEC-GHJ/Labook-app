# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'sinatra'

module Labook
  # Base class for Labook Web Application
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, css: ['style.css', 'message.css'], js: 'message.js', path: 'app/presentation/assets'
    plugin :public, root: 'app/presentation/public'
    plugin :multi_route
    plugin :flash
    plugin :sinatra_helpers

    route do |routing|
      response['Content-Type'] = 'text/html; charset=utf-8'
      @current_account = CurrentSession.new(session).current_account

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        nthu_department = YAML.safe_load File.read('app/seeds/department.yml')
        view 'home', locals: { current_account: @current_account,
                               nthu_department: }
      end
    end
  end
end
