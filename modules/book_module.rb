require 'json'
require 'colorize'
require_relative '../classes/book'

module BooksDataController
  def load_books
    file = './json/books.json'
    data = []

    if File.exist?(file)
      if File.empty?(file)
        data
      else
        JSON.parse(File.read(file))
      end
    else
      data
    end
  end

  def save_books(book)
    file = './json/books.json'
    data = []
    new_book = {
      'name' => book.name,
      'publisher' => book.publisher,
      'cover_state' => book.cover_state,
      'publish_date' => book.publish_date
    }

    data = JSON.parse(File.read(file)) if File.exist?(file)
    data << new_book
    File.write(file, JSON.pretty_generate(data))
  end

  def create_book
    print 'Enter book name: '
    name = gets.chomp

    print 'Enter the publisher: '
    publisher = gets.chomp

    print 'Enter Cover State Good (Y) OR Bad (N): '
    cover_state = gets.chomp

    print 'Enter date published [yyyy-mm-dd]: '
    publish_date = gets.chomp

    new_book = Book.new(name, publisher, cover_state, publish_date)
    save_books(new_book)
    puts 'Book created successfully'.colorize(color: :light_green)
  rescue StandardError
    puts 'Cannot create book, check your Input formats'.colorize(color: :light_red)
  end

  def list_books
    books = load_books
    if books.empty?
      puts 'No Books to be displayed'.colorize(color: :magenta)
    else
      puts "#{books.count} Books Found!".colorize(color: :magenta)
      books.each do |book|
        puts "#{book['name']}" \
             "| Publisher: #{book['publisher']} | Cover State: #{book['cover_state']}" \
             "| Published Date: #{book['publish_date']}"
        puts '-------------------------------------------------------------------------------------------------------------------'
      end
    end
  end
end
