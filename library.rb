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
    reader = group_orders_by(:reader)[0]
    "\nThe top reader is #{reader.first.name} with #{reader.last} orders"
  end

  def top_book_by_orders
    book = group_orders_by(:book)[0]
    "\nThe top book by orders is \"#{book.first.title}\" "\
      "with #{book.last} orders"
  end

  def top_book_by_readers
    block = -> (orders) { orders.uniq { |o| [o.book, o.reader] } }
    book = group_orders_by(:book, &block)[0]
    "The top book by readers is \"#{book.first.title}\" "\
      "taken by #{book.last} readers"
  end

  def top_three_books_by_orders
    result = "\nThe top three books by orders are:"
    group_orders_by(:book, 3).each do |book|
      result << "\n\"#{book.first.title}\" met in #{book.last} orders"
    end
    result
  end

  def top_three_books_by_readers
    block = -> (orders) { orders.uniq { |o| [o.book, o.reader] } }
    result = "\nThe top three books by readers are:"
    group_orders_by(:book, 3, &block).each do |book|
      result << "\n\"#{book.first.title}\" taken by #{book.last} readers"
    end
    result
  end

  private

  def group_orders_by(entity, count = 1)
    orders = block_given? ? yield(@orders) : @orders
    orders.each_with_object(Hash.new(0)) { |o, h| h[o.send(entity)] += 1 }
          .sort_by { |_k, v| v }
          .reverse
          .first(count)
  end
end
