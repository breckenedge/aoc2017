require 'pry'

require './knot_hash'

Coord = Struct.new(:x, :y)

class Disk
  FREE = '.'.freeze
  USED = '#'.freeze
  NEIGHBORS = [
    Coord.new( 1,  0), # E
    Coord.new(-1,  0), # W
    Coord.new( 0,  1), # N
    Coord.new( 0, -1)  # S
  ].freeze

  attr_reader :name, :raw, :regions

  def initialize(name)
    @name = name
    @raw = 128.times.map { |i|
      digits = KnotHash.new("#{name}-#{i}").dense_hash
      digits.flat_map { |d|
        d.to_s(2).rjust(8, '0').each_char.map { |c| c == '0' ? FREE : USED }
      }
    }
    @regions = Hash.new { |hsh, k| hsh[k] = [] }
  end

  def free?(coord)
    @raw[coord.y][coord.x] == FREE
  end

  def used?(coord)
    !free?(coord)
  end

  def in_region?(coord)
    @regions.values.any? { |region| region.include? coord }
  end

  def free_space
    @raw.flatten.count { |b| b == FREE }
  end

  def used_space
    @raw.flatten.count { |b| b == USED }
  end

  def regions
    current_region = 0
    128.times do |y|
      128.times do |x|
        coord = Coord.new(x, y)
        next if free?(coord)
        regionize(coord, current_region += 1) if !in_region?(coord)
      end
    end
    @regions
  end

  def regionize(coord, current_region = 0)
    @regions[current_region] << coord
    adjacents = neighbors(coord)

    adjacents.each do |adj_coord|
      if used?(adj_coord) && !in_region?(adj_coord)
        regionize(adj_coord, current_region)
      end
    end
  end

  def neighbors(coord)
    NEIGHBORS.map { |n|
      adj_x = coord.x + n.x
      adj_y = coord.y + n.y
      next if adj_x > 127 || adj_x < 0 || adj_y > 127 || adj_y < 0
      Coord.new(adj_x, adj_y)
    }.compact
  end
end

if __FILE__ == $0
  input = ARGV[0] || 'flqrgnkx'
  disk = Disk.new(input)
  puts "Used: #{disk.used_space}"
  puts "Regions: #{disk.regions.keys.size}"
end

__END__
