class Survivor < ActiveRecord::Base
  has_many :inventories, dependent: :destroy
  has_many :items, through: :inventories

  accepts_nested_attributes_for :inventories
  # accepts_nested_attributes_for :items

  validates :name, :age, :gender,
    presence: true

  enum gender: { male: 0, female: 1 }

  # set default order query
  default_scope { order(:id) }

  def set_infected
    self.infected = true
    self.save!
  end
end
