class TradeService
  def initialize(trade_params)
    @trade = Trade.new(trade_params)
  end

	def call
    return false unless valid_trade?

    trade!
    return true
	end

  private

  def valid_trade?
    @trade.valid? && @trade.same_items_amount?
  end

  def trade!
    @trade.trade!
  end
end