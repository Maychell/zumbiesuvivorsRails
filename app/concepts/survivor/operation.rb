class Survivor < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Survivor, :create

    contract do
      property :name,     validates: { presence: true }
      property :age,      validates: { presence: true, numericality: { greater_than: 1, less_than: 105, message: "invalid age" } }
      property :gender,   validates: { presence: true }
      property :latitude
      property :longitude
      collection :items
      # collection :items,
      #   populator: -> (fragment:, **) {
      #     # binding.pry
      #     # Inventory.find_by(id: fragment) or Inventory.new(item_id: fragment)
      #     # binding.pry

      #     # Inventory.new(item_id: item)

      #     # x = items.find { |item| item.id == fragment["id"].to_i }
      #     x = Item.where(id: fragment["id"].to_i)

      #     x.each { |y| items.append(y) }
      #       # items.append(x)
      #     # end

      #     # x ? x : items.append(Item.new)
      #   }
      # collection :items,
      #   populator: ->(fragment:, **) do
      #     binding.pry
      #     Item.where(id: fragment["id"])
      #   end
    end

    def process(params)
      validate(params[:survivor]) do |f|
        f.save
      end
    end
  end

  class Update < Create
    action :update

    contract do
      property :name, writeable: false
      property :age, writeable: false
      property :gender, writeable: false

      if :infected
        property :items, writeable: false
      end
    end
  end
end