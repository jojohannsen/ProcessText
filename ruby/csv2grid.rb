if (ARGV.length != 2) then
  print "Usage: ruby grid.rb <config file> <data file with N comma delimited columns of data>\n"
  print "\n"
  print "  Config File:  each line: <direction>,<threshold>,<character>\n"
  print "\n"
  print "     <direction> is 'f' or 'b'\n"
  print "     <threshold> is numeric, used for mapping to characters\n"
  print "     <character> is output when the threshold value is exceeded\n"
  print "\n"
  print "  Data File: each line represents a section\n"
  print "\n"
  print "     Columns 0,1,2 - line offset, total fwd count, total backward count\n"
  print "     remaining columns (N-3)/2 forward values, (N-3)/2 backward values\n"
  exit
end

class Threshold
  attr_reader :cval, :boundary

  def initialize(direction, boundary, cval)
    @direction = direction
    @boundary = boundary
    @cval = cval
  end

  def matchForward(value)
    if (@direction == 'f') then
      return (value > @boundary)
    else
      return false
    end
  end

  def matchBackward(value)
    if (@direction == 'b') then
      return (value > @boundary)
    else
      return false
    end
  end
end

configLines = File.open(ARGV[0], "r").readlines
config = []
configLines.each do |line|
  line.chomp!
  data = line.split(",")
  config << Threshold.new(data[0], data[1].to_i, data[2])
end

lines = File.open(ARGV[1], "r").readlines

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
    value = "0"
    config.each do |threshold|
      if (threshold.matchForward(fwdVal) || threshold.matchBackward(bkwdVal)) then
        value = threshold.cval 
        break
      end
    end
    print "#{value}"
  end
  print "\n"
end
