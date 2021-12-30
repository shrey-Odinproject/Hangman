
def make_sec_word
  file=File.open('5desk.txt', "r")
  lines = file.readlines
  line=lines[rand(61408)]
  file.close
  if line.length > 4 && line.length<13
    line
  else
    make_sec_word
  end
end

20.times {puts make_sec_word}


  