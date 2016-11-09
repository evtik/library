require 'json'

require_relative 'author'
require_relative 'book'
require_relative 'reader'
require_relative 'order'
require_relative 'library_helper'

class Library
  include LibraryHelper

  attr_accessor :authors, :books, :readers, :orders

  def initialize
    @authors, @books, @readers, @orders = [], [], [], []
  end

  def get_data(file_path)
    @library_data = JSON.parse(File.read(file_path))
    fetch_authors
    fetch_books
    fetch_readers
    fetch_orders
    @library_data = nil
  end

  def save_data(file_path)
    @library_data = Hash.new { |hash, key| hash[key] = [] }
    collect_authors
    collect_books
    collect_readers
    collect_orders
    File.write(file_path, JSON.pretty_generate(@library_data))
  end

  def top_reader
    o_hash = @orders.each_with_object(Hash.new(0)) { |o, h| h[o.reader] += 1 }
    reader = o_hash.max_by { |_k, v| v }
    "\nThe top reader is #{reader.first.name} with #{reader.last} orders"
  end

  def top_book_by_orders
    book = top_book(@orders)
    "\nThe top book by orders is \"#{book.first.title}\" "\
      "with #{book.last} orders"
  end

  def top_book_by_readers
    book = top_book(orders_unique_by_readers(@orders))
    "The top book by readers is \"#{book.first.title}\" "\
      "taken by #{book.last} readers"
  end

  def top_three_books_by_orders
    books = top_three_books(@orders)
    result = "\nThe top three books by orders are:"
    books.each do |book|
      result << "\n\"#{book.first.title}\" met in #{book.last} orders"
    end
    result
  end

  def top_three_books_by_readers
    books = top_three_books(orders_unique_by_readers(@orders))
    result = "\nThe top three books by readers are:"
    books.each do |book|
      result << "\n\"#{book.first.title}\" taken by #{book.last} readers"
    end
    result
  end

  private

  def orders_hash_by_book(orders)
    orders.each_with_object(Hash.new(0)) { |o, h| h[o.book] += 1 }
  end

  def top_book(orders)
    orders_hash_by_book(orders).max_by { |_k, v| v }
  end

  def top_three_books(orders)
    orders_hash_by_book(orders).sort_by { |_k, v| v }.reverse.take(3)
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
