require_relative 'table'
require 'pg'

conn = PG.connect(
  :host => 'localhost',
  :port => 5432,
  :dbname => 'project1',
  :user => 'postgres',
  :password => "31415936rctybz"
)

table1 = Table.new("schema1.users", conn)
table1.create_table
table1.clear_data

table2 = Table.new("schema1.users_additional_info", conn)
table2.create_table
table2.clear_data

table3 = Table.new("schema1.users_pictures", conn)
table3.create_table
table3.clear_data

def out_all_info(conn)
  conn.exec("SELECT u.user_id, u.email, u.nickname, uad.first_name, uad.last_name, uad.birthdate, uad.sex
FROM schema1.users u
JOIN schema1.users_additional_info uad
ON u.user_id = uad.users_additional_info_id") do |result|
    result.each do |row|
      puts row
    end
  end
rescue PG::Error => e
  puts e.message
end

def out_ava_info(conn)
  conn.exec("SELECT u.user_id, u.email, u.nickname
FROM schema1.users u") do |result|
    result.each do |row|
      puts row
      user_id = row["user_id"]
      conn.exec("SELECT upic.users_pictures_id, upic.picture_url, upic.picture_alt_text FROM schema1.users_pictures upic
WHERE upic.users_pictures_id = #{user_id} AND upic.picture_type = 2
        ORDER BY upic.users_pictures_id") do |result1|
        result1.each do |row1|
          puts row1
        end
      end
      puts
    end
  end
rescue PG::Error => e
  puts e.message
end

def out_pic_info(conn)
  conn.exec("SELECT u.user_id, u.email, u.nickname
FROM schema1.users u") do |result|
    result.each do |row|
      puts row
      user_id = row["user_id"]
      conn.exec("SELECT upic.users_pictures_id, upic.picture_url, upic.picture_alt_text FROM schema1.users_pictures upic
WHERE upic.users_pictures_id = #{user_id} AND upic.picture_type = 1
        ORDER BY upic.users_pictures_id") do |result1|
        result1.each do |row1|
          puts row1
        end
      end
      puts
    end
  end
  puts
rescue PG::Error => e
  puts e.message
end

while 1
  puts "Действия:
0 Выйти
1 Вывести информацию по пользователям (основная + дополнительная)
2 Вывести информацию по аватаркам пользователей
(вывод информации - строка пользователя, несколько строк информации о его аватарках)
3 Вывести информацию по картинкам пользователя
(вывод информации - строка пользователя, несколько строк информации о его картинках)"
  output = gets.chomp.to_i

  case output
  when 0
    exit
  when 1
    out_all_info(conn)
  when 2
    out_ava_info(conn)
  when 3
    out_pic_info(conn)
  else
    puts "You gave me wrong number (#{output}). I work only with 0-3. Try again:"
    puts
  end
end