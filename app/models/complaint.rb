class Complaint < ActiveRecord::Base
	belongs_to :survivor
	after_save :check_number_of_complaints

	def check_number_of_complaints
		if Complaint.where(survivor_id: self.survivor.id).count >= 3
			self.survivor.set_infected
			return false
		end
	end
end
