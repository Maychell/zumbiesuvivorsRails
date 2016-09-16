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

  it "responds successfully with an HTTP 200 status code" do
    get :index
    expect(response).to be_success
    expect(response).to have_http_status(200)
  end

  it "renders the index template" do
    get :index
    expect(response).to render_template("index")
  end

  it "renders the new template" do
    get :new
    expect(response).to render_template("new")
  end

  it "renders the edit template" do
    get :edit, { id: survivor.id }
    expect(response).to render_template("edit")
  end

  it "renders the new template" do
    get :new
    expect(response).to render_template("new")
  end

  it "renders the index template with survivors array" do
    survivor2 = Survivor::Create.(
      survivor: { name: "Rails", age:14, gender: :female }
    ).model

    get :index

    expect(assigns(:survivors)).to match_array([survivor, survivor2])
  end

  it "creates a new survivor" do
    expect{
      post :create, { survivor: { name: "Rails", age: 14, gender: :female } }
    }.to change(Survivor,:count).by(1)
  end

  # didn't finish yet
  it "tests json format response" do
    form = { survivor: { name: "Rails", age: 14, gender: :female, items: [items['1 Water'], items['1 Food'], items['1 Ammunition']] } }
    post :create, form.to_json, form.merge(format: 'json')

    assert_equal Mime::JSON, response.content_type

    # post :create, { survivor: { name: "Rails", age: 14, gender: :female } }, { 'Accept' => Mime::JSON }
    # puts 'teste: '
    # puts response.content_type
    # assert_equal Mime::JSON, response.content_type
  end

  it "updates a survivor location" do
    attributes = { latitude: "100000", longitude: "4324234342" }

    put :update, { id: survivor.id, :survivor => attributes }
    survivor.reload

    expect(survivor.latitude).to eq(attributes[:latitude])
    expect(survivor.longitude).to eq(attributes[:longitude])
  end

  it "updates only the survivor location" do
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