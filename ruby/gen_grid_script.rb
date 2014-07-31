if (ARGV.length != 3) then
  print "Usage: ruby gen_grid_script.rb <file1 prefix> <file2 prefix> <results folder>\n"
  exit
end

file1prefix = ARGV[0]
file2prefix = ARGV[1]
results_folder = ARGV[2]

file_offset = 0
file_name = "#{results_folder}#{file1prefix}_#{file2prefix}.#{file_offset}"

print "set -x > #{results_folder}#{file1prefix}_#{file2prefix}.txt\n"
while (File.exist?(file_name)) do
  print "ruby ../ruby/grid.rb #{file_name} >> #{results_folder}#{file1prefix}_#{file2prefix}.txt\n"
  file_offset += 1
  file_name = "#{results_folder}#{file1prefix}_#{file2prefix}.#{file_offset}"
end
