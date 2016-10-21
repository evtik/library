class Library
  attr_accessor :authors, :books, :readers, :orders

  def initialize(authors, books, readers, orders)
    @authors, @books, @readers, @orders = authors, books, readers, orders
  end
end
