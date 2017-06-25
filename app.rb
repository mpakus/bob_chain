# frozen_string_literal: true

require 'awesome_print'
require_relative './bob_chain'

bc = BobChain.new

[
  'Do what thou wilt shall be the whole of the law.',
  'Every man and every woman is a star.',
  'Every number is infinite; there is no difference.',
  'The word of the Law is THELEMA.'
].each do |data|
  bc.add bc.generate_next_block(data)
end

ap bc.bobchain
