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

    "Expected #{survivor.name} to have items #{expected} but had #{item_names} instead"
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

  it "test sucessiful trade non-repeating items" do
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

    trade = Trade.new(params)
    TradeService.new(trade).call

    expect(survivor).to have_items([food.name, ammunition.name, food.name, ammunition.name])
    expect(survivor2).to have_items([water.name, medication.name])
  end

  it "test sucessiful trade repeating items" do
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

    trade = Trade.new(params)
    TradeService.new(trade).call

    expect(survivor1).to have_items([water.name, food.name, food.name])
    expect(survivor2).to have_items([medication.name, ammunition.name, water.name, medication.name])
  end

  it "test trade when it's infected survivor" do
    Survivor::SetInfected.(
      id: survivor.id
    )

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

    trade = Trade.new(params)
    TradeService.new(trade).call

    expect(survivor).to have_items([water.name, food.name, ammunition.name])
    expect(survivor2).to have_items([food.name, medication.name, water.name])
  end

  it "test with items that the survivor doesn't own" do
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

    trade = Trade.new(params)
    TradeService.new(trade).call

    expect(survivor).to have_items([food.name, water.name, ammunition.name])
    expect(survivor2).to have_items([food.name, medication.name, water.name])
  end

  it "test items with different sum of points" do
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

    trade = Trade.new(params)
    TradeService.new(trade).call

    expect(survivor).to have_items([water.name, food.name, ammunition.name])
    expect(survivor2).to have_items([food.name, medication.name, water.name])
  end
end
