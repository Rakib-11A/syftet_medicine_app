module Preferable
  extend ActiveSupport::Concern

  included do
    # serialize :preferences, Hash  # TODO: Fix for Rails 8 serialize syntax

    def self.preference_getter_method(name)
      "preferred_#{name}".to_sym
    end

    if defined?(self::PREFERENCES) && self::PREFERENCES.any?
      self::PREFERENCES.each do |preference|
        define_method preference_getter_method(preference[:field]) do
          self.preferences = Hash.new unless self.preferences.kind_of?(Hash)
          field_value = preferences.fetch("preferred_#{preference[:field]}", preference[:default])
          field_value.blank? ? preference[:default] : field_value
        end
      end
    end
  end

end