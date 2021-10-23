class Admin::Suppliers::Invoices::Attachment < ApplicationRecord
  mount_uploader :picture, SupplierInvoiceUploader
  belongs_to :invoice , class_name: 'Admin::Suppliers::Invoice'
end
