json.extract! admin_suppliers_payment, :id, :supplier_id, :paid_by_id, :method, :amount, :payment_date, :value_date, :cheque_number, :status, :confirmed, :paid_to, :invoice_id, :bank_name, :bank_branch, :is_group_payment, :commission, :bank_account_id, :created_at, :updated_at
json.url admin_suppliers_payment_url(admin_suppliers_payment, format: :json)
