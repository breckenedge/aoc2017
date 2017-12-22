require 'pry'

def count_on(canvas)
  canvas.flatten.count { |c| c == '#' }
end

def rotations(pattern)
  [
    pattern,
    pattern.reverse,
    pattern.transpose,
    pattern.transpose.reverse,
    pattern.reverse.transpose,
    pattern.transpose.reverse.transpose,
    pattern.reverse.transpose.reverse,
    pattern.transpose.reverse.transpose.reverse
  ].uniq
end

def pattern_matches?(pattern, chunk)
  chunk.size == pattern.size && rotations(pattern).include?(chunk)
end

def chunk_canvas(canvas)
  if canvas[0].size % 2 == 0
    canvas.each_slice(2).map { |row|
      row.transpose.each_slice(2).to_a
    }.flatten(1)
  elsif canvas[0].size % 3 == 0
    canvas.each_slice(3).map { |row|
      row.transpose.each_slice(3).to_a
    }.flatten(1)
  else
    raise "unexpected chunk size #{chunk}"
  end
end

def convert_chunk(chunk, dict)
  key = dict.keys.find(-> { raise StandardError, "no match for #{chunk}" }) { |k|
    pattern_matches?(k, chunk)
  }
  dict[key]
end

def combine_chunks(chunks)
  canvas = []
  rows = Math.sqrt(chunks.size).to_i * chunks[0].size

  rows.times do |i|
    canvas[i] = []
    rows.times do |j|
      canvas[i][j] = nil
    end
  end

  chunks.each_slice(Math.sqrt(chunks.size).to_i).with_index do |chunk_row, chunk_row_index|
    row_index = chunk_row_index * chunks[0].size # y offset

    chunk_row.each_with_index do |chunk, chunk_index| # x offset
      col_index = chunk_index * chunks[0].size

      chunk.each_with_index do |row, y| # y offset
        row.each_with_index do |cell, x| # x offset
          canvas[row_index + y][col_index + x] = cell
        end
      end
    end
  end

  canvas
end

if __FILE__ == $0
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)
    .map { |str| str.split(' => ') }
    .to_h
    .transform_values { |v| v.split('/').map { |v2| v2.split('') } }
    .transform_keys { |k| k.split('/').map { |k2| k2.split('') } }

  canvas = [
    ['.', '#', '.'],
    ['.', '.', '#'],
    ['#', '#', '#'],
  ]

  18.times do |i|
    canvas = combine_chunks(chunk_canvas(canvas).map { |chunk| convert_chunk(chunk, input) })
    puts "Iter #{i}: #{count_on(canvas)}; Canvas size: #{canvas[0].size}² (#{canvas[0].size ** 2})"
  end
end

__END__
../.# => ##./#../...
.#./..#/### => #..#/..../..../#..#
