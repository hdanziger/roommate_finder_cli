class RoomScraper

  def initialize(index_url)
    @index_url = index_url
    @doc = Nokogiri::HTML(open(index_url))
  end

  def call
    rows.each do |row_doc|
      room = Room.create_from_hash(scrape_row(row_doc)) #=> should put room in database

    end
  end

  private
  def rows
    @rows ||= @doc.search("div.content ul.rows p.result-info")
  end

  def scrape_row(row)
    #scrape an individual row
    {
      :date_created => row.search("time").attribute("datetime").text,
      :title => row.search("a.hdrlnk").text,
      :url => "#{@index_url}#{row.search("a.hdrlnk").attribute("href").text}",
      :price => row.search("span.result-price").text
    }
  end
end
