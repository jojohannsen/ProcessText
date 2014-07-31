lines = File.open(ARGV[0], "r").readlines
column = ARGV[1].to_i
values = []
lines.each do |line|
  line.chomp!
  data = line.split
  if ((data[0] != '#') && (data.length == 5)) then
    values << data[column].to_i
  end
end

mm = values.minmax
range = mm[1] - mm[0]
threshold = mm[0] + (range/100)

lines.each do |line|
  line.chomp!
  data = line.split
  if ((data[0] != '#') && (data.length == 5)) then
    test_value = data[column].to_i
    if (test_value < threshold) then
      print "#{line}\n"
    end
  end
end
