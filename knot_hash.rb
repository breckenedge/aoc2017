#!/usr/bin/ruby

require 'pry'
require './circular_list'

class KnotHash
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def dense_hash
    position = 0
    skip_size = 0
    sparse_hash = CircularList.new((0..255).to_a)

    64.times do
      lengths.each do |length|
        sparse_hash[position, length] = Array(sparse_hash[position, length]).reverse
        position += length + skip_size
        skip_size += 1
      end
    end

    sparse_hash.each_slice(16).map { |slice| slice.reduce(&:^) }
  end

  def lengths
    source.each_char.map(&:ord) + [17, 31, 73, 47, 23]
  end

  def to_s
    dense_hash.map { |i| i.to_s(16).rjust(2, '0') }.join
  end
end

if __FILE__ == $0
  (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp).each { |line| puts KnotHash.new(line.chomp).to_s }
end

__END__

AoC 2017
1,2,3
1,2,4
