require 'pp'

GRP_OPEN = '{'
GRP_CLOSE = '}'
GBG_OPEN = '<'
GBG_CLOSE = '>'
ESC = '!'

class Stream
  attr_reader :pos, :source, :tokens

  def initialize(source)
    @source = source
    @groups = []
    @tokens = []
  end

  def read
    pos = 0

    loop do
      break if @source[pos].nil? # EOF

      case @source[pos]
      when GRP_OPEN
        @tokens << GRP_OPEN
      when GRP_CLOSE
        @tokens << GRP_CLOSE
      when GBG_OPEN
        @tokens << GBG_OPEN
      when GBG_CLOSE
        @tokens << GBG_CLOSE
      when ESC
        pos += 1
      end
      pos += 1
    end

    in_garbage = false
    depth = 0
    depths = []

    puts @tokens.join

    @tokens.each do |token|
      case token
      when GBG_OPEN
        in_garbage = true
      when GBG_CLOSE
        in_garbage = false
      when GRP_OPEN
        unless in_garbage
          depth += 1
        end
      when GRP_CLOSE
        unless in_garbage
          depths << depth
          depth -= 1
        end
      end
    end
    pp depths.sum
  end

  def score
    0
  end
end

sources = ARGF.read.split

streams = sources.map { |s| Stream.new(s) }
streams.each(&:read)
streams.each { |s| puts s.tokens.join(", ") }
