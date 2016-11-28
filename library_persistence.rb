module LibraryPersistence
  def get_data(file_path)
    @library_data = JSON.parse(File.read(file_path))
    %w(author book reader order).each { |e| send "fetch_#{e}s" }
    @library_data = nil
  end

  def save_data(file_path)
    @library_data = Hash.new { |hash, key| hash[key] = [] }
    %w(author book reader order).each { |e| send "collect_#{e}s" }
    File.write(file_path, JSON.pretty_generate(@library_data))
  end

  private

  def fetch_authors
    @authors = @library_data['authors'].map do |author|
      Author.new author['name'], author['biography']
    end
  end

  def fetch_books
    @books = @library_data['books'].map do |book|
      Book.new(
        book['title'],
        authors.find { |author| author.name == book['author'] }
      )
    end
  end

  def fetch_readers
    @readers = @library_data['readers'].map do |reader|
      Reader.new(
        reader['name'],
        reader['email'],
        reader['city'],
        reader['street'],
        reader['house']
      )
    end
  end

  def fetch_orders
    @orders = @library_data['orders'].map do |order|
      Order.new(
        books.find { |book| book.title == order['book'] },
        readers.find { |reader| reader.name == order['reader'] },
        order['date']
      )
    end
  end

  def collect_authors
    @library_data[:authors] = @authors.map do |author|
      { name: author.name, biography: author.biography }
    end
  end

  def collect_books
    @library_data[:books] = @books.map do |book|
      { title: book.title, author: book.author.name }
    end
  end

  def collect_readers
    @library_data[:readers] = @readers.map do |reader|
      {
        name: reader.name,
        email: reader.email,
        city: reader.city,
        street: reader.street,
        house: reader.house
      }
    end
  end

  def collect_orders
    @library_data[:orders] = @orders.map do |order|
      {
        book: order.book.title,
        reader: order.reader.name,
        date: order.date
      }
    end
  end
end
