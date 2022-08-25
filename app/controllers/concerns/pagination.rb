module Pagination
  def paginate(collection, page: 1, per_page: 10)
    pagination = Paginator.new(collection, page: page || 1, per_page: per_page)

    [
      pagination,
      pagination.results
    ]
  end
end
