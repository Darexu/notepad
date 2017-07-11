
require 'twitter'

class Tweet < Post

  @@CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key = '05xwEwc8wQR59WrESX9PwyfiP'
    config.consumer_secret = 'IWX3Ezd2D12jSjphVZ2IAkJA8oX4Ak2YplfwfZMLxJFLTJYAEx'
    config.access_token = '884177469221339136-I2rLAm7GhFarqs0KJX8GnSydPyxk83v'
    config.access_token_secret = 'Usy7331CdWsTmEQuMc1ggms6Qry3fKb4kiTakUUGSN5VX'
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

    return @text.unshift(time_string)
  end

  def to_db_hash # метод супер вызывает родительский метод с таким же названием
    return super.merge(
        {
            'text' => @text # массив строк делаем одной большой строкой
        }
    )
  end

  def load_data(data_hash)
    super(data_hash) # сперва дергаем родительский метод для инициализации общих полей

    # теперь прописываем свое специфичное поле
    @text = data_hash['text'].split('\n\r')
  end

end