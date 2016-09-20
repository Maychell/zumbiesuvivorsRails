module Item::Contract
  class Create < Reform::Form
    model Survivor

    property :name,  validates: { presence: true }
    property :points

    validates_uniqueness_of :name
  end
end