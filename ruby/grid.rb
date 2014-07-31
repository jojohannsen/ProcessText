if (ARGV.length != 1) then
  print "Usage: ruby grid.rb <file with N columns of data>\n"
  print "\n"
  print "  Columns 0,1,2 - line offset, total fwd count for section, total backward count for section\n"
  print "  remaining columns (N-3)/2 forward values, (N-3)/2 backward values\n"
  exit
end

lines = File.open(ARGV[0], "r").readlines

fwdValueRows = {}
bkwdValueRows = {}
initialized = false
numberValuesPerRow = 0

lines.each do |line|
  line.chomp!
  data = line.split(",")
  if (initialized == false) then
    initialized = true
    numberValuesPerRow = (data.length - 3)/2
    (0..(numberValuesPerRow-1)).each do |i|
      fwdValueRows[i] = []
      bkwdValueRows[i] = []
    end
  end
  (0..(numberValuesPerRow - 1)).each do |i|
    fwdValueRows[i] << data[i+3].to_i
    bkwdValueRows[i] << data[i+3+numberValuesPerRow].to_i
  end
end

numberValues = fwdValueRows[0].length
(0..(numberValuesPerRow-1)).each do |i|
  (0..(numberValues - 1)).each do |valueOffset|
    fwdVal = fwdValueRows[i][valueOffset]
    bkwdVal = bkwdValueRows[i][valueOffset]
    if (fwdVal > 2000) then print "3"
    elsif (bkwdVal > 2000) then print "9"
    elsif (fwdVal > 1000) then print "2"
    elsif (bkwdVal > 2000) then print "8"
    elsif (fwdVal > 500) then print "3"
    elsif (bkwdVal > 500) then print "7"
    else print "0"
    end
  end
  print "\n"
end
