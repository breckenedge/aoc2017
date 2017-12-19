require 'pry'

if __FILE__ == $0
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp).map { |line| line.split('') }

  routes = {
    ns: '|',
    ew: '-',
    tr: '+'
  }

  directions = {
    n: [0, -1],
    s: [0, 1],
    e: [1, 0],
    w: [-1, 0]
  }

  visits = []

  position = [input[0].index('|'), 0]
  direction = :s

  loop do
    puts direction
    puts position.join(', ')

    puts visits

    next_position = [position[0] + directions[direction][0], position[1] + directions[direction][1]]
    next_input = input[next_position[1]][next_position[0]]

    case next_input
    when routes[:tr]
      position = next_position

      new_direction = directions.find { |dir, mvs|
        if dir == :n || dir == :s
          next if direction == :n || direction == :s
        elsif dir == :e || dir == :w
          next if direction == :w || direction == :e
        end

        test = [position[0] + mvs[0], position[1] + mvs[1]]
        input[test[1]][test[0]] != ' ' && input[test[1]][test[0]] != nil
      }.first
      direction = new_direction
    when /A-Z/i
      visits << next_input
      position = next_position
    when routes[:ns], routes[:ew]
      position = next_position
    when ' '
      break
    else
      visits << next_input
      position = next_position
    end
  end
end

__END__
     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+

