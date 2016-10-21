require 'faker'
require 'json'

library = {}
library[:authors] = []
library[:books] = []
library[:readers] = []
library[:orders] = []

number_of_authors = 30
number_of_readers = 50
number_of_books = 100
number_of_orders = 200

number_of_authors.times do
  library[:authors] << {
    name: Faker::Name.name,
    biography: Faker::Hipster.sentence
  }
end

number_of_books.times do
  library[:books] << {
    title: Faker::Book.title,
    author: library[:authors][rand(number_of_authors)]
  }
end

number_of_readers.times do
  library[:readers] << {
    name: Faker::Name.name,
    email: Faker::Internet.email,
    city: Faker::Address.city,
    street: Faker::Address.street_name,
    house: Faker::Address.building_number
  }
end

number_of_orders.times do |i|
  # every 10th time take one of the first three books
  # to make sure they'll appear as the 3 most read
  book = if (i % 10).zero?
           library[:books][rand(2)]
         else
           library[:books][rand(number_of_books)]
         end

  # everty 8th time :-) pick the first reader
  # to get him as read-the-most freak later
  reader = if (i % 8).zero?
             library[:readers][0]
           else
             library[:readers][rand(number_of_readers)]
           end

  library[:orders] << { book: book, reader: reader, date: DateTime.now }
end

File.write 'data.json', JSON.pretty_generate(library)
