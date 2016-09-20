require 'rails_helper'

RSpec.describe Complaint, type: :model do

  let(:survivor) {
    Survivor::Create.(
      survivor: {
        name: "test", age: 12, gender: :male
      }
    ).model
  }

  context 'when survivor has no complaints' do
    it 'checks infected by creating complaints' do
      expect(survivor.infected).to be_falsey
    end
  end

  context 'when survivor has 1 complaint' do
    it 'is not infected' do
      Complaint::Create.(complaint: { survivor_id: survivor.id })

      expect(survivor.reload.infected).to be_falsey
    end
  end

  context 'when survivor has 2 complaints' do
    it 'is not infected' do
      2.times {
        Complaint::Create.(
          complaint: { survivor_id: survivor.id }
        )
      }
      expect(survivor.infected).to be_falsey
    end
  end

  context 'when survivor has 3 complaints' do
    it 'is infected' do
      3.times {
        Complaint::Create.(complaint: { survivor_id: survivor.id })
      }

      expect(survivor.reload.infected).to be_truthy
    end
  end

  context 'when survivor has 10 complaints' do
    it 'is infected' do
      10.times {
        Complaint::Create.(complaint: { survivor_id: survivor.id })
      }

      expect(survivor.reload.infected).to be_truthy
    end
  end
end
