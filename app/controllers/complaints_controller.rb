class ComplaintsController < ApplicationController
	include Trailblazer::Operation::Controller

  respond_to :html, :json

	def new
		# @complaint = Complaint.new
		form Complaint::Create
	end

	def create
		respond Complaint::Create do |op, format|
      if op.valid?
        format.html { redirect_to action: :new }
        format.json { render json: op.model }
      else
        format.html { render :new }
        format.json { render json: op.errors, status: :unprocessable_entity }
      end
    end
	end
end
