require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do

  let(:items) { Item.all.map { |item| [item.name, item] }.to_h }
  let(:survivor) {
    Survivor::Create.(
      survivor: {
        name: "Rails", age: 14, gender: :female
      }
    ).model
  }

  context 'when call the index template' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template("index")
    end

    it 'renders the index template with survivors array' do
      survivor2 = Survivor::Create.(
        survivor: { name: "Rails", age:14, gender: :female }
      ).model

      get :index

      expect(assigns(:survivors)).to match_array([survivor, survivor2])
    end
  end

  context 'when call the new template' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template("new")
    end
  end

  context 'when call the edit template' do
    it 'renders the edit template' do
      get :edit, { id: survivor.id }
      expect(response).to render_template("edit")
    end
  end

  context 'when creating a survivor' do
    it 'increases the number of survivors' do
      expect{
        post :create, { survivor: { name: "Rails", age: 14, gender: :female } }
      }.to change(Survivor,:count).by(1)
    end

    it 'with three items, the amount of items should be three' do
      form = { survivor: { name: "Rails", age: 14, gender: :female, items: [items['1 Water'], items['1 Food'], items['1 Ammunition']] } }
      post :create, form.to_json, form.merge(format: 'json')
      
      surv = Survivor.last
      assert_equal surv.items.count, 3
    end
  end

  context 'when the request is in json format' do
    it 'it should response in json format' do
      form = { survivor: { name: "Rails", age: 14, gender: :female, items: [items['1 Water'], items['1 Food'], items['1 Ammunition']] } }
      post :create, form.to_json, form.merge(format: 'json')

      assert_equal Mime::JSON, response.content_type
    end
  end

  context 'when updating a survivor' do
    it "the survivor's location is updated" do
      attributes = { latitude: "100000", longitude: "4324234342" }

      put :update, { id: survivor.id, :survivor => attributes }
      survivor.reload

      expect(survivor.latitude).to eq(attributes[:latitude])
      expect(survivor.longitude).to eq(attributes[:longitude])
    end

    it 'only the survivors location is updated' do
      attributes = { latitude: "100000", longitude: "4324234342", name: "test", age: 30, gender: :male }

      put :update, { id: survivor.id, :survivor => attributes }
      survivor.reload

      expect(survivor.latitude).to eq(attributes[:latitude])
      expect(survivor.longitude).to eq(attributes[:longitude])
      expect(survivor.name).to eq("Rails")
      expect(survivor.age).to eq(14)
      expect(survivor.gender).to eq("female")
    end
  end
end