class Complaint < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Complaint, :create

    contract do
	    property :survivor_id
	  end

  	def process(params)
      validate(params[:complaint]) do |f|
        f.save

        check_number_of_complaints!(params[:complaint][:survivor_id])
      end
    end

    private

    def check_number_of_complaints!(survivor_id)
			if Complaint.where(survivor_id: survivor_id).count >= 3
				Survivor::SetInfected.(
		      id: survivor_id
		    )
				return false
			end
		end
  end
end