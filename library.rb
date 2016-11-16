require 'json'

require_relative 'author'
require_relative 'book'
require_relative 'reader'
require_relative 'order'
require_relative 'library_persistence'

class Library
  include LibraryPersistence

  attr_accessor :authors, :books, :readers, :orders

  def initialize
    @authors, @books, @readers, @orders = [], [], [], []
  end

  def top_reader
    reader = count_orders_by(:reader)[0]
    "\nThe top reader is #{reader.first.name} with #{reader.last} orders"
  end

  def top_book_by_orders
    book = count_orders_by(:book)[0]
    "\nThe top book by orders is \"#{book.first.title}\" "\
      "with #{book.last} orders"
  end

  def top_book_by_readers
    block = -> (orders) { orders.uniq { |o| [o.book, o.reader] } }
    book = count_orders_by(:book, &block)[0]
    "The top book by readers is \"#{book.first.title}\" "\
      "taken by #{book.last} readers"
  end

  def top_three_books_by_orders
    result = "\nThe top three books by orders are:"
    count_orders_by(:book, 3).each do |book|
      result << "\n\"#{book.first.title}\" met in #{book.last} orders"
    end
    result
  end

  def top_three_books_by_readers
    block = -> (orders) { orders.uniq { |o| [o.book, o.reader] } }
    result = "\nThe top three books by readers are:"
    count_orders_by(:book, 3, &block).each do |book|
      result << "\n\"#{book.first.title}\" taken by #{book.last} readers"
    end
    result
  end

  private

  def count_orders_by(entity, take = 1)
    orders = block_given? ? yield(@orders) : @orders
    orders.each_with_object(Hash.new(0)) { |o, h| h[o.send(entity)] += 1 }
          .sort_by { |_k, v| v }
          .reverse
          .first(take)
  end
end
