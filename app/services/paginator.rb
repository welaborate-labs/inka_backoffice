class Paginator
  attr_reader :collection, :page, :per_page

  def initialize(collection, page:, per_page:)
    @collection = collection
    @page = page.to_i
    @per_page = per_page.to_i
  end

  def results
    collection
      .limit(per_page)
      .offset(offset)
  end

  def next_page
    page + 1 unless last_page?
  end

  def next_page?
    page < total_pages
  end

  def previous_page
    page - 1 unless first_page?
  end

  def previous_page?
    page > 1
  end

  def last_page?
    page == total_pages
  end

  def first_page?
    page == 1
  end

  def total_pages
    (count / per_page.to_f).ceil
  end

  private

  def count
    @count ||= collection.size
  end

  def offset
    per_page * (page - 1)
  end
end
