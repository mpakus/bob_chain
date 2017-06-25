# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/json'
require_relative './bob_chain'

class Web < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload './block.rb'
    also_reload './bob_chain.rb'
  end

  configure do
    set :bc, BobChain.new('alister')
  end

  get '/blocks' do
    json data: bc.bobchain
  end

  post '/block' do
    data = params['data']
    return json error: 'Data is blank' if data.nil? || data == ''
    block = bc.generate_next_block(data)
    bc.add(block)
    json data: block
  end

  def bc
    settings.bc
  end
end
