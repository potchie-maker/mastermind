require 'colorize'

module MasterMind
  class Game
    COLORS = ['blue', 'green', 'magenta', 'red', 'yellow']
    AMOUNT = 4 # Amount of colors for the secret code/guesses

    attr_reader :code_breaker, :encoder, :attempts

    def initialize(code_breaker, encoder)
      @code_breaker = code_breaker
      @encoder = encoder
      @attempts = 12
    end

    def play
      secret = encoder.get_colors('secret')
      guess = code_breaker.get_colors('guess')

      tries = 1
      until won?(secret, guess) || tries == attempts
        give_feedback(secret, guess)
        guess = code_breaker.get_colors('guess')
        tries += 1
      end
      if tries < attempts
        give_feedback(secret, guess)
        puts "\nThe code has been broken!"
        puts "The Codebreaker wins!"
      else
        give_feedback(secret, guess)
        puts "\nThe code was not broken!"
        puts "The Encoder wins!"
        puts "\nThe secret code was: #{secret.map{ |col| col.capitalize.colorize(col.to_sym) }.join(' | ')}"
      end
    end

    def self.choose_role
      puts "Would you like to be the Codebreaker or the Encoder?"
      puts "Enter 1 for Codebreaker, or 2 for Encoder"
      role = nil

      until %w[1 2].include?(role)
        role = gets.chomp
        puts "Invalid input. Please enter 1 for Codebreaker or 2 for Encoder." unless %w[1 2].include?(role)
      end

      if role == '1'
        return MasterMind::Game.new(HumanPlayer.new, ComputerPlayer.new)
      elsif role == '2'
        return MasterMind::Game.new(ComputerPlayer.new, HumanPlayer.new)
      end
    end

    def won?(secret, guess)
      secret == guess
    end

    def give_feedback(secret, guess)
      secret_copy = secret.dup
      feedback = []

      guess.each_with_index do |col, i|
        if secret[i] == col
          feedback << 'match'
          secret_copy[i] = nil
        end
      end

      guess.each_with_index do |col, i|
        next if secret[i] == col
        if secret_copy.include?(col)
          feedback << 'exists'
          secret_copy[secret_copy.index(col)] = nil
        end
      end
      puts "\nFeedback: #{feedback.shuffle.join(' | ')}"
    end
  end

  class HumanPlayer
    def get_colors(mode)
      puts ''
      Game::COLORS.each_with_index { |col, ind| puts "#{ind + 1}: #{col.capitalize.colorize(col.to_sym)}" }
      if mode.downcase == 'secret'
        puts "\nChoose your secret colors from the list of by their assigned number"
      elsif mode.downcase == 'guess'
        puts "\nMake your guess"
      end
      puts "Example input: 1,1,1,1"
      chosen = gets.chomp
    
      until chosen.match?(/^(\d(,\d){#{Game::AMOUNT - 1}})$/)
        puts "\nInvalid input"
        puts "Example input: 1,1,1,1"
        puts ''
        Game::COLORS.each_with_index { |col, ind| puts "#{ind + 1}: #{col.capitalize.colorize(col.to_sym)}" }
        chosen = gets.chomp
      end
    
      chosen_arr = chosen.split(',').map { |num| Game::COLORS[num.to_i - 1] }
    
      if mode.downcase == 'secret'
        puts "\nYour secret colors: #{chosen_arr.map{ |col| col.capitalize.colorize(col.to_sym) }.join(', ')}"
      elsif mode.downcase == 'guess'
        puts "\nYour guess: #{chosen_arr.map{ |col| col.capitalize.colorize(col.to_sym) }.join(' | ')}"
      end
    
      chosen_arr
    end
  end

  class ComputerPlayer
    def get_colors(mode)
      case mode.downcase
      when 'secret'
        puts "\nThe computer has chosen the secret colors"
        Array.new(Game::AMOUNT) { Game::COLORS.sample }
      when 'guess'
        guess = Array.new(Game::AMOUNT) { Game::COLORS.sample }
        puts "\nComputer guess: #{guess.map{ |col| col.capitalize.colorize(col.to_sym) }.join(' | ')}"
        guess
      end
    end
  end
end