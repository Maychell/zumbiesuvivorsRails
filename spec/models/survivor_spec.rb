require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:items) { Item.all.map { |item| [item.name, item] }.to_h }
  let(:survivor) {
    survivor = Survivor::Create.(
      survivor: { name: "Rails", age: 12, gender: :male }
    ).model
  }

  it "persists valid" do
    expect(survivor.persisted?).to eq(true)
    expect(survivor.name).to eq("Rails")
    expect(survivor.age).to eq(12)
    expect(survivor.gender).to eq("male")
  end

  it "tries to persist invalid" do
    res, survivor = Survivor::Create.run(
      survivor: { name: "", age: 106, gender: "" }
    )

    expect(res).to eq(false)
    expect(survivor.model.persisted?).to eq(false)
    expect(survivor.contract.errors.to_h[:name]).to eq("can't be blank")
    expect(survivor.contract.errors.to_h[:age]).to eq("invalid age")
    expect(survivor.contract.errors.to_h[:gender]).to eq("invalid gender")
  end

  it "survivors order by id" do
    fulano = survivor
    chelimsky = Survivor::Create.(
                  survivor: { name: "chelimsky", age: 12, gender: :male }
                ).model
    joao = Survivor::Create.(
                  survivor: { name: "Joao", age: 12, gender: :male }
                ).model
    maria = Survivor::Create.(
                  survivor: { name: "Maria", age: 12, gender: :female }
                ).model
    jose = Survivor::Create.(
                  survivor: { name: "Jose", age: 102, gender: :male }
                ).model

    expect(Survivor.all.to_json).to eq([fulano, chelimsky, joao, maria, jose].to_json)
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
