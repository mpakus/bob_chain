# frozen_string_literal: true

class Block
  attr_accessor :index, :prev_hash, :timestamp, :data, :hash

  def initialize(index, prev_hash, timestamp, data, hash)
    @index = index
    @prev_hash = prev_hash.to_s
    @timestamp = timestamp
    @data = data
    @hash = hash.to_s
  end

  def to_json(_opt)
    { index: @index, prev_hash: @prev_hash, timestamp: @timestamp, data: @data, hash: @hash }.to_s
  end
end
