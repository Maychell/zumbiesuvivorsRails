class Survivor < ActiveRecord::Base
	validates :name, :age, :gender,
		presence: true

	enum gender: { male: 0, female: 1 }
end
