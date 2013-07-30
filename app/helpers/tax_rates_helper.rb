module TaxRatesHelper

  def tax_rate_for_today
     TaxRate.tax_rate_for_today
  end

	def nooverlap?(tax_all, start_date2, end_date2)
		#logger=Logger.new("test")
		tax_all.each do |taxc|
			start_date1 = Date.parse(taxc.valid_from.to_s)
			#logger.debug("fromdate"+ start_date1.to_s)
			end_date1 = Date.parse(taxc.valid_until.to_s)
			start_date2 = Date.parse(start_date2.to_s)
			end_date2 = Date.parse(end_date2.to_s)
			account_id=taxc.account_id.to_s
			#logger.debug ((start_date1..end_date1).to_a & (start_date2..end_date2).to_a)
				if account_id==@account_id.to_s
				return unless ((start_date1..end_date1).to_a & (start_date2..end_date2).to_a).empty?
				end
		end
	end
end
