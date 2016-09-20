require 'rails_helper'

RSpec::Matchers.define :have_items do |expected|
  def extract_items(survivor)
    survivor.items.reload.map(&:name)
  end
  
  match do |survivor|
    extract_items(survivor).sort == expected.sort
  end

  failure_message do |survivor|
    item_names = extract_items(survivor)

    'Expected #{survivor.name} to have items #{expected} but had #{item_names} instead'
  end
end

RSpec.describe Trade, type: :model do

  let(:items) { Item.all.map { |item| [item.name, item] }.to_h }
  let(:food) { items['1 Food'] }
  let(:water) { items['1 Water'] }
  let(:ammunition) { items['1 Ammunition'] }
  let(:medication) { items['1 Medication'] }
  let(:survivor) {
    Survivor::Create.(
      survivor: {
        name: "Rails", age: 14, gender: :female, items: [water, food, ammunition]
      }
    ).model
  }

  context 'when the trade is valid' do
    it "with non-repeated items, the survivor's items are traded" do
      survivor2 = Survivor::Create.(
        survivor: {
          name: "Rails", age: 14, gender: :female, items: [food, medication, ammunition]
        }
      ).model

      params = {
        trade:[
          {
            survivor_id: survivor.id,
            items:[
              { id: water.id }
            ]
          },
          {
            survivor_id: survivor2.id,
            items:[
              { id: food.id },
              { id: ammunition.id }
            ]
          }
        ]
      }

      TradeOperation::Create.(params)

      expect(survivor).to have_items([food.name, ammunition.name, food.name, ammunition.name])
      expect(survivor2).to have_items([water.name, medication.name])
    end

    it "with repeated items the survivor's items are traded" do
      survivor1 = Survivor::Create.(
        survivor: {
          name: "Rails", age: 14, gender: :female, items: [water, medication, water]
        }
      ).model

      survivor2 = Survivor::Create.(
        survivor: {
          name: "Rails", age: 14, gender: :female, items: [food, medication, ammunition, food]
        }
      ).model

      params = {
        trade:[
          {
            survivor_id: survivor1.id,
            items:[
              { id: water.id },
              { id: medication.id },
            ]
          },
          {
            survivor_id: survivor2.id,
            items:[
              { id: food.id },
              { id: food.id }
            ]
          }
        ]
      }

      TradeOperation::Create.(params)

      expect(survivor1).to have_items([water.name, food.name, food.name])
      expect(survivor2).to have_items([medication.name, ammunition.name, water.name, medication.name])
    end
  end

  context 'when at least one of the parts of the trade is infected' do
    it "the survivors' items are not traded" do
      survivor.mark_infected

      survivor2 = Survivor::Create.(
        survivor: {
          name: "test", age: 12, gender: :male, items: [food, medication, water]
        }
      ).model

      params = {
        trade:[
          {
            survivor_id: survivor.id,
            items:[
              { id: water.id },
              { id: ammunition.id }
            ]
          },
          {
            survivor_id: survivor2.id,
            items:[
              { id: food.id },
              { id: medication.id }
            ]
          }
        ]
      }

      TradeOperation::Create.(params)

      expect(survivor).to have_items([water.name, food.name, ammunition.name])
      expect(survivor2).to have_items([food.name, medication.name, water.name])
    end
  end

  context 'when at least one of the survivor does not own the item' do
    it "the survivors' items are not traded" do
      survivor2 = Survivor::Create.(
        survivor: {
          name: "test", age: 12, gender: :male, items: [food, medication, water]
        }
      ).model

      params = {
        trade:[
          {
            survivor_id: survivor.id,
            items:[
              {id: medication.id},
              {id: food.id}
            ]
          },
          {
            survivor_id: survivor2.id,
            items:[
              {id: food.id},
              {id: medication.id}
            ]
          }
        ]
      }

      TradeOperation::Create.(params)

      expect(survivor).to have_items([food.name, water.name, ammunition.name])
      expect(survivor2).to have_items([food.name, medication.name, water.name])
    end
  end

  context "when the items's amount of points is different from each other" do
    it "the survivor's items are not traded" do
      survivor2 = Survivor::Create.(
        survivor: {
          name: "test", age: 12, gender: :male, items: [food, medication, water]
        }
      ).model

      params = {
        trade:[
          {
            survivor_id: survivor.id,
            items:[
              {id: water.id},
              {id: food.id}
            ]
          },
          {
            survivor_id: survivor2.id,
            items:[
              {id: food.id},
              {id: medication.id}
            ]
          }
        ]
      }

      TradeOperation::Create.(params)

      expect(survivor).to have_items([water.name, food.name, ammunition.name])
      expect(survivor2).to have_items([food.name, medication.name, water.name])
    end
  end
end
