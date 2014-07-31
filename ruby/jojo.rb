if ((ARGV.length != 1) && (ARGV.length != 5)) then
  print "Usage: ruby jojo.rb <file.jojo> [<resolution> <factor> <config file> <width>]\n"
  exit
end

resolution = 100000 
resolution = ARGV[1].to_i if (ARGV.length == 5)
factor = 10
factor = ARGV[2].to_i if (ARGV.length == 5)
configFile = ""
configFile = ARGV[3] if (ARGV.length == 5)
width = 20
width = ARGV[4].to_i if (ARGV.length == 5)

RUBY_PATH = "../ruby/"
RESULTS_FOLDER = "./"

def extractFileName( path )
  data = path.split("/")
  lastData = data[data.length - 1]
  data = lastData.split(".")
  return data[0]
end

filePath = ARGV[0]
fileName = extractFileName( filePath )
results_folder = "#{RESULTS_FOLDER}#{fileName}/"


class Species
  attr_accessor :name, :files

  def initialize(name, files)
    @name = name
    @files = files
  end
end

#
#  jojo file format is for chromosome comparison
#
#  syntax:   kw      sname cfiles
#  example:  species Human chr2.fa  
#            species Chimp chr2A.fa chr2B.fa
#  
#     kw = keyword
#     sname = species name
#     cfiles = list of chromosome files
#
#  Outputs a script for converting the comparison into a PNG image
#
#  Everything output to a folder with file name
#
lines = File.open(filePath, "r").readlines
species = []
lines.each do |line|
  line.chomp!
  data = line.split
  if (data[0].downcase == "species") then
    speciesName = data[1]
    fileList = [].concat(data[2..-1])
    species[species.length] = Species.new( speciesName, fileList )
  end
end

class Step
  def initialize
    @stepNo = 0
  end

  def pStep( s )
    @stepNo += 1
    print "#\n"
    print "# Step #{@stepNo}: #{s}\n"
    print "#\n"
  end
end

def condense( resolution )
  if (resolution > 1000) then
    resolution = resolution/1000
    return "#{resolution}K"
  else
    return resolution
  end
end

def outputScript( speciesList, results_folder, resolution, factor, configFile, width )
  speciesNumber = 0
  speciesList.each do |s|
    print "#\n"
    speciesNumber += 1
    print "# Species #{speciesNumber}: #{s.name}\n"
    s.files.each do |file|
      print "#   #{file}\n"
    end
  end

  step = Step.new

  step.pStep "Strip files down to minimal characters, sequence only"
  speciesList.each do |s|
    s.files.each do |file|
      print "ruby #{RUBY_PATH}strip_file.rb #{file} #{results_folder}#{file}.ACGT\n" 
    end
  end

  step.pStep "Generate scripts that compare files against each other"
  (0..(speciesList.length - 2)).each do |s1offset|
    ((s1offset+1)..(speciesList.length - 1)).each do |s2offset|
      (0..(speciesList[s1offset].files.length-1)).each do |s1fileoffset|
        s1file = "#{results_folder}#{speciesList[s1offset].files[s1fileoffset]}.ACGT"
        (0..(speciesList[s2offset].files.length-1)).each do |s2fileoffset|
          s2file = "#{results_folder}#{speciesList[s2offset].files[s2fileoffset]}.ACGT"
          script_file = "#{results_folder}compare_script.#{s1offset}x#{s1fileoffset}v#{s2offset}x#{s2fileoffset}\n"
          print "ruby #{RUBY_PATH}gen_compare_script.rb #{s1file} #{s2file} #{results_folder} #{resolution} #{factor} #{width} > #{script_file}\n"
          print "dos2unix #{script_file}\n"
          print "chmod +x #{script_file}\n"
        end
      end
    end
  end

  step.pStep "Run the file comparison scripts"
  (0..(speciesList.length - 2)).each do |s1offset|
    ((s1offset+1)..(speciesList.length - 1)).each do |s2offset|
      (0..(speciesList[s1offset].files.length-1)).each do |s1fileoffset|
        s1file = "#{results_folder}#{speciesList[s1offset].files[s1fileoffset]}.ACGT"
        (0..(speciesList[s2offset].files.length-1)).each do |s2fileoffset|
          s2file = "#{results_folder}#{speciesList[s2offset].files[s2fileoffset]}.ACGT"
          script_file = "#{results_folder}compare_script.#{s1offset}x#{s1fileoffset}v#{s2offset}x#{s2fileoffset}\n"
          print "#{script_file}\n"
        end
      end
    end
  end

  step.pStep "Generate the grid data"
  (0..(speciesList.length - 2)).each do |s1offset|
    ((s1offset+1)..(speciesList.length - 1)).each do |s2offset|
      (0..(speciesList[s1offset].files.length-1)).each do |s1fileoffset|
        s1file = "#{extractFileName(speciesList[s1offset].files[s1fileoffset])}"
        (0..(speciesList[s2offset].files.length-1)).each do |s2fileoffset|
          s2file = "#{extractFileName(speciesList[s2offset].files[s2fileoffset])}"
          grid_file = "#{results_folder}grid.#{s1offset}x#{s1fileoffset}v#{s2offset}x#{s2fileoffset}\n"
          print "ruby #{RUBY_PATH}gen_csv2grid_script.rb #{configFile} #{s1file} #{s2file} #{results_folder} > #{grid_file}\n"
          print "dos2unix #{grid_file}\n"
          print "chmod +x #{grid_file}\n"
          print "#{grid_file}\n"
        end
      end
    end
  end

  step.pStep "Condense grid data to one screen whole genome image"
  (0..(speciesList.length - 2)).each do |s1offset|
    ((s1offset+1)..(speciesList.length - 1)).each do |s2offset|
      (0..(speciesList[s1offset].files.length-1)).each do |s1fileoffset|
        s1file = "#{extractFileName(speciesList[s1offset].files[s1fileoffset])}"
        (0..(speciesList[s2offset].files.length-1)).each do |s2fileoffset|
          s2file = "#{extractFileName(speciesList[s2offset].files[s2fileoffset])}"
          grid_file = "#{results_folder}#{s1file}_#{s2file}.txt"
          print "ruby #{RUBY_PATH}condense.rb #{grid_file}\n"
          print "ruby #{RUBY_PATH}grid2png.rb #{grid_file}\n"
          print "mv x.png #{grid_file}.png\n"
          print "ruby #{RUBY_PATH}grid2png.rb #{grid_file}.x10\n"
          print "mv x.png #{grid_file[0..-5]}.x10.png\n"
        end
      end
    end
  end
end

print "set -x\n"
print "mkdir -p #{results_folder}\n"
outputScript( species, results_folder, resolution, factor, configFile, width )
