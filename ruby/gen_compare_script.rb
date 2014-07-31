if ((ARGV.length != 3) && (ARGV.length != 6)) then
  print "Usage: ruby gen_compare_script.rb <file1> <file2> <results folder> [<resolution> <factor> <width>]\n"
  print "\n"
  print "  In generated image, each <resolution> characters become 1 pixel,\n"
  print "  and each <resolution> * <factor> characters are used in building\n"
  print "  suffix tree.\n"
  exit
end

def extractFileName( path )
  data = path.split("/")
  lastData = data[data.length - 1]
  data = lastData.split(".")
  return data[0]
end

SMALL_FILE_RESOLUTION = 100000
RESOLUTION_FACTOR = 10
STRING_LENGTH = 20

file1 = ARGV[0]
file1name = extractFileName( file1 )
file2 = ARGV[1]
results_folder = ARGV[2]
file2name = extractFileName( file2 )
file1size = File.size( file1 )
file2size = File.size( file2 )

resolution_specified = (ARGV.length == 6)

small_file_resolution = SMALL_FILE_RESOLUTION
small_file_resolution = ARGV[3].to_i if resolution_specified
resolution_factor = RESOLUTION_FACTOR
resolution_factor = ARGV[4].to_i if resolution_specified
big_file_resolution = small_file_resolution * resolution_factor
string_length = STRING_LENGTH
string_length = ARGV[5].to_i if resolution_specified

(0..(file1size/big_file_resolution - 1)).each do |file1section|
  print "../chrcompare #{file1} #{file1section*big_file_resolution} #{big_file_resolution} #{file2} #{small_file_resolution} #{string_length} >> #{results_folder}#{file1name}_#{file2name}.#{file1section}\n"
end
