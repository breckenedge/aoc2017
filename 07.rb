require 'pry'

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

  def belows
    $programs.values.select { |p| p.aboves.include?(self) }
  end

  def to_s
    name
  end

  def inspect
    name
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

puts $programs.values.find { |p| p.belows == [] }
