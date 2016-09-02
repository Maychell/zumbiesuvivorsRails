require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:items) { Item.all.map { |item| [item.name, item] }.to_h }

  it "survivors order by id" do
    fulano = FactoryGirl.create(:survivor)
    chelimsky = FactoryGirl.create(:survivor_chelimsky)
    joao = FactoryGirl.create(:survivor_joao)
    maria = FactoryGirl.create(:survivor_maria)
    jose = FactoryGirl.create(:survivor_jose)

    expect(Survivor.all).to eq([fulano, chelimsky, joao, maria, jose])
  end

  it "survivor not infected by default" do
    survivor = FactoryGirl.create(:survivor)

    expect(survivor.infected).to eq(false)
  end

  it "survivor set infected" do
    survivor = Survivor.create!(name: "infected survivor", age: 20, gender: 1)
    survivor.set_infected

    expect(survivor.infected).to eq(true)
  end

  it "test items when creating survivor" do
    survivor = FactoryGirl.create(:survivor, items: [items['1 Water'], items['1 Food'], items['1 Ammunition']])

    expect(survivor.items).to eq([items['1 Water'], items['1 Food'], items['1 Ammunition']])
  end
end
