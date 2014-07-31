if (ARGV.length == 0) then
  print "Usage: ruby mkhtml2.rb <img file> [<more image files>]\n"
  exit
end

class String
    def is_i?
       !!(self =~ /\A[-+]?[0-9]+\z/)
    end
end

def expecting(result, cval)
  if (result == "") then
    return true
  elsif (cval == cval.upcase) then
    return true
  elsif (result[result.length-1] == '_') then
    return true
  elsif (cval.is_i?) then
    return true
  elsif (result[result.length-1] == '.') then
    return false
  else
    return false
  end
end

def abbreviate(name)
  result = ""
  if (name == nil) then return result end
  name.each_char do |cval|
    if (expecting(result, cval)) then
      if (cval == "/") then
        return result
      else
        result = "#{result}#{cval}"
      end
    end
  end
  return result
end


COLUMNS = 10

if (COLUMNS == 2) then
  ARGV.each do |imgFileName|
    print "<div class=\"section group\">\n"
    print "  <div class=\"col span_1_of_2\">#{abbreviate(imgFileName)}</div>\n"
    print "  <div class=\"col span_1_of_2\">\n"
    print "    <img src=\"../genome/#{imgFileName}\"/>\n"
    print "  </div>\n"
    print "</div>\n"
  end
end

if (COLUMNS > 2) then
  current_column_offset = 0
  while (current_column_offset < ARGV.length) do
    print "<div class=\"section group\">\n"
    (1..COLUMNS).each do
      if (current_column_offset < ARGV.length)
        imgFileName = ARGV[current_column_offset]
        current_column_offset += 1
        print "  <div class=\"col span_1_of_#{COLUMNS}\">\n"
        print "    <img src=\"../genome/#{imgFileName}\"/>\n"
        print "    <br/>#{abbreviate(imgFileName)}\n"
        print "  </div>\n"
      end
    end
    print "</div>\n"
  end
     
end
