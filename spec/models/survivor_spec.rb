require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:items) { Item.all.map { |item| [item.name, item] }.to_h }

  it "persists valid" do
    survivor = Survivor::Create[survivor:
      {name: "Rails", age: 12, gender: :male}
    ].model

    expect(survivor.persisted?).to eq(true)
    expect(survivor.name).to eq("Rails")
    expect(survivor.age).to eq(12)
    expect(survivor.gender).to eq("male")
  end

  it "tries to persist invalid" do
    res, survivor = Survivor::Create.run(survivor:
      {name: "", age: 106, gender: ""}
    )

    expect(res).to eq(false)
    expect(survivor.model.persisted?).to eq(false)
    expect(survivor.contract.errors.to_h[:name]).to eq("can't be blank")
    expect(survivor.contract.errors.to_h[:age]).to eq("invalid age")
    expect(survivor.contract.errors.to_h[:gender]).to eq("invalid gender")
  end

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
