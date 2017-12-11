HexCoord = Struct.new(:x, :y, :z)

MOVES = {
   n: HexCoord.new( 0,  1, -1),
   s: HexCoord.new( 0, -1,  1),
  ne: HexCoord.new( 1,  0, -1),
  nw: HexCoord.new(-1,  1,  0),
  se: HexCoord.new( 1, -1,  0),
  sw: HexCoord.new(-1,  0,  1)
}

if __FILE__ == $0
  inputs = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp).map { |line| line.split(',').map(&:to_sym) }

  inputs.each do |path|
    child_pos = HexCoord.new(0, 0, 0)

    path.each do |m|
      child_pos.x = child_pos.x + MOVES[m].x
      child_pos.y = child_pos.y + MOVES[m].y
      child_pos.z = child_pos.z + MOVES[m].z
    end

    puts [child_pos.x.abs, child_pos.y.abs, child_pos.z.abs].max
  end
end

__END__
ne,ne,ne
ne,ne,sw,sw
ne,ne,s,s
se,sw,se,sw,sw
