class ComplaintsController < ApplicationController
	def new
		@complaint = Complaint.new
	end
	def create
		@complaint = Complaint.new(complaint_params)
		respond_to do |format|
			if @complaint.save
				format.html { redirect_to action: 'new' }
				format.json { render json: @complaint }
			else
				format.html { render action: "new" }
				format.json { render json: @complaint.errors, status: :unprocessable_entity }
			end
		end
	end
	private
	def complaint_params
		params.require(:complaint).permit(:survivor_id)
	end
end
