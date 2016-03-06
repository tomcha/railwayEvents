# coding:utf-8

require 'sinatra/base'
require 'railwayEvents/version'

module RailwayEvents
  class Application < Sinatra::Base
    get '/' do
      'railwayEvents'
    end
  end
end
