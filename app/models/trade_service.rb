class TradeService
  def initialize(trade)
    @trade = trade
  end

	def call
    if valid_trade?
      trade!
      true
    else
      false
    end
	end

  private

  def valid_trade?
    @trade.valid? && @trade.same_items_amount?
  end

  def trade!
    @trade.trade!
  end
end