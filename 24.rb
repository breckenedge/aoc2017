require 'pry'

class Edge
  attr_reader :graph

  def initialize(graph, node1, node2)
    @graph = graph
    @node1 = node1
    @node2 = node2
  end

  def nodes
    [@node1, @node2]
  end

  def to_s
    "#{@node1}/#{@node2}"
  end

  def inspect
    to_s
  end
end

class Graph
  attr_reader :edges

  def initialize
    @edges = []
  end

  def add_edge(edge)
    @edges << edge
  end

  def routes_from(root_node, edge, visited = [], routes = [])
    new_visited = visited + [edge]
    routes << new_visited
    right_node = edge.nodes.uniq.one? ? edge.nodes.first : (edge.nodes - [root_node]).first
    possible_edges = @edges.reject { |e| new_visited.include?(e) }
      .select { |e| e.nodes.any? { |n| n == right_node } }
    if possible_edges.any?
      possible_edges.each { |possible_edge|
        routes_from(right_node, possible_edge, new_visited, routes)
      }
    end
    routes
  end
end

if __FILE__ == $0
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)
  g = Graph.new
  edges = input.map { |s| Edge.new(g, *s.split('/').map(&:to_i)) }
  edges.each { |e| g.add_edge(e) }
  roots = edges.select { |e| e.nodes.any?(&:zero?) }
  routes = roots.flat_map { |r|
    g.routes_from(0, r)
  }
  #puts "Strength\tRoute"
  #routes.each { |r|
  #  puts "#{r.sum { |e| e.nodes.sum }}\t#{r.join('--')}"
  #}
  strongest = routes.max_by { |r| r.sum { |e| e.nodes.sum } }
  puts strongest.sum { |e| e.nodes.sum }
end

__END__
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
