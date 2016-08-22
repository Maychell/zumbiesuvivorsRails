require 'rails_helper'

RSpec.describe Complaint, type: :model do
  it "check infected by creating complaints" do
    survivor = Survivor.create!(name: "shouldn't be infected", age: 20, gender: 1)

    expect(survivor.infected).to eq(false)
  end

  it "set infected by number of complaints" do
  	survivor = Survivor.create!(name: "infect by number of complaints", age: 20, gender: 1)

    3.times {
      Complaint.create!(survivor: survivor)
    }
    expect(survivor.infected).to eq(true)
  end

  it "check infected by over number of complaints" do
    survivor = Survivor.create!(name: "should be infected!", age: 20, gender: 1)

    10.times {
      Complaint.create!(survivor: survivor)
    }
    expect(survivor.infected).to eq(true)
  end

  it "check infected by two complaints" do
    survivor = Survivor.create!(name: "shouldn't be infected", age: 20, gender: 1)

    2.times {
      Complaint.create!(survivor: survivor)
    }
    expect(survivor.infected).to eq(false)
  end
end
