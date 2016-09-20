module Survivor::Contract
  class Create < Reform::Form
    model Survivor

    property :name,     validates: { presence: true }
    property :age,      validates: { presence: true, numericality: { greater_than: 1, less_than: 105, message: "invalid age" } }
    property :gender,   validates: { presence: true }
    property :latitude
    property :longitude

    collection :items, populator: :populate_items!

    private

    def populate_items!(options)
      options[:doc]['items'].each do |item_form|
        item = Item.find(item_form[:id])

        items.append(item) if item
      end
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