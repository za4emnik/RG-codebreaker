require 'codebreaker_gem/version'
require 'codebreaker_gem/console'
require 'codebreaker_gem/loader'
require 'yaml'

module CodebreakerGem
  class Game

    include Console
    include Loader

    attr_reader :response, :attempts
    attr_accessor :name

    def initialize
      @response = []
    end

    def start
      @attempts = 3
      @hints = 1
      @secret_code = generate_code

      until @attempts < 1  do
        @attempts -= 1
        @input = get_variant
        if @input == 'hint' && @hints >= 1
          hint
          @input = get_variant
        else
          check
        end
        if @secret_code == @input
          you_won
          break
        else
          show_try_again
        end
      end
    end

    def you_won
      if want_save_results?
        show_introduce
        save_achievement
      end
      show_results if want_all_results?
      self.start if want_more?
    end

    private
    def generate_code(number=4)
      number.times.map{ Random.rand(1...6) }.join.to_s
    end

    def hint
      puts @secret_code.split("").sample
      @hints -= 1
    end

    def check
      @input.split("").each_with_index do |item, index|
      @response[index] = if @secret_code[index] == item
                          '+'
                        elsif @secret_code.include?(item)
                          '-'
                        else
                          '*'
                        end
      end
    end

  end
end
