# == Schema Information
#
# Table name: contacts
#
#  id           :integer          not null, primary key
#  full_name    :string(255)
#  email        :string(255)
#  phone        :string(255)
#  order_number :string(255)
#  inquiry_type :string(255)
#  message      :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Contact < ApplicationRecord
  belongs_to :checked_by, class_name: 'User', foreign_key: 'user_id'
  # after_create :send_email_notification


  def checked(user)
    self.is_checked = true
    self.checked_by = user
    save!
  end
  def send_email_notification
    NotificationMailer.send_contact_notification(self).deliver_now
  end
end
