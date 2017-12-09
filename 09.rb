require 'pp'

GRP_OPEN = '{'
GRP_CLOSE = '}'
GBG_OPEN = '<'
GBG_CLOSE = '>'
ESC = '!'
CHAR = 'x'

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
      else
        @tokens << CHAR
      end
      pos += 1
    end

    puts @tokens.join

    in_garbage = false
    depth = 0
    depths = []

    garbage_count = 0

    @tokens.each do |token|
      case token
      when GBG_OPEN
        if in_garbage
          garbage_count += 1
        else
          in_garbage = true
        end
      when GBG_CLOSE
        if in_garbage
          in_garbage = false
        end
      when GRP_OPEN
        unless in_garbage
          depth += 1
        else
          garbage_count += 1
        end
      when GRP_CLOSE
        unless in_garbage
          depths << depth
          depth -= 1
        else
          garbage_count += 1
        end
      else
        if in_garbage
          garbage_count += 1
        end
      end
    end
    puts "#{@tokens.join} #{garbage_count}"
  end

  def score
    0
  end
end

sources = ARGF.read.split("\n")

streams = sources.map { |s| Stream.new(s) }
streams.each(&:read)
