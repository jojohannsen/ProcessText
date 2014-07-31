if (ARGV.length != 4) then
  print "Usage: ruby gen_csv2grid_script.rb <config file> <file1 prefix> <file2 prefix> <results folder>\n"
  exit
end

config_file = ARGV[0]
file1prefix = ARGV[1]
file2prefix = ARGV[2]
results_folder = ARGV[3]

file_offset = 0
file_name = "#{results_folder}#{file1prefix}_#{file2prefix}.#{file_offset}"

print "set -x > #{results_folder}#{file1prefix}_#{file2prefix}.txt\n"
while (File.exist?(file_name)) do
  print "ruby ../ruby/csv2grid.rb #{config_file} #{file_name} >> #{results_folder}#{file1prefix}_#{file2prefix}.txt\n"
  file_offset += 1
  file_name = "#{results_folder}#{file1prefix}_#{file2prefix}.#{file_offset}"
end
