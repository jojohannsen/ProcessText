if (ARGV.length == 0) then
  print "Usage: ruby mkhtml.rb <img file> [<more image files>]\n"
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

print "<html><body>\n"
ARGV.each do |imgFileName|
  print "<h2>#{abbreviate(imgFileName)}</h2>\n"
  print "<img src=\"#{imgFileName}\"/>\n"
end
print "</body></html>\n"
