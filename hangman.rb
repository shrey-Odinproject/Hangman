# frozen_string_literal: true

require 'yaml'

class Hangman
  attr_accessor :sec_word, :tries, :guess_word, :already_guessed

  def initialize
    @sec_word = make_sec_word
    @tries = 7
    @guess_word = '_' * sec_word.length
    @already_guessed = []
  end

  def to_s
    %{
    tries left: #{tries}
    current guess: #{guess_word}
    already guessed: #{already_guessed.join(' ')}
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
    print "Enter ur guess, press 0 to save & quit, 1 to save & continue: "
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
      if already_guessed.include?(guess)
        puts 'U already guessed this letter'
        next
      else
        already_guessed.push(guess)
      end
      puts "u have guessed -> #{already_guessed.join(' ')}"
      if guess.upcase == '0'
        save_to_file(self)
        puts 'Saved !!'
        break
      elsif guess.upcase == '1'
        save_to_file(self)
        puts 'Saved !! and resuming'
      end
      self.tries -= 1 unless sec_word.include?(guess) || guess == '0' || guess == '1'

      puts display_hangman(tries)
      puts hints(guess, sec_word, guess_word)

      return puts 'YOU WIN !!' if guess_word == sec_word
    end
    if tries == 0
      puts "YOU LOSE !! word was: #{sec_word}"
    else
      puts 'Quit'
    end
  end

  def save_to_file(hangman_obj)
    Dir.mkdir('saves') unless Dir.exist?('saves') # holds all yaml saves user makes
    print 'enter name of save file: '
    input = gets.chomp
    File.open("saves/#{input}.yaml", 'w') do |save_file|
      save_file.puts YAML::dump(hangman_obj)
    end
  end

  def self.load_from_file # had to make this a class method cause u cant load instance by calling load on another instance
    Dir["saves/*"].each.with_index(1) { |file, idx| puts "#{idx} #{file}" }
    print 'To select the file to load enter only the filename: '
    input = gets.chomp
    if !File.exist?("saves/#{input}.yaml")
      puts 'No save found!!'
      puts '----------'
      load_from_file
    else
      puts 'Save load succesfull!'
      File.open("saves/#{input}.yaml", 'r') do |save_file|
        YAML::load(save_file)
      end
    end
  end
end

def new_game_or_load_save
  print "Press only 'enter' for New Game, l to load a Save File: "
  input = gets.chomp.downcase
  if input == ''
    puts 'New Game Of Hangman !'
    Hangman.new.play
  elsif input == 'l'
    loaded_obj = Hangman.load_from_file
    puts loaded_obj
    loaded_obj.play
  else
    puts 'error try again...'
    new_game_or_load_save
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
