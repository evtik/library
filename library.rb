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
    name = count_orders_by(:reader)[0][0].reader.name
    "The top reader is #{name}"
  end

  def top_book
    title = count_orders_by(:book)[0][0].book.title
    "The top book is \"#{title}\""
  end

  def top_three_books
    readers_count = count_orders_by(:book, 3).flatten.uniq(&:reader).length
    "The top three books have been taken by #{readers_count} readers"
  end

  private

  def count_orders_by(entity, take = 1)
    @orders.group_by(&entity).values.sort_by(&:length).last(take)
  end
end
