require 'twitter'

class Tweet < Post

  @@CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key = ''
    config.consumer_secret = ''
    config.access_token = ''
    config.access_token_secret = ''
  end

  def read_from_console
    puts "Новый твит (140 символов!):"

    @text = STDIN.gets.chomp[0..140]

    puts "Отправляем ваш твит: #{@text.encode('utf-8')}"
    @@CLIENT.update(@text.encode('utf-8'))
    puts "Твит отправлен"
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    @text.unshift(time_string)
  end

  def to_db_hash # метод супер вызывает родительский метод с таким же названием
    super.merge('text' => @text)
  end

  def load_data(data_hash)
    super(data_hash) # сперва дергаем родительский метод для инициализации общих полей

    # теперь прописываем свое специфичное поле
    @text = data_hash['text'].split('\n\r')
  end
end
