require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:items) { Item.all.map { |item| [item.name, item] }.to_h }
  let(:survivor) {
    survivor = Survivor::Create.(
      survivor: { name: "Rails", age: 12, gender: :male }
    ).model
  }

  describe "Create tests" do

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
      fulano    = survivor
      chelimsky = Survivor::Create.(
                    survivor: { name: "chelimsky", age: 12, gender: :male }
                  ).model
      joao      = Survivor::Create.(
                    survivor: { name: "Joao", age: 12, gender: :male }
                  ).model
      maria     = Survivor::Create.(
                    survivor: { name: "Maria", age: 12, gender: :female }
                  ).model
      jose      = Survivor::Create.(
                    survivor: { name: "Jose", age: 102, gender: :male }
                  ).model

      expect(Survivor.all.to_json).to eq([fulano, chelimsky, joao, maria, jose].to_json)
    end

    it "survivor not infected by default" do
      expect(survivor.infected).to eq(false)
    end

    it "survivor set infected" do
      survivor.set_infected

      expect(survivor.infected).to eq(true)
    end

    it "test items when creating survivor" do
      survivor1 = survivor = Survivor::Create.(
        survivor: { name: "Rails", age: 12, gender: :male, items: [items['1 Water'], items['1 Food'], items['1 Ammunition']] }
      ).model

      expect(survivor1.items).to eq([items['1 Water'], items['1 Food'], items['1 Ammunition']])
    end

    it "test create survivor when setting both latitude and longitude" do
      survivor = Survivor::Create.(
        survivor: { name: "survivor", age: 20, gender: :female, latitude: "324324234", longitude: "4324234234" }
      ).model

      expect(survivor.latitude).to eq("324324234")
      expect(survivor.longitude).to eq("4324234234")
    end
  end

  describe "Update actions" do

    it "update survivor's location" do
      Survivor::Update.(
        id: survivor.id,
        survivor: { latitude: "123456", gender: :female, longitude: "654321" }
      ).model

      survivor.reload
      expect(survivor.gender).to eq("male")
      expect(survivor.latitude).to eq("123456")
      expect(survivor.longitude).to eq("654321")
    end

    it "tries to update others survivor's params" do
      Survivor::Update.(
        id: survivor.id,
        survivor: { name: "new name", age: 85, gender: :female, latitude: "123456", longitude: "654321" }
      ).model

      survivor.reload
      expect(survivor.name).to eq("Rails")
      expect(survivor.age).to eq(12)
      expect(survivor.gender).to eq("male")
      expect(survivor.latitude).to eq("123456")
      expect(survivor.longitude).to eq("654321")
    end

    it "tries to update the survivor's infected inventory" do
      survivor.set_infected

      Survivor::Update.(
        id: survivor.id,
        survivor: { gender: :female, items: [items['1 Water'], items['1 Food'], items['1 Ammunition']] }
      )

      survivor.reload

      expect(survivor.items.size).to eq(0)
    end
  end
end
