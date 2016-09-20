require 'rails_helper'

RSpec.describe ComplaintsController, type: :controller do

  let(:survivor) { Survivor::Create.(
      survivor: {
        name: "test", age: 12, gender: :male
      }
    ).model }
  
  let(:attributes) { { survivor_id: survivor.id } }

  context 'when call the new template' do
    it 'responds successfully with an HTTP 200 status code' do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  context 'when creating a complaint' do
    it 'increases the number of complaints' do
      expect{
        post :create, { :complaint => attributes }
      }.to change(Complaint,:count).by(1)
    end
  end

  context 'when creating two complaints' do
    it 'the survivor is not flagged as infected' do
      2.times { post :create, { :complaint => attributes } }

      expect(survivor.reload.infected).to eq(false)
    end
  end

  context 'when creating three complaints' do
    it 'the survivor is flagged as infected' do
      expect(survivor.infected).to eq(false) # the survivor starts as uninfected

      3.times { post :create, { :complaint => attributes } }

      expect(survivor.reload.infected).to eq(true)
    end
  end
end
