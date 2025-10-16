# frozen_string_literal: true

module Admin
  module CategoriesHelper
    def get_page_url(link)
      "#{root_url}c/#{link}"
    end
  end
end
