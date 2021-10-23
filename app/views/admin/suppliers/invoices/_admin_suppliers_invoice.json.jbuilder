json.extract! admin_suppliers_invoice, :id, :no, :amount, :date, :transport_cost, :is_complete, :department_id, :expected_delivery, :instruction, :is_received, :receive_date, :note, :is_order, :order_state, :supplier_id, :issued_by_id, :received_by_id, :stocklocation_id, :created_at, :updated_at
json.url admin_suppliers_invoice_url(admin_suppliers_invoice, format: :json)
