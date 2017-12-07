$programs = {}

class Program
  attr_reader :name, :weight

  def initialize(name, weight, aboves)
    @name = name
    @weight = weight.to_i
    @_aboves = aboves || []
  end

  def aboves
    @_aboves.map { |n| $programs[n] }
  end

  def below
    $programs.values.find { |p| p.aboves.include?(self) }
  end

  def to_s
    "#{name}, #{depth}, #{weight}, #{total_weight}"
  end

  def inspect
    to_s
  end

  def balanced?
    siblings.all? { |s| s.total_weight == total_weight }
  end

  def siblings
    if below
      below.aboves - [self]
    else
      []
    end
  end

  def total_weight
    weight + aboves.sum { |a| a.total_weight }
  end

  def depth(i = 0)
    below.nil? ? i : below.depth(i + 1)
  end
end

STDIN.readlines.map { |line|
  m = line.match(/(?<name>[a-z]+) \((?<weight>[0-9]+)\)(?<abv>.*)/)

  $programs[m[:name]] = Program.new(
    m[:name],
    m[:weight],
    m[:abv].sub(' -> ', '').split(", ") || []
  )
}

progs = $programs.values.select { |p| !p.balanced? }
max_depth = progs.map(&:depth).max
deepests = progs.select { |p| p.depth == max_depth }
max_total_weight = deepests.map(&:total_weight).max
unbalanced = deepests.find { |d| d.total_weight == max_total_weight }
balanced = deepests.find { |d| d != unbalanced }
puts unbalanced.weight - (unbalanced.total_weight - balanced.total_weight)
