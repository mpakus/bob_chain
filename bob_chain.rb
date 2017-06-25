# frozen_string_literal: true

require 'pstore'
require 'digest'
require_relative './block'

class BobChain
  class InvalidBlock < StandardError; end

  def initialize(db_name)
    @db_name = db_name
    @errors = []
    db.transaction do
      db[:bobchain] = [genesis_block] unless db.fetch(:bobchain, nil)
      db.commit
    end
  end

  def bobchain
    db.transaction do
      db[:bobchain]
    end
  end

  def tail
    bobchain[-1]
  end

  def generate_next_block(data)
    next_index = tail.index + 1
    next_timestamp = Time.new
    next_hash = calculate_hash(next_index, tail.hash, next_timestamp, data)
    Block.new(next_index, tail.hash, next_timestamp, data, next_hash)
  end

  def add(new_block)
    raise InvalidBlock, @errors.join(";\n") unless block_valid?(new_block, tail)
    db.transaction do
      db[:bobchain].push(new_block)
      db.commit
    end
    self
  end

  private

  def calculate_hash(index, prev_hash, timestamp, data)
    Digest::SHA256.digest("#{index}#{prev_hash}#{timestamp}#{data}")
  end

  def genesis_block
    Block.new(0, '0', 1_498_384_800, 'Let there be light', calculate_hash(0, '0', 1_498_384_800, 'Let there be light'))
  end

  def block_valid?(new_block, prev_block)
    @errors << 'New block has invalid index' if prev_block.index + 1 != new_block.index
    @errors << 'New block has invalid prev_hash' if prev_block.hash != new_block.prev_hash
    if calculate_hash(new_block.index, new_block.prev_hash, new_block.timestamp, new_block.data) != new_block.hash
      @errors << 'New block has invalid hash'
    end
    return false if @errors.any?

    true
  end

  def db
    @db ||= PStore.new("#{@db_name}.pstore")
  end
end
