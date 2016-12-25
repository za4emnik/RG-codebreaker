module Codebreaker

  class Console

    def initialize
      @game = CodebreakerGem::Game.new
      @game.generate_code
      @guess = ''
    end

    def run
      while @game.attempts > 0  do
        get_guess
        case @guess
          when @game.secret_code
            you_won
            break
          when 'hint'
            @game.get_hint
            show_hint
          else
            @game.guess = @guess
            @game.check
            show_response
          end
      end
      you_loose if @game.attempts <= 0
    end

    def new_game
      Codebreaker::Console.new.run
    end

    def you_won
      puts 'You won!'
      save_game
      show_all_achievements
      new_game if want_more?
    end

    def you_loose
      puts 'You loose :('
      new_game if want_more?
    end

    def show_hint
      puts "You have #{@game.hints} hints"
      puts @game.hint ? "HINT: #{@game.hint}" : 'Sorry, but you have used all the hints :('
    end

    def get_guess
      puts "Enter your guess"
      @guess = gets.chomp
      raise 'You must enter 4 numbers' if @guess.size < 4
    end

    def want_more?
      puts 'Want more? y/n'
      return ['y','Y','д','Д'].include?(gets.chomp) ? true : false
    end

    def show_response
      puts "You have #{@game.attempts} attempts"
      puts @game.response
    end

    def show_all_achievements
      puts 'Achievements table'
      @game.read_achievements.each do |line|
        puts line
      end
    end

    def save_game
      puts 'Enter your name'
      scores = @game.get_scores
      scores[:user_name] = gets.chomp
      @game.save_achievement(scores)
    end

  end
end
