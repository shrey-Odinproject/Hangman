# frozen_string_literal: true

require 'yaml'

class Hangman
  attr_accessor :sec_word, :tries, :guess_word

  def initialize
    @sec_word = make_sec_word
    @tries = 7
    @guess_word = '_' * sec_word.length
  end

  def to_s
    %{
    tries left: #{tries}
    current guess: #{guess_word}
    man status: #{display_hangman(tries)}
      }
  end

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
    # allows 0/1 as it is for saving & sace nd cont..
    str[/[a-zA-Z01]+/] == str
  end

  def ask_guess # gets proper input from user
    puts 'Enter ur guess, press 0 to save & quit, 1 to save & continue'
    input = gets.chomp
    if input.length > 1 || !all_letters(input)
      puts 'Error Input!!!'
      ask_guess
    end
    input
  end

  def hints(guess, sec_word, guess_word) # takes in guess and updates user guess
    sec_word.split('').each_with_index do |_letter, idx|
      if sec_word.downcase[idx] == guess.downcase
        guess_word[idx] = sec_word[idx]
      end
    end
    guess_word
  end

  def play
    while tries > 0
      guess = ask_guess
      if guess.upcase == '0'
        save_to_file(self)
        puts 'Saved !!'
        break
      elsif guess.upcase == '1'
        save_to_file(self)
        puts 'Saved and resuming'
      end
      self.tries -= 1 unless sec_word.include?(guess) || guess == '0' || guess == '1'

      puts display_hangman(tries)
      puts hints(guess, sec_word, guess_word)

      return puts 'YOU WIN!!!!' if guess_word == sec_word
    end
    if tries == 0
      puts "YOU LOSE!!!! word was #{sec_word}"
    else
      puts 'QUITTING'
    end
  end

  def save_to_file(hangman_obj)
    File.open('blah.yaml', 'w') do |save_file|
      save_file.puts YAML::dump(hangman_obj)
    end
  end

  def self.load_from_file # had to make this a class method cause u cant load instance by calling load on another instance
    File.open('blah.yaml', 'r') do |save_file|
      YAML::load(save_file)
    end
  end
end

def new_game_or_load_save
  puts "Press only 'enter' for New Game, l to load a save file"
  input = gets.chomp.downcase
  if input == ''
    puts 'New Game Of Hangman !'
    Hangman.new.play
  elsif input == 'l'
    puts 'Save load succesfull!'
    loaded_obj = Hangman.load_from_file
    puts loaded_obj
    loaded_obj.play
  end
  rerun
end

def rerun
  puts "Would you like to rerun Press 'y' for yes or 'any other key' for no."
  repeat_input = gets.chomp.downcase
  if repeat_input == 'y'
    new_game_or_load_save
  else
    puts 'Thanks for playing!'
  end
end

new_game_or_load_save

# puts 'make saves folder where all yamls are stored???'
