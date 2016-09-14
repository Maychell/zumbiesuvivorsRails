require 'rails_helper'

RSpec.describe Complaint, type: :model do

  let(:survivor) {
    Survivor::Create.(
      survivor: {
        name: "test", age: 12, gender: :male
      }
    ).model
  }

  it "check infected by creating complaints" do
    expect(survivor.infected).to eq(false)
  end

  it "set infected by number of complaints" do
    3.times {
      Complaint::Create.(
        complaint: { survivor_id: survivor.id }
      )
    }

    survivor.reload

    expect(survivor.infected).to eq(true)
  end

  it "check infected by over number of complaints" do
    10.times {
      Complaint::Create.(
        complaint: { survivor_id: survivor.id }
      )
    }

    survivor.reload

    expect(survivor.infected).to eq(true)
  end

  it "check infected by two complaints" do
    2.times {
      Complaint::Create.(
        complaint: { survivor_id: survivor.id }
      )
    }
    expect(survivor.infected).to eq(false)
  end
end
