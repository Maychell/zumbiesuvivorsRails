require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do

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
    survivor = Survivor.create!(name: "test", age: 12, gender: :female)
    get :edit, { id: survivor.id }
    expect(response).to render_template("edit")
  end

  it "renders the new template" do
    get :new
    expect(response).to render_template("new")
  end

  it "renders the index template with survivors array" do
    survivor1 = Survivor.create(name: "survivor", age: 19, gender: 0)
    survivor2 = Survivor.create(name: "survivor 2", age: 29, gender: 1)
    get :index

    expect(assigns(:survivors)).to match_array([survivor1, survivor2])
  end

  it "creates a new survivor" do
    attributes = {name: "teste", age: 12, gender: :female}
    expect{
      post :create, { :survivor => attributes }
    }.to change(Survivor,:count).by(1)
  end

  it "updates a survivor location" do
    survivor = Survivor.create!(name: "test", age: 12, gender: :female)
    attributes = { latitude: "100000", longitude: "4324234342" }

    put :update, { id: survivor.id, :survivor => attributes }
    survivor.reload

    expect(survivor.latitude).to eq(attributes[:latitude])
    expect(survivor.longitude).to eq(attributes[:longitude])
  end

  it "updates only the survivor location" do
    survivor = Survivor.create!(name: "test", age: 12, gender: :female)
    attributes = { latitude: "100000", longitude: "4324234342", name: "test atualizado", age: 30, gender: :male }

    put :update, { id: survivor.id, :survivor => attributes }
    survivor.reload

    expect(survivor.latitude).to eq(attributes[:latitude])
    expect(survivor.longitude).to eq(attributes[:longitude])
    expect(survivor.name).to eq("test")
    expect(survivor.age).to eq(12)
    expect(survivor.gender).to eq("female")
  end

end