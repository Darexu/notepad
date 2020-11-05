if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'post'
require_relative 'link'
require_relative 'task'
require_relative 'memo'
require_relative 'tweet'

puts "Привет, я твой блокнот!"
puts "Что хотите записать в блокнот?"
# Сохраняем в переменную choices варианты постов, которые есть
choices = Post.post_types.keys

choice = -1 # указываем неверное значение

until choice >= 0 && choice < choices.size
  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end

  choice = STDIN.gets.chomp.to_i
end

entry = Post.create(choices[choice])

entry.read_from_console

save_type = 0

until save_type.between?(1,2)
  puts "1. Сохранить запись в файл"
  puts "2. Сохранить запись в базу"
  save_type = STDIN.gets.chomp.to_i
end

case save_type
when 1 then entry.save
when 2 then entry.save_to_db
end

puts "Ура, запись сохранена"
