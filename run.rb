require 'json'

require_relative 'Author'
require_relative 'Book'
require_relative 'Reader'
require_relative 'Order'
require_relative 'Library'

library = JSON.parse(File.read('data.json'))

authors = []
books = []
readers = []
orders = []

library['authors'].each do |author|
  authors << Author.new(author['name'], author['biography'])
end

library['books'].each do |b|
  books << Book.new(
    b['title'],
    Author.new(b['author']['name'], b['author']['biography'])
  )
end

library['readers'].each do |r|
  readers << Reader.new(
    r['name'], r['email'], r['city'], r['street'], r['house']
  )
end

p readers
