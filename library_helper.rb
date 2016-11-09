module LibraryHelper
  private

  def fetch_authors
    @library_data['authors'].each do |author|
      @authors << Author.new(author['name'], author['biography'])
    end
  end

  def fetch_books
    @library_data['books'].each do |book|
      @books << Book.new(
        book['title'],
        authors.find { |author| author.name == book['author'] }
      )
    end
  end

  def fetch_readers
    @library_data['readers'].each do |r|
      @readers << Reader.new(
        r['name'], r['email'], r['city'], r['street'], r['house']
      )
    end
  end

  def fetch_orders
    @library_data['orders'].each do |order|
      @orders << Order.new(
        books.find { |book| book.title == order['book'] },
        readers.find { |reader| reader.name == order['reader'] },
        order['date']
      )
    end
  end

  def collect_authors
    @authors.each do |author|
      @library_data[:authors] << {
        name: author.name,
        biography: author.biography
      }
    end
  end

  def collect_books
    @books.each do |book|
      @library_data[:books] << {
        title: book.title,
        author: book.author.name
      }
    end
  end

  def collect_readers
    @readers.each do |reader|
      @library_data[:readers] << {
        name: reader.name,
        email: reader.email,
        city: reader.city,
        street: reader.street,
        house: reader.house
      }
    end
  end

  def collect_orders
    @orders.each do |order|
      @library_data[:orders] << {
        book: order.book.title,
        reader: order.reader.name,
        date: order.date
      }
    end
  end
end
