if (ARGV.length != 2) then
  print "Usage: ruby strip_file.rb <in file> <out file>\n"
  print "\n"
  print "  If <out file> already exists, does nothing.\n"
  exit
end

in_file = ARGV[0]
out_file = ARGV[1]

if (!File.exist?( in_file )) then
  print "Input file #{in_file} does NOT exist!\n"
  exit
end

if (File.exist?( out_file )) then
  print "Output file #{out_file} already exists, input file NOT processed!\n"
  exit
end

fin = File.open(in_file, "r")
fout = File.open(out_file, "w")
fin.each_line do |line|
  if (line.length > 0) then
    if (line[0] != '>') then
      line.each_char do |cval|
        if ((cval == 'A') || (cval == 'a')) then
          fout.syswrite('A')
        elsif ((cval == 'C') || (cval == 'c')) then
          fout.syswrite('C')
        elsif ((cval == 'G') || (cval == 'g')) then
          fout.syswrite('G')
        elsif ((cval == 'T') || (cval == 't')) then
          fout.syswrite('T')
        end
      end
    end
  end
end
fin.close
fout.close

