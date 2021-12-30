def make_sec_word # creates a word to guess
  file = File.open('5desk.txt', "r")
  lines = file.readlines
  line = lines[rand(61406)]
  file.close
  if line.length > 4 && line.length < 13
    line
  else
    make_sec_word
  end
end

def display_hangman(tries) # takes in num of tries and displays appropriate figure
  stages = [  # final state: head, torso, both arms, and both legs
              """
                 --------
                 |      |
                 |      O
                 |     \\|/
                 |      |
                 |     / \\
                 -
              """,
              # head, torso, both arms, and one leg
              """
                 --------
                 |      |
                 |      O
                 |     \\|/
                 |      |
                 |     / 
                 -
              """,
              # head, torso, and both arms
              """
                 --------
                 |      |
                 |      O
                 |     \\|/
                 |      |
                 |      
                 -
              """,
              # head, torso, and one arm
              """
                 --------
                 |      |
                 |      O
                 |     \\|
                 |      |
                 |     
                 -
              """,
              # head and torso
              """
                 --------
                 |      |
                 |      O
                 |      |
                 |      |
                 |     
                 -
              """,
              # head
              """
                 --------
                 |      |
                 |      O
                 |    
                 |      
                 |     
                 -
              """,
              # initial empty state
              """
                 --------
                 |      |
                 |      
                 |    
                 |      
                 |     
                 -
              """
  ]
  return stages[tries]
end

def ask_guess
  puts 'enter ur guess'
  input=gets.chomp
end

def hints(guess,sec_word)
  
end

def play
  tries=0
  sec_word=make_sec_word
  while tries<=7
    guess=ask_guess
    puts display_hangman(tries)
    tries+=1
  end
end

play