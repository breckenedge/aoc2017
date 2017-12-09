STDIN.read.split.each do |stream|
  arrays = eval(stream)
  puts arrays
end
