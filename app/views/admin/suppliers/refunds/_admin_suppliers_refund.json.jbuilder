json.extract! admin_suppliers_refund, :id, :amount, :date, :invoice_no, :is_order, :refund_by, :refund_reason, :department_id, :employee_id, :invoice_id, :supplier_id, :created_at, :updated_at
json.url admin_suppliers_refund_url(admin_suppliers_refund, format: :json)
