class Survivor < ActiveRecord::Base
  has_many :complaints
  has_many :inventories, dependent: :destroy
  has_many :items, through: :inventories

  enum gender: %i[ male female ]

  # set default order query
  default_scope { order(:id) }

  def mark_infected
    update_attributes!(infected: true)
  end
end
