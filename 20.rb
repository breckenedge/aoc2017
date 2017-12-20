require 'pry'
Particle = Struct.new(:id, :x, :y, :z, :vx, :vy, :vz, :ax, :ay, :az)

#Increase the X velocity by the X acceleration.
#Increase the Y velocity by the Y acceleration.
#Increase the Z velocity by the Z acceleration.
#Increase the X position by the X velocity.
#Increase the Y position by the Y velocity.
#Increase the Z position by the Z velocity.

$particles = []

def tick
  # Update positions
  $particles.each do |particle|
    particle.vx += particle.ax
    particle.vy += particle.ay
    particle.vz += particle.az
    particle.x += particle.vx
    particle.y += particle.vy
    particle.z += particle.vz
  end

  # Remove collisions
  $particles.each do |p|
    coll = $particles.select { |q| p != q && p.x == q.x && p.y == q.y && p.z == q.z }
    if coll.any?
      $particles.delete(p)
      coll.each { |q| $particles.delete(q) }
    end
  end
end

def dist(particle)
  particle.x.abs + particle.y.abs + particle.z.abs
end

if __FILE__ == $0
  regexp = /p=. *(?<x>[0-9-]+), *(?<y>[-0-9]+), *(?<z>[-0-9]+).. v=. *(?<vx>[-0-9]+), *(?<vy>[-0-9]+), *(?<vz>[-0-9]+).. a=. *(?<ax>[-0-9]+), *(?<ay>[-0-9]+), *(?<az>[-0-9]+)./i
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)
  input.each_with_index { |line, i|
    caps = regexp.match(line).named_captures
    $particles << Particle.new(i, *caps.values.map(&:to_i))
  }

  # How many times until known?
  20000.times { |i|
    tick
    puts i
    puts $particles.size
    break if $particles.size == 0
  }

  $particles.sort! { |p, q| dist(p) <=> dist(q) }

  puts $particles.first

end

__END__
p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
