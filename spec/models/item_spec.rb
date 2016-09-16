require 'rails_helper'

RSpec.describe Item, type: :model do
  it "check the number of items" do
    expect(Item.count).to eq(4)
  end
end
