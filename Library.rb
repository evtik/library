require 'json'

require_relative 'Author'
require_relative 'Book'
require_relative 'Reader'
require_relative 'Order'

class Library
  attr_accessor :authors, :books, :readers, :orders

  def initialize
    @authors, @books, @readers, @orders = [], [], [], []
  end

  def get_data(file_path)
    library_data = JSON.parse(File.read(file_path))

    library_data['authors'].each do |author|
      @authors << Author.new(author['name'], author['biography'])
    end

    library_data['books'].each do |book|
      @books << Book.new(
        book['title'],
        authors.find { |author| author.name == book['author'] }
      )
    end

    library_data['readers'].each do |r|
      @readers << Reader.new(
        r['name'], r['email'], r['city'], r['street'], r['house']
      )
    end

    library_data['orders'].each do |order|
      @orders << Order.new(
        books.find { |book| book.title == order['book'] },
        readers.find { |reader| reader.name == order['reader'] },
        order['date']
      )
    end
  end

  def top_reader
    o_hash = @orders.inject(Hash.new(0)) { |h, o| h[o.reader] += 1; h }
    reader = o_hash.max_by { |_k, v| v }
    "The top reader is #{reader.first.name} with #{reader.last} orders"
  end

  # The reason for existance of both _by_orders and _by_readers
  # methods is that a reader could take the same book multiple
  # times. The results should be the same assuming each user only
  # orders each book once.

  def top_book_by_orders
    book = top_book(@orders)
    "The top book by orders is \"#{book.first.title}\" with #{book.last} orders"
  end

  def top_book_by_readers
    book = top_book(orders_unique_by_readers(@orders))
    "The top book by readers is \"#{book.first.title}\" "\
      "taken by #{book.last} readers"
  end

  def top_three_books_by_orders
    books = top_three_books(@orders)
    result = 'The top three books by orders are:'
    books.each do |book|
      result << "\n\"#{book.first.title}\" met in #{book.last} orders"
    end
    result
  end

  def top_three_books_by_readers
    books = top_three_books(orders_unique_by_readers(@orders))
    result = 'The top three books by readers are:'
    books.each do |book|
      result << "\n\"#{book.first.title}\" taken by #{book.last} readers"
    end
    result
  end

  private

  def top_book(orders)
    o_hash = orders.inject(Hash.new(0)) { |h, o| h[o.book] += 1; h }
    o_hash.max_by { |_k, v| v }
  end

  def top_three_books(orders)
    o_hash = orders.inject(Hash.new(0)) { |h, o| h[o.book] += 1; h }
    (o_hash.sort_by { |_k, v| v }).reverse.take(3)
  end

  def orders_unique_by_readers(orders)
    unique_orders = []
    orders.group_by(&:book).each do |_book, book_orders|
      book_orders.uniq!(&:reader)
      unique_orders.concat(book_orders)
    end
    unique_orders
  end
end
