require 'rails_helper'

RSpec.describe Survivor, type: :model do
  let(:items) { Item.all.map { |item| [item.name, item] }.to_h }

  def create_survivor(params)
    Survivor::Create.(survivor: params).model
  end

  describe "Create tests" do

    context 'with valid attributes' do
      it "is persisted" do
        survivor = create_survivor(name: "Rails", age: 12, gender: :male)

        expect(survivor).to be_persisted
        expect(survivor).to have_attributes(
          name: 'Rails',
          age: 12,
          gender: 'male'
        )
      end
    end

    context 'with invalid attributes' do
      it "is not persisted and has validation errors" do
        res, survivor = Survivor::Create.run(
          survivor: { name: "", age: 106, gender: "" }
        )

        expect(res).to eq(false)
        expect(survivor.model).to_not be_persisted
        expect(survivor.contract.errors.to_h).to include(
          name: "can't be blank",
          age: 'invalid age',
          gender: "can't be blank"
        )
      end
    end

    it "with survivors ordered by id" do
      fulano    = create_survivor(name: "Rails", age: 12, gender: :male)
      chelimsky = create_survivor(name: "chelimsky", age: 12, gender: :male)
      joao      = create_survivor(name: "Joao", age: 12, gender: :male )
      maria     = create_survivor(name: "Maria", age: 12, gender: :female)
      jose      = create_survivor(name: "Jose", age: 102, gender: :male)

      expect(Survivor.all.to_json).to eq([fulano, chelimsky, joao, maria, jose].to_json)
    end

    context 'with default values' do
      it 'is not infected' do
        survivor = create_survivor(name: "Rails", age: 12, gender: :male)

        expect(survivor).to_not be_infected
      end
    end

    it "survivor set infected" do
      survivor = create_survivor(name: "Rails", age: 12, gender: :male)
      survivor.mark_infected

      expect(survivor).to be_infected
    end

    it "with items" do
      survivor = create_survivor(
        name: "Rails",
        age: 12,
        gender: :male,
        items: [
          items['1 Water'],
          items['1 Food'],
          items['1 Ammunition']
        ]
      )

      survivor.reload

      expect(survivor.items).to eq([items['1 Water'], items['1 Food'], items['1 Ammunition']])
    end

    it "with latitude and longitude" do
      survivor = create_survivor(
        name: "survivor",
        age: 20,
        gender: :female,
        latitude: "324324234",
        longitude: "4324234234"
      )

      expect(survivor.latitude).to eq("324324234")
      expect(survivor.longitude).to eq("4324234234")
    end
  end

  describe "Update actions" do

    it "with survivor's location" do
      survivor = create_survivor(name: "Rails", age: 12, gender: :male)

      Survivor::Update.(
        id: survivor.id,
        survivor: { latitude: "123456", longitude: "654321" }
      ).model

      expect(survivor.reload).to have_attributes(
        latitude: '123456',
        longitude: '654321'
      )
    end

    it "tries to update others survivor's params" do
      survivor = create_survivor(name: "Rails", age: 12, gender: :male)

      Survivor::Update.(
        id: survivor.id,
        survivor: { name: "new name", age: 85, gender: :female, latitude: "123456", longitude: "654321" }
      ).model

      expect(survivor.reload).to have_attributes(
        name: 'Rails',
        age: 12,
        gender: 'male',
        latitude: '123456',
        longitude: '654321'
      )
    end

    it "tries to update the survivor's infected inventory" do
      survivor = create_survivor(name: "Rails", age: 12, gender: :male)
      survivor.mark_infected

      Survivor::Update.(
        id: survivor.id,
        survivor: { gender: :female, items: [items['1 Water'], items['1 Food'], items['1 Ammunition']] }
      )

      expect(survivor.items.size).to eq(0)
    end
  end
end
