module Loader

  def save_achievement
    File.open('./data/data.yml', 'a') do |f|
      f.write self.to_yaml
    end
  end

  def read_achievement
    YAML.load_file('./data/data.yml')
  end

end
