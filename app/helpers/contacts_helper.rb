module ContactsHelper
	def contact_code(contact)
		customer_code = "CUS#{contact.customer.id.to_s.rjust(4, '0')}"
		return "#{customer_code}-CON#{contact.id.to_s.rjust(4, '0')}"
	end
end
