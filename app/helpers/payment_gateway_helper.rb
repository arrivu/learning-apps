
module PaymentGatewayHelper

def gateway_enable?
	true_boolean "#{@domain_root_account.settings[:payment_gateway_enable]}"
end


# def gateway_disable?
#   false_boolean "#{Settings.payment_gateway.enable}"
# end	


 private
		def true_boolean(value)
			[true, 'true', 1, '1', 't'].include?(value.respond_to?(:downcase) ? value.downcase : value)
		end
		# def false_boolean(value)
		#   [false, 'false', 0, '0', 'f'].include?(value.respond_to?(:downcase) ? value.downcase : value)
		# end
end    