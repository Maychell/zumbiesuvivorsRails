class TradeOperation
	class Create < Trailblazer::Operation

		def process(params)
			init(params)

			return false unless valid_trade?

			validate(params) do |f|
	    	trade!
	    end
		end

		private

		def init(trade_params)
			@trade = Trade.new(trade_params)
		end

	  def valid_trade?
	    @trade.valid? && @trade.same_items_amount?
	  end

	  def trade!
	    @trade.trade!
	  end

	end
end