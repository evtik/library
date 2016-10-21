class Library
  attr_accessor :authors, :books, :readers, :orders

  def initialize(authors, books, readers, orders)
    @authors, @books, @readers, @orders = authors, books, readers, orders
  end

  def top_reader
    o_hash = @orders.inject(Hash.new(0)) { |h, o| h[o.reader] += 1; h }
    reader = o_hash.max_by { |_k, v| v }
    "The top reader is #{reader.first.name} with #{reader.last} orders"
  end

  def top_book
    o_hash = @orders.inject(Hash.new(0)) { |h, o| h[o.book] += 1; h }
    book = o_hash.max_by { |_k, v| v }
    "The top book is \"#{book.first.title}\" with #{book.last} orders"
  end

  def top_three_books
    o_hash = @orders.inject(Hash.new(0)) { |h, o| h[o.book] += 1; h }
    books = (o_hash.sort_by { |_k, v| v }).reverse.take(3)
    result = 'The top three books are:'
    books.each do |book|
      result << "\n\"#{book.first.title}\" has been taken #{book.last} times"
    end
    result
  end
end
