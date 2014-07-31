if (ARGV.length != 1) then
  print "Usage: ruby condense.rb <file>\n"
  print "\n"
  print "  Outputs <file>.x2 <file>.x3 <file>.x4 <file>.x5 <file>.x6 <file>.x7 <file>.x8\n"
  exit
end

fileName = ARGV[0]
lines = File.open(fileName, "r").readlines


class FactorReader
  def initialize(lines, factor)
    @lines = lines
    @factor = factor
    @currentLine = 0
    @max_length = @lines[0].length
  end

  #
  #  read @factor lines into the @data array
  #
  #  the end result in @data may have fewer than @factor entries
  #
  #  returns true if there are lines in the @data array
  #
  def read
    factorCounter = 0
    @data = []
    while ((factorCounter < @factor) && (@currentLine < @lines.length)) do
      @data << @lines[@currentLine]
      @currentLine += 1
      factorCounter += 1
    end

    return factorCounter > 0
  end

  def condense
    # for each line, extract a @factor size segment, and add to result the maximum character from
    # all the extracted segments
    segmentStart = 0
    segmentEnd = @factor
    result = ""
    while (segmentStart < @max_length) do
      max_char = '0'
      @data.each do |line|
        actual_end = [ segmentEnd, @max_length ].min
        (segmentStart..(actual_end-1)).each do |characterOffset|
          if (line[characterOffset] > max_char) then
            max_char = line[characterOffset]
          end
        end
      end
      result += max_char
      segmentStart += @factor
      segmentEnd += @factor
    end
    return result
  end
end

(2..20).each do |factor|
  reader = FactorReader.new(lines, factor)
  outFile = File.open("#{fileName}.x#{factor}", "w")
  while (reader.read()) do
    outFile.syswrite(reader.condense())
    outFile.syswrite("\n")
  end
  outFile.close()
end
