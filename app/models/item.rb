class Item < ActiveRecord::Base
  has_many :inventories, dependent: :destroy
  has_many :survivors, through: :inventories
end
