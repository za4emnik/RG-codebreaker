module Loader

  def save_achievement(scores)
    File.open('./data/data.yml', 'a') do |f|
      f.puts "name: #{scores[:user_name]} attempts: #{scores[:attempts]} hints: #{scores[:hints]} secret_code: #{scores[:secret_code]}"
    end
  end

  def read_achievements
    File.readlines('./data/data.yml')
  end

end
