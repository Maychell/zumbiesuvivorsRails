require 'rails_helper'

RSpec.describe ComplaintsController, type: :controller do

  let(:survivor) { Survivor::Create.(
      survivor: {
        name: "test", age: 12, gender: :male
      }
    ).model }
  
  let(:attributes) { { survivor_id: survivor.id } }

  it "responds successfully with an HTTP 200 status code" do
    get :new
    expect(response).to be_success
    expect(response).to have_http_status(200)
  end

  it "creates a new complaint" do
    expect{
      post :create, { :complaint => attributes }
    }.to change(Complaint,:count).by(1)
  end

  it "flags a survivor as infected by creating three complaints" do
    expect(survivor.infected).to eq(false) # the survivor starts as uninfected

    3.times { post :create, { :complaint => attributes } }
    survivor.reload

    expect(survivor.infected).to eq(true)
  end

  it "checks if a survivor is tagged as infected by creating two complaints" do
    2.times { post :create, { :complaint => attributes } }
    survivor.reload

    expect(survivor.infected).to eq(false)
  end
end
