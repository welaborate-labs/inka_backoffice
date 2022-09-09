module Autocomplete
  extend ActiveSupport::Concern

  included do
    before_action :set_autocomplete_collection, only: :search

    def search
      render layout: false
    end
  end
end
