require 'chunky_png'

if (ARGV.length < 1) then
  print "Usage: ruby grid2png.rb <file1> [<file2>...<fileN>]\n"
  print "\n"
  print "  Outputs a single image\n"
  exit
end

BOUNDARY_WIDTH = 1
xDimension = BOUNDARY_WIDTH
yDimension = BOUNDARY_WIDTH

ARGV.each do |fileName|
  file = File.open(fileName, "r")
  lines = file.readlines
  lines[0].chomp!
  xDimension += lines[0].length
  xDimension += BOUNDARY_WIDTH
  if (yDimension == BOUNDARY_WIDTH) then
    yDimension += lines.length
  end
  file.close
end

class Renderer
  def initialize(png, curX, curY)
    @png = png
    @curX = curX
    @curY = curY
    @c1 = ChunkyPNG::Color.rgb( 10, 80, 10)
    @c2 = ChunkyPNG::Color.rgb( 10, 150, 10)
    @c3 = ChunkyPNG::Color.rgb( 10, 255, 20)
    @c9 = ChunkyPNG::Color.rgb( 255, 10, 10)
    @c8 = ChunkyPNG::Color.rgb( 150, 10, 10)
    @c7 = ChunkyPNG::Color.rgb( 80, 10, 10)
  end

  def render(lines)
    lines.each do |line|
      line.chomp!
      xScan = @curX
      line.each_char do |cval|
        if (cval == '1') then
          @png.set_pixel(xScan, @curY, @c1)
        elsif (cval == '2') then
          @png.set_pixel(xScan, @curY, @c2)
        elsif (cval == '3') then
          @png.set_pixel(xScan, @curY, @c3)
        elsif (cval == '9') then
          @png.set_pixel(xScan, @curY, @c9)
        elsif (cval == '8') then
          @png.set_pixel(xScan, @curY, @c8)
        elsif (cval == '7') then
          @png.set_pixel(xScan, @curY, @c7)
        end
        xScan += 1
      end
      @curY += 1
    end
  end
end

print "xDimension #{xDimension}, yDimension #{yDimension}\n"
png = ChunkyPNG::Image.new(xDimension, yDimension, ChunkyPNG::Color.rgba(30, 30, 200, 200))
black = ChunkyPNG::Color.rgba(0, 0, 0, 255)
gray = ChunkyPNG::Color.rgba(33, 33, 33, 255)
red = ChunkyPNG::Color.rgba(255,20,20,255)
currentImageX = BOUNDARY_WIDTH
currentImageY = BOUNDARY_WIDTH
ARGV.each do |fileName|
  file = File.open(fileName, "r")
  lines = file.readlines
  line0 = lines[0]
  line0.chomp!
  print "Draw rect(#{currentImageX}, #{currentImageY}, #{currentImageX + line0.length - 1}, #{currentImageY+lines.length})\n"
  png.rect(currentImageX, currentImageY, currentImageX + line0.length - 1, currentImageY + lines.length - 1, black, black)

  renderer = Renderer.new(png, currentImageX, currentImageY)
  renderer.render(lines)
  currentImageX += lines[0].length
  currentImageX += BOUNDARY_WIDTH
  file.close
end

png.save("x.png")


