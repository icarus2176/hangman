module Hangman

  class Game
    def play_game
      @word = new_game
      @wrong_guesses = 6
      @correct_letters = []
      @wrong_letters = []

      until @wrong_guesses == 0
        @wrong_guesses -= turn
      end
      lose
    end
    
    private

    def new_game 
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

      if @word.include?(guess)
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
      puts "You have #{@wrong_guesses} wrong guesses remaining."
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
  end

  game = Game.new
  game.play_game
end

