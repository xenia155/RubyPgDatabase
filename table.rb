require 'pg'
require_relative 'csv'

class Table
  attr_reader :table_name, :connection
  def initialize(table_name, connection)
    @table_name  = table_name
    @connection  = connection
  end

  def create_table
    # creating non existent tables
    begin
      case table_name
      when "schema1.users"
        connection.exec("CREATE TABLE IF NOT EXISTS schema1.users(user_id SERIAL PRIMARY KEY, email VARCHAR(40), nickname VARCHAR(30));")
      when "schema1.users_additional_info"
        connection.exec("CREATE TABLE IF NOT EXISTS schema1.users_additional_info(first_name VARCHAR(20), last_name VARCHAR(20),
    birthdate DATE, sex VARCHAR(10), users_additional_info_id INTEGER REFERENCES schema1.users(user_id));")
      when "schema1.users_pictures"
        connection.exec("CREATE TABLE IF NOT EXISTS schema1.users_pictures(picture_url VARCHAR(50), picture_alt_text VARCHAR(30),
      picture_type INTEGER, users_pictures_id INTEGER REFERENCES schema1.users(user_id));")
      end
      puts "\nConnected to Postgres and created a #{table_name}/it existed already."
    rescue PG::Error => e
      puts e.message
    end
  end

  def clear_data
    connection.exec("DELETE FROM #{table_name}")
    puts "Cleared all data from the #{table_name}."
  rescue PG::Error => e
    puts e.message
  end
end


