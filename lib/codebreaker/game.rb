module Codebreaker
  def self.generate_secret_code
    options = %w[1 2 3 4 5 6]
    (1..4).map { options.delete_at(rand(options.length))}.join
  end

  def self.init
    game = Game.new(STDOUT, 5)
    secret_code = generate_secret_code
    puts secret_code                                                     #delete this!
    game.start(secret_code)
  end

  class Game
    def initialize(output, max_guess = 5)
      @output = output
      @max_guess = max_guess
      @current_guess = 0
    end

    def start(secret)
      @secret = secret
      @output.puts "Welcome to Codebreaker! You have #{@max_guess} guesses and 2 hints"
      @output.puts 'Enter guess:'
      continue
    end

    def guess(guess)
      marker = Marker.new(@secret, guess)
      @output.puts '+'*marker.exact_match_count + '-'*marker.number_match_count
      @current_guess += 1
      if marker.exact_match_count == 4
        @output.puts "You win at #{@current_guess} guess! Enter your name:"
        save_result(gets.chomp)
        gameover(false)
      else
        @output.puts "You have #{@max_guess - @current_guess} guess(es) left"
      end
    end

    def hint
      numbers = [nil, 'first', 'second', 'third']
      @current_hint ||= 0
      if @current_hint < 2
        @current_hint += 1
        @current_guess += 1
        @output.puts "The #{numbers[@current_hint]} number is: #{@secret[@current_hint - 1]}"
        @output.puts "You have #{2 - @current_hint} hint(s) left"
        @output.puts "You have #{@max_guess - @current_guess} guess(es) left"
      else
        @output.puts "You have already used all your hints"
      end
    end

    def continue
      while @current_guess < @max_guess do
        param = gets.chomp
        case param
        when 'h'
          hint
        when 'q'
          quit
        else
          guess(param)
        end
      end
      gameover
    end

    def gameover(show_secret = true)
      @output.puts 'You lose...'
      @output.puts "\n***\nThe secret code was: #{@secret}\n***" if show_secret
      play_again
    end

    def play_again
      @output.puts 'Play again? (y or n)'
      case gets.chomp[0]
      when 'y'
        Codebreaker::init
      else
        quit
      end
    end

    def quit
      @output.puts 'Farewell!'
      exit
    end

    def save_result(name)
      if name.length > 0
         File.open("scores.txt", 'a') { |file| file.puts "#{name} has won on #{@current_guess} guess" }
      end
    end
  end
end