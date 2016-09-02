class Trade
	attr_reader :trade

	def initialize(params)
    @trade = trade_init(params)
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
    ActiveRecord::Base.transaction do
      destroy_survivor_items(@trade[:left])
      destroy_survivor_items(@trade[:right])

      save_survivor_items(@trade[:left][:survivor], @trade[:right][:items])
      save_survivor_items(@trade[:right][:survivor], @trade[:left][:items])
    end
  end

  private

  def items_count(items)
    items.map(&:points).inject(:+)
  end

  def trade_init(params)
    left, right = Array(params[:trade])

    ids_left = build_ids(left[:items])
    ids_right = build_ids(right[:items])

    trade_left = build_trade(
      Survivor.find(left[:survivor_id]),
      ids_left.map { |id| Item.find(id) }
    )
    trade_right = build_trade(
      Survivor.find(right[:survivor_id]),
      ids_right.map { |id| Item.find(id) }
    )

    { left: trade_left, right: trade_right }
  end

  def build_trade(survivor, items)
    { survivor: survivor, items: items }
  end

  def build_ids(items_id)
    items_id.map { |item| item[:id] }
  end

  def destroy_survivor_items(survivor_items)
    survivor_items[:items].each do |item|
      item = survivor_items[:survivor].inventories.where(item_id: item.id).first
      item.destroy!
    end
  end

  def save_survivor_items(survivor, items)
    survivor.items << items
  end
end