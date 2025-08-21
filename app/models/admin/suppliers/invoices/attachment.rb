# == Schema Information
#
# Table name: admin_suppliers_invoices_attachments
#
#  id         :integer          not null, primary key
#  invoice_id :integer
#  picture    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Admin::Suppliers::Invoices::Attachment < ApplicationRecord
  mount_uploader :picture, Admin::SupplierInvoiceUploader
  belongs_to :invoice , class_name: 'Admin::Suppliers::Invoice'
end
