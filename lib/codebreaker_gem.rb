require 'codebreaker_gem/version'
require 'codebreaker_gem/codebreaker'
require 'codebreaker_gem/loader'
require 'yaml'

module CodebreakerGem
  class Game

    include Loader

    HINTS = 3
    ATTEMPTS = 15

    attr_reader :response, :attempts, :hints, :hint, :secret_code
    attr_accessor :guess

    def initialize
      @response = []
      @hints = HINTS
      @attempts = ATTEMPTS
    end

    def generate_code()
      @secret_code = 4.times.map{ Random.rand(1...6) }.join.to_s
    end

    def check
      return @response = '+' * @secret_code.length if @secret_code == @guess
      code, guess = @secret_code.split('').zip(@guess.split('')).delete_if { |item| item[0] == item[1] }.transpose
      if !code || !guess
        @response = ['+'] * @secret_code.length
      else
        @response = ['+'] * (@secret_code.length - code.length)
        @response.concat(get_minuses(code, guess))
      end
      @response = @response.join.to_s
      @attempts -= 1
    end

    def get_hint
      @hint = @hints >= 1 ? @secret_code.split('').sample : false
      @hints -= 1 if @hints > 0
      @attempts -= 1
    end

    def get_scores
      scores = Hash.new
      scores[:hints] = HINTS - @hints
      scores[:attempts] = ATTEMPTS - @attempts
      scores[:secret_code] = @secret_code
      scores
    end


    private

    def get_minuses(code, guess)
      minuses = []
      code.each do |item|
        next unless guess.include?(item)
          code[code.index(item)] = nil
          guess[guess.index(item)] = nil
          minuses << '-'
      end
      minuses
    end
  end
end
