require 'sqlite3'

class Post

  @@SQLITE_DB_FILE = 'notepad.sqlite'

  def self.post_types
    {'Memo' => Memo, 'Task' => Task, 'Link' => Link, 'Tweet' => Tweet} # указаны варианты постов
  end

  def self.create(type)
    post_types[type].new # создаем выбранный класс
  end

  def self.find_by_id(id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true

    result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)

    db.close

    if result.empty?
      puts "Такой id #{id} не найден в базе :("
      return nil
    else
      # Если массив не пустой, значит пост нашелся и лежит первым элементом.
      result = result[0]
      post = create(result['type'])

      post.load_data(result)

      post
    end
  end

  def self.find_all(limit, type)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = false

    # Формируем зпрос в базу с нежными условиями
    query = "SELECT rowid, * FROM posts "

    query += "WHERE type = :type" unless type.nil? # добавить значение, если теп не ноль
    query += "ORDER by rowid DESC "

    query += "LIMIT :limit " unless limit.nil?

    statement = db.prepare(query) # метод prepare готовит запрос к выполнению

    statement.bind_param('type', type) unless type.nil?
    statement.bind_param('limint', limit) unless limit.nil?

    result = statement.execute! # метод execute возвращает массив результатов, каждий
    # елемент является массивом уже содержавших значение всех полей

    statement.close
    db.close

    result
  end

  def initialize
    @created_at = Time.now
    @text = []
  end

  def read_from_console
    # todo
  end

  def to_strings
    # todo
  end

  def save
    file = File.new(file_path, "w:UTF-8")
    for item in to_strings do
      file.puts(item)
    end

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    current_path + "/" + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true

    db.execute(
          "INSERT INTO posts (" +
              to_db_hash.keys.join(',') +
              ")" +
              " VALUES (" +
              ('?,'*to_db_hash.keys.size).chomp(',') +
              ")",
          to_db_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close

    insert_row_id
  end

  def to_db_hash
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
  end

  # получает на вход хэш массив данных и должен заполнить свои поля
  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end
end
