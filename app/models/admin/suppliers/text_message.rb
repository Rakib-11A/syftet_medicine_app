# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_suppliers_text_messages
#
#  id          :integer          not null, primary key
#  supplier_id :integer
#  employee_id :integer
#  content     :text
#  direction   :string
#  read        :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Admin
  module Suppliers
    class TextMessage < ApplicationRecord
    end
  end
end
