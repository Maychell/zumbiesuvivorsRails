class Survivor < ActiveRecord::Base
	validates :name, :age, :gender,
		presence: true

	enum gender: { male: 0, female: 1 }

	# set default order query
	default_scope { order(:id) }
end
