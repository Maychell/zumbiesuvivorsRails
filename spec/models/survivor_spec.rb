require 'rails_helper'

RSpec.describe Survivor, type: :model do
  it "survivors order by id" do
    lindeman = Survivor.create!(name: "Teste automatico", age: 200, gender: 0)
    chelimsky = Survivor.create!(name: "Teste automatico 2", age: 190, gender: 1)
    joao = Survivor.create!(name: "Teste automatico joao", age: 19, gender: 0)
    maria = Survivor.create!(name: "Teste automatico maria", age: 12, gender: 1)
    jose = Survivor.create!(name: "Teste automatico jose", age: 40, gender: 0)

    expect(Survivor.all).to eq([lindeman, chelimsky, joao, maria, jose])
  end

  it "survivor not infected by default" do
    survivor = Survivor.create!(name: "infected survivor", age: 20, gender: 1)

    expect(survivor.infected).to eq(false)
  end

  it "survivor set infected" do
    survivor = Survivor.create!(name: "infected survivor", age: 20, gender: 1)
    survivor.set_infected

    expect(survivor.infected).to eq(true)
  end

  it "test items when creating survivor" do
    items = Item.where(id: [1, 2, 4])
    survivor = Survivor.create!(name: "Teste automatico",
      age: 200, gender: 0, items: items)

    expect(survivor.items).to eq(items)
  end
end
