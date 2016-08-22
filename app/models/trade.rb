class Trade
	attr_reader :trade

	def initialize(params)
    @trade = build_trade(params)
	end

	def valid?
    !@trade[:left][:survivor].infected &&
    (@trade[:left][:items] - @trade[:left][:survivor].items).empty? &&
    (@trade[:right][:items] - @trade[:right][:survivor].items).empty?
	end

  def same_items_amount?
    left_amount = items_count(@trade[:left][:items])
    right_amount = items_count(@trade[:right][:items])

    left_amount == right_amount
  end

  def trade!
    # aux gets all the items from left side of the trade
    aux = @trade[:left][:items]

    # delete items from database from left side
    delete_from_trade(@trade[:left])

    # save items from right side to left side
    save_from_trade(@trade[:left][:survivor], @trade[:right][:items])

    # delete items from database right side
    delete_from_trade(@trade[:right])

    # save items from aux to right side
    save_from_trade(@trade[:right][:survivor], aux)
  end

  private

  def items_count(items)
    amount = 0
    items.each do |item|
      amount += item.points
    end
    return amount
  end

  def build_trade(params)
    left = params[:trade][0]
    right = params[:trade][1]

    ids = build_ids(left[:items])
    ids_right = build_ids(right[:items])

    @trade_left = {survivor: Survivor.find(left[:survivor_id]), items: Item.where(id: ids)}
    @trade_right = {survivor: Survivor.find(right[:survivor_id]), items: Item.where(id: ids_right)}

    return {left: @trade_left, right: @trade_right}
  end

  def build_ids(items_id)
    ids = []
    items_id.each do |item|
      ids << item[:id]
    end

    return ids
  end

  def delete_from_trade(survivor_items)
    survivor_items[:items].each do |item|
      de = survivor_items[:survivor].inventories.where(item_id: item.id).first
      de.destroy
    end
  end

  def save_from_trade(survivor, items)
    items.each do |item|
      de = survivor.inventories.build
      de.item = item
      de.save
    end
  end
end