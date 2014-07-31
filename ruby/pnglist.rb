lines = File.open("x.pnglist", "r").readlines
txt = "ruby ../ruby/mkhtml.rb "
lines.each do |line|
  line.chomp!
  txt = "#{txt} #{line}"
end
txt = "#{txt} > x.html"
print "#{txt}\n"
txt = "ruby ../ruby/mkhtml2.rb "
lines.each do |line|
  line.chomp!
  txt = "#{txt} #{line}"
end
txt = "#{txt} > x.div"
print "#{txt}\n"
