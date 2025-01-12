module MasterMind
  class Game
    COLORS = ['blue', 'green', 'orange', 'red', 'yellow']
    AMOUNT = 4

    attr_reader :player_1, :player_2, :attempts

    def initialize(player_1_class, player_2_class, attempts = 8)
      @player_1 = player_1_class # Codebreaker
      @player_2 = player_2_class # Encoder
      @attempts = attempts
    end

    def play
      secret = player_2.get_colors('secret')
      guess = player_1.get_colors('guess')
      tries = 1
      until won?(secret, guess) || tries == attempts
        give_feedback(secret, guess)
        guess = player_1.get_colors('guess')
        tries += 1
      end
      if tries < attempts
        give_feedback(secret, guess)
        puts "\nThe code has been broken!"
      else
        give_feedback(secret, guess)
        puts "\nThe encoder has won!"
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
      Game::COLORS.each_with_index { |col, ind| puts "#{ind + 1}: #{col.capitalize}" }
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
        Game::COLORS.each_with_index { |col, ind| puts "#{ind + 1}: #{col.capitalize}" }
        chosen = gets.chomp
      end
    
      chosen_arr = chosen.split(',').map { |num| Game::COLORS[num.to_i - 1] }
    
      if mode.downcase == 'secret'
        puts "\nYour secret colors: #{chosen_arr.map(&:capitalize).join(', ')}"
      elsif mode.downcase == 'guess'
        puts "\nYour guess: #{chosen_arr.map(&:capitalize).join(' | ')}"
      end
    
      chosen_arr
    end
  end

  class ComputerPlayer
    def get_colors(mode)
      if mode.downcase == 'secret'
        Array.new(Game::AMOUNT) { Game::COLORS.sample }
      end

      if mode.downcase == 'guess'
        Array.new(Game::AMOUNT) { Game::COLORS.sample }
      end
    end

    # def make_guess
      
    # end
  end
end