require 'json'

require_relative 'Author'
require_relative 'Book'
require_relative 'Reader'
require_relative 'Order'
require_relative 'Library'

library_data = JSON.parse(File.read('data.json'))

authors = []
books = []
readers = []
orders = []

library_data['authors'].each do |author|
  authors << Author.new(author['name'], author['biography'])
end

library_data['books'].each do |book|
  books << Book.new(
    book['title'],
    authors.find { |author| author.name == book['author'] }
  )
end

library_data['readers'].each do |r|
  readers << Reader.new(
    r['name'], r['email'], r['city'], r['street'], r['house']
  )
end

library_data['orders'].each do |order|
  orders << Order.new(
    books.find { |book| book.title == order['book'] },
    readers.find { |reader| reader.name == order['reader'] },
    order['date']
  )
end

library = Library.new(authors, books, readers, orders)

puts library.top_reader
puts library.top_book_by_orders
puts library.top_book_by_readers
puts library.top_three_books_by_orders
puts library.top_three_books_by_readers
