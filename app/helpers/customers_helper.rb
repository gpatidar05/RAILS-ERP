module CustomersHelper
	def customer_code(customer)
		return "CUS#{customer.id.to_s.rjust(4, '0')}"
	end
end
