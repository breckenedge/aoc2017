require 'set'

class Node
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def edges
    $edges.select do |edge|
      edge.src_id == id || edge.dest_id == id
    end
  end

  def ==(other)
    id == other.id
  end
end

class Edge
  attr_reader :src_id, :dest_id

  def initialize(src_id, dest_id)
    @src_id = src_id
    @dest_id = dest_id
  end

  def src
    $nodes[src_id]
  end

  def dest
    $nodes[dest_id]
  end
end

$nodes = {}
$edges = []

$stdin.readlines.each do |line|
  matches = line.match(/^(?<src>\d+) \<-\> (?<dests>[\d, ]+)$/)
  src = matches[:src].to_i
  dests = matches[:dests].split(', ').map(&:to_i)
  ([src] + dests).each { |n| $nodes[n] = Node.new(n) }
  dests.each { |dest| $edges << Edge.new(src, dest) }
end

puts $nodes.size
puts $edges.size

$visited = Set.new

def visit_node(node, visited = $visited)
  visited << node
  node.edges.each do |edge|
    unless visited.include?(edge.dest)
      visit_node(edge.dest, visited)
    end
  end
  visited
end

count = 0

$visited = []

$nodes.each_value do |n|
  next if $visited.include?(n)
  $visited += visit_node(n, [])
  count += 1
end

puts count
