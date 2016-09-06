require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do

  let(:survivor) {
    Survivor::Create[
      survivor: {
        name: "Rails", age:14, gender: :female
      }
    ].model
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
    survivor2 = Survivor::Create[
      survivor: { name: "Rails", age:14, gender: :female }
    ].model

    get :index

    expect(assigns(:survivors)).to match_array([survivor, survivor2])
  end

  # fix this test
  it "creates a new survivor" do
    # attributes = {name: "teste", age: 12, gender: :female}
    # expect{
      post :create, { survivor: { name: "Rails", age:14, gender: :female } }
      expect(response.status).to eq(200)
    # }.to change(Survivor,:count).by(1)
  end

  it "updates a survivor location" do
    attributes = { latitude: "100000", longitude: "4324234342" }

    put :update, { id: survivor.id, :survivor => attributes }
    survivor.reload

    expect(survivor.latitude).to eq(attributes[:latitude])
    expect(survivor.longitude).to eq(attributes[:longitude])
  end

  it "updates only the survivor location" do
    attributes = { latitude: "100000", longitude: "4324234342", name: "test atualizado", age: 30, gender: :male }

    put :update, { id: survivor.id, :survivor => attributes }
    survivor.reload

    expect(survivor.latitude).to eq(attributes[:latitude])
    expect(survivor.longitude).to eq(attributes[:longitude])
    expect(survivor.name).to eq("Rails")
    expect(survivor.age).to eq(14)
    expect(survivor.gender).to eq("female")
  end

end