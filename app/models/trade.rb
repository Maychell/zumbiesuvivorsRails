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
      delete_from_trade(@trade[:left])
      delete_from_trade(@trade[:right])

      save_from_trade(@trade[:left][:survivor], @trade[:right][:items])
      save_from_trade(@trade[:right][:survivor], @trade[:left][:items])
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
      Item.where(id: ids_left)
    )
    trade_right = build_trade(
      Survivor.find(right[:survivor_id]),
      Item.where(id: ids_right)
    )

    { left: trade_left, right: trade_right }
  end

  def build_trade(survivor, items)
    { survivor: survivor, items: items }
  end

  def build_ids(items_id)
    items_id.map { |item| item[:id] }
  end

  def delete_from_trade(survivor_items)
    ids = survivor_items[:items].map(&:id)
    items = survivor_items[:survivor].inventories.where(item_id: ids)
    items.destroy_all
  end

  def save_from_trade(survivor, items)
    items.each do |item|
      de = survivor.inventories.build
      de.item = item
      de.save!
    end
  end
end