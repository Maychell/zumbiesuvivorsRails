require 'rails_helper'

RSpec.describe Complaint, type: :model do

  let(:survivor) { FactoryGirl.create(:survivor) }

  it "check infected by creating complaints" do
    expect(survivor.infected).to eq(false)
  end

  it "set infected by number of complaints" do
    3.times {
      Complaint.create!(survivor: survivor)
    }

    expect(survivor.infected).to eq(true)
  end

  it "check infected by over number of complaints" do
    10.times {
      Complaint.create!(survivor: survivor)
    }
    expect(survivor.infected).to eq(true)
  end

  it "check infected by two complaints" do
    2.times {
      Complaint.create!(survivor: survivor)
    }
    expect(survivor.infected).to eq(false)
  end
end
