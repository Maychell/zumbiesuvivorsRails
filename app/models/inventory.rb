class Inventory < ActiveRecord::Base
	belongs_to :survivor
	belongs_to :item
end
