# frozen_string_literal: true

def make_sec_word # creates a word to guess
  file = File.open('5desk.txt', "r")
  lines = file.readlines
  line = lines[rand(61406)]
  file.close
  if line.length > 4 && line.length < 13
    line.chomp
  else
    make_sec_word
  end
end

def display_hangman(tries) # takes in num of tries and displays appropriate figure
  stages = [ # final state: head, torso, both arms, and both legs
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

def all_letters(str)
  # Use 'str[/[a-zA-Z]*/] == str' to let all_letters
  # yield true for the empty string
  # allows 0 as it is for saving
  str[/[a-zA-Z0]+/] == str
end

def ask_guess # gets proper input from user
  puts 'Enter ur guess press 0 to save'
  input = gets.chomp
  if input.length > 1 || !all_letters(input)
    puts 'Error Input!!!'
    ask_guess
  end
  return input
end

def hints(guess, sec_word, guess_word) # gives hints and hangman status
  sec_word.split('').each_with_index do |_letter, idx|
    if sec_word.downcase[idx] == guess.downcase
      guess_word[idx] = sec_word[idx]
    end
  end
  guess_word
end

def save(tries, sec_word, guess_word)
end

def play
  tries = 7
  sec_word = make_sec_word
  guess_word = '_' * sec_word.length
  # puts 'word is : ' + sec_word
  while tries > 0
    guess = ask_guess
    if !sec_word.include?(guess)
      tries -= 1
    end
    puts display_hangman(tries)
    puts hints(guess, sec_word, guess_word)
    if guess_word == sec_word
      return puts 'YOU WIN!!!!'
    end
  end
  return puts "YOU LOSE!!!! word was #{sec_word}"
end

def new_game_or_load_save
  puts 'Press only enter for new game'
  input = gets.chomp
  if input == ''
    puts 'New Game Of Hangman'
    play
  end
  rerun
end

def rerun
  puts "Would you like to rerun Press 'y' for yes or 'n' for no."
  repeat_input = gets.chomp.downcase
  if repeat_input == 'y'
    new_game_or_load_save
  else
    puts 'Thanks for playing!'
  end
end

new_game_or_load_save
