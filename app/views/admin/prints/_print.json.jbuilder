# frozen_string_literal: true

json.extract! print, :id, :created_at, :updated_at
json.url print_url(print, format: :json)
