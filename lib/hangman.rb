require "csv"

module Hangman

  class Game
    def start
      saves = CSV.open("saves.csv")

      @saves_number = saves.readlines.size - 1

      if @saves_number > 0
        puts "Would you like to load a save file? y/n"
        answer = gets.chomp.downcase
        if answer == "y"
          puts "You have #{@saves_number}, enter a number."
          answer = gets.chomp.downcase
          load_game(answer.to_i)
        end
      end
      new_game
    end

    def new_game
      @word = create_word
      @remaining_guesses = 6
      @correct_letters = []
      @wrong_letters = []
      
      play_game
    end

    def play_game 
      puts "At any point type save then press enter to save your game."
      until @remaining_guesses == 0
        @remaining_guesses -= turn
      end
      lose
    end 
    private

    def create_word 
      word = ""
      until word.length.between?(5, 12)
        random_line = rand(10000) - 1
        dictionary = 
        File.open("dictionary.txt") do |line|
          while random_line > 0
            random_line -= 1
            word = line.gets.chomp.downcase
          end
        end
      end
      word.split("")
    end

    def turn 
      display
      puts "Guess a letter then press enter."
      guess = gets.chomp.downcase

      if guess == "save"
        save_game
      elsif @word.include?(guess)
        @correct_letters.push(guess)
        if check_win
          win
        end
        0
      else
        @wrong_letters.push(guess)
        1
      end
    end

    def display
      result = ""
      @word.each do |letter|
        if @correct_letters.include?(letter)
          result += letter
        else
          result += "_"
        end
      end
      puts result
      puts "Correct guesses: #{@correct_letters}"
      puts "Wrong guesses: #{@wrong_letters}"
      puts "You have #{@remaining_guesses} wrong guesses remaining."
    end

    def win
        puts "You win! The word was #{@word}"
        play_again
    end

    def lose
      puts "You lose! The word was #{@word}"
      play_again
    end

    def check_win
      all_include = true
      @word.each do |letter|
        if @correct_letters.none?(letter)
          all_include = false
        end
      end
      all_include
    end

    def play_again
      puts "Would you like to play again? y/n"
      answer = gets.chomp.downcase
  
      if answer == "y"
        play_game
      end
    end

    def save_game

      saves = CSV.open(
        "saves.csv",
        "r+",
        headers: true,
        header_converters: :symbol
      )
      for i in 0..@saves_number 
        saves.readline
      end
      @saves_number += 1
      saves << [@saves_number, @word.join, @remaining_guesses,
        @correct_letters.join, @wrong_letters.join]
      
      puts "Save sucessful."
      turn
    end

    def load_game(save_number)
      saves = CSV.open(
        "saves.csv",
        "r",
        headers: true,
        header_converters: :symbol
      )

      for i in 1..save_number
        save_file = saves.readline
      end

      @word = save_file[1].split("")
      @remaining_guesses = save_file[2]
      @correct_letters = save_file[3].split("")
      @wrong_letters = save_file[4].split("")
      puts @word.class
      play_game
    end
  end

  game = Game.new
  game.start
end