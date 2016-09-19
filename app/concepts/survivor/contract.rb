module Survivor::Contract
  class Create < Reform::Form
    model Survivor

    property :name,     validates: { presence: true }
    property :age,      validates: { presence: true, numericality: { greater_than: 1, less_than: 105, message: "invalid age" } }
    property :gender,   validates: { presence: true }
    property :latitude
    property :longitude

    collection :items, populator: :user!

    private

    def user!(options)
      item_ids = []
      options[:doc]['items'].each { |item| item_ids << item[:id] }
      item = Item.where(id: item_ids)
      items.append(item) if item
    end

  end

  class Update < Create

    property :name, writeable: false
    property :age, writeable: false
    property :gender, writeable: false

    if :infected
      property :items, writeable: false
    end

  end
end