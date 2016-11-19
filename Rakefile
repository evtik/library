task :default do
  require_relative 'library'

  begin
    library = Library.new

    library.get_data('data.json')

    puts library.top_reader
    puts library.top_book
    puts library.top_three_books

    library.save_data('cloned_data.json')
  rescue
    puts 'data.json is missing!'\
    "\nGenerate it with:"\
    "\nrake generate"
  end
end

task :generate do
  require 'faker'
  require 'json'

  @library = Hash.new { |hash, key| hash[key] = [] }

  number_of_authors = 30
  number_of_readers = 50
  number_of_books = 100
  number_of_orders = 500

  number_of_authors.times do
    @library[:authors] << {
      name: Faker::Name.name,
      biography: Faker::Hipster.sentence
    }
  end

  number_of_books.times do
    @library[:books] << {
      title: Faker::Book.title,
      author: @library[:authors][rand(number_of_authors)][:name]
    }
  end

  number_of_readers.times do
    @library[:readers] << {
      name: Faker::Name.name,
      email: Faker::Internet.email,
      city: Faker::Address.city,
      street: Faker::Address.street_name,
      house: Faker::Address.building_number
    }
  end

  def get_book(seed = 3)
    @library[:books][rand(seed)][:title]
  end

  def get_reader(seed = 1)
    @library[:readers][rand(seed)][:name]
  end

  number_of_orders.times do |i|
    book = if (i % 5).zero?
             get_book
           else
             get_book(number_of_books)
           end

    reader = if (i % 10).zero?
               get_reader
             else
               get_reader(number_of_readers)
             end

    @library[:orders] <<
      { book: book, reader: reader, date: Faker::Date.backward(180) }
  end

  File.write 'data.json', JSON.pretty_generate(@library)
end
