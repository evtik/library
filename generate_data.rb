require 'faker'
require 'json'

library = Hash.new { |hash, key| hash[key] = [] }

number_of_authors = 30
number_of_readers = 50
number_of_books = 100
number_of_orders = 500

number_of_authors.times do
  library[:authors] << {
    name: Faker::Name.name,
    biography: Faker::Hipster.sentence
  }
end

number_of_books.times do
  library[:books] << {
    title: Faker::Book.title,
    author: library[:authors][rand(number_of_authors)][:name]
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
  # every 5th time take one of the first three books
  # to make sure they'll appear as the 3 most read
  book = if (i % 5).zero?
           library[:books][rand(3)][:title]
         else
           library[:books][rand(number_of_books)][:title]
         end

  # everty 10th time :-) pick the first reader
  # to get him as read-the-most freak later
  reader = if (i % 10).zero?
             library[:readers][0][:name]
           else
             library[:readers][rand(number_of_readers)][:name]
           end

  library[:orders] <<
    { book: book, reader: reader, date: Faker::Date.backward(180) }
end

File.write 'data.json', JSON.pretty_generate(library)
