module Hangman

  class Game 
    word = ""
    until word.length.between?(5, 12)
      random_line = rand(10000) - 1
      dictionary = 
      File.open("dictionary.txt") do |line|
        while random_line > 0
          random_line -= 1
          word = line.gets
        end
        puts word
      end
    end
  end
  game = Game.new
end

