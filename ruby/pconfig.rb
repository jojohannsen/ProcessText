if ((ARGV.length != 1) && (ARGV.length != 5)) then
  print "Usage: ruby pconfig.rb <file.config> [<resolution> <factor> <config file> <width>]\n"
  exit
end

lines = File.open( ARGV[0], "r").readlines
resolution = 100000 
resolution = ARGV[1].to_i if (ARGV.length == 5)
factor = 10
factor = ARGV[2].to_i if (ARGV.length == 5)
configFile = ""
configFile = ARGV[3] if (ARGV.length == 5)
width = 20
width = ARGV[4].to_i if (ARGV.length == 5)

RUBY_PATH = "../ruby/"

lines.each do |line|
  line.chomp!
  data = line.split
  left_sections = data[0].split("/")
  right_sections = data[1].split("/")
  left_file_name_sections = left_sections[1].split(".")
  right_file_name_sections = right_sections[1].split(".")
  folder_name = "#{left_file_name_sections[0]}_#{right_file_name_sections[0]}"
  print "mkdir #{folder_name}\n"
  print "cp #{data[0]} #{folder_name}\n"
  print "cp #{data[1]} #{folder_name}\n"

  outFile = File.open("#{folder_name}.jojo", "w")
  outFile.syswrite("species #{left_sections[0]} #{left_file_name_sections[0]}.#{left_file_name_sections[1]}\n")
  outFile.syswrite("species #{right_sections[0]} #{right_file_name_sections[0]}.#{right_file_name_sections[1]}\n")
  outFile.close
  print "ruby #{RUBY_PATH}jojo.rb #{folder_name}.jojo #{resolution} #{factor} #{configFile} #{width} > do_#{folder_name}\n"
  print "dos2unix do_#{folder_name}\n"
  print "chmod +x do_#{folder_name}\n"
  print "./do_#{folder_name}\n"
end
