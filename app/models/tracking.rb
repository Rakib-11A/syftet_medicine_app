# frozen_string_literal: true

# == Schema Information
#
# Table name: trackings
#
#  id          :integer          not null, primary key
#  comment     :text
#  user_id     :integer
#  shipment_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Tracking < ActiveRecord::Base
  belongs_to :shipment
end
