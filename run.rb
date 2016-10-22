require_relative 'Library'

library = Library.new

library.get_data('data.json')

puts library.top_reader
puts library.top_book_by_orders
puts library.top_book_by_readers
puts library.top_three_books_by_orders
puts library.top_three_books_by_readers

library.save_data('cloned_data.json')
