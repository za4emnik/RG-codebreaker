module Console

  def want_more?
    puts 'Want more? y/n'
    return ['y','Y','д','Д'].include?(gets.chomp) ? true : false
  end

  def want_save_results?
    puts 'You won! Save results? y/n'
    return ['y','Y','д','Д'].include?(gets.chomp) ? true : false
  end

  def want_all_results?
    puts 'Show all results? y/n'
    return ['y','Y','д','Д'].include?(gets.chomp) ? true : false
  end

  def get_variant
    puts "Enter your variant"
    number = gets.chomp
    raise 'You must enter 4 numbers' if number.size < 4
    number
  end

  def show_try_again
    puts "You have #{self.attempts} attempts"
    puts self.response
  end

  def show_introduce
    puts 'Enter your name'
    self.name = gets.chomp
  end

  def show_results
    puts read_achievement.name
  end

end
