class TradeService
	def call(params)
    initialize_trade(params)
    if @trade.valid? && @trade.same_items_amount?
      trade!
      true
    else
      false
    end
	end

  private

  def initialize_trade(params)
    @trade = Trade.new(params)
  end

  def trade!
    @trade.trade!
  end
end