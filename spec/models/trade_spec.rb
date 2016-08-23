require 'rails_helper'

#### ITEM TABLE VALUES
##  id   points
##   1     4
##   2     3
##   3     2
##   4     1

RSpec.describe Trade, type: :model do
  it "test sucessiful trade" do
  	# setting the first survivor
  	items1 = Item.where(id: [1, 2, 4]) #total points: 4+3+1 = 8
    survivor1 = Survivor.create!(name: "Teste automatico 1",
      age: 200, gender: 0, items: items1)

    # setting the second survivor
    items2 = Item.where(id: [2, 3, 1]) #total points: 3+2+4 = 9
    survivor2 = Survivor.create!(name: "Teste automatico 2",
      age: 200, gender: 0, items: items2)

    # set the trade's params message
    params = {trade:[{survivor_id: survivor1.id, items:[{id: items1[0]},{id: items1[2]}]}, {survivor_id: survivor2.id, items:[{id: items1[0]}, {id: items1[1]}]}]}

    trade = Trade.new(params)
    TradeService.new(trade).call

    # refresh the survivors
    survivor1 = Survivor.find(survivor1.id)
    survivor2 = Survivor.find(survivor2.id)

    item_after1 = Item.where(id: [2, 3, 2])
    item_after2 = Item.where(id: [1, 4, 1])

    expect(survivor1.items).to eq(item_after1)
    expect(survivor2.items).to eq(item_after2)
  end
  it "test trade when it's infected survivor" do
    # setting the first survivor
    items1 = Item.where(id: [1, 2, 4]) #total points: 4+3+1 = 8
    survivor1 = Survivor.create!(name: "Teste automatico 1",
      age: 200, gender: 0, items: items1)

    survivor1.set_infected

    # setting the second survivor
    items2 = Item.where(id: [2, 3, 1]) #total points: 3+2+4 = 9
    survivor2 = Survivor.create!(name: "Teste automatico 2",
      age: 200, gender: 0, items: items2)

    # set the trade's params message
    params = {trade:[{survivor_id: survivor1.id, items:[{id: items1[0]},{id: items1[2]}]}, {survivor_id: survivor2.id, items:[{id: items1[0]}, {id: items1[1]}]}]}

    trade = Trade.new(params)
    TradeService.new(trade).call

    # refresh the survivors
    survivor1 = Survivor.find(survivor1.id)
    survivor2 = Survivor.find(survivor2.id)

     #items should be the same
    expect(survivor1.items).to eq(items1)
    expect(survivor2.items).to eq(items2)
  end
  it "test with items that the survivor doesn't own" do
    # setting the first survivor
    items1 = Item.where(id: [1, 2]) #total points: 4+3+1 = 8
    survivor1 = Survivor.create!(name: "Teste automatico 1",
      age: 200, gender: 0, items: items1)

    # setting the second survivor
    items2 = Item.where(id: [2, 3, 1]) #total points: 3+2+4 = 9
    survivor2 = Survivor.create!(name: "Teste automatico 2",
      age: 200, gender: 0, items: items2)

    # set the trade's params message
    params = {trade:[{survivor_id: survivor1.id, items:[{id: 3},{id: 2}]}, {survivor_id: survivor2.id, items:[{id: items1[0]}, {id: items1[1]}]}]}

    trade = Trade.new(params)
    TradeService.new(trade).call

    # refresh the survivors
    survivor1 = Survivor.find(survivor1.id)
    survivor2 = Survivor.find(survivor2.id)

     #items should be the same
    expect(survivor1.items).to eq(items1)
    expect(survivor2.items).to eq(items2)
  end
  it "test items with different sum of points" do
    # setting the first survivor
    items1 = Item.where(id: [1, 2, 4]) #total points: 4+3+1 = 8
    survivor1 = Survivor.create!(name: "Teste automatico 1",
      age: 200, gender: 0, items: items1)

    # setting the second survivor
    items2 = Item.where(id: [2, 3, 1]) #total points: 3+2+4 = 9
    survivor2 = Survivor.create!(name: "Teste automatico 2",
      age: 200, gender: 0, items: items2)

    # set the trade's params message
    params = {trade:[{survivor_id: survivor1.id, items:[{id: items1[0]},{id: items1[1]}]}, {survivor_id: survivor2.id, items:[{id: items1[0]}, {id: items1[1]}]}]}

    trade = Trade.new(params)
    TradeService.new(trade).call

    # refresh the survivors
    survivor1 = Survivor.find(survivor1.id)
    survivor2 = Survivor.find(survivor2.id)

     #items should be the same
    expect(survivor1.items).to eq(items1)
    expect(survivor2.items).to eq(items2)
  end
end
