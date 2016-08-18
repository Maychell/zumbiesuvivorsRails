class SurvivorsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def create
		@survivor = Survivor.new(survivor_params)
		respond_to do |format|
			if @survivor.save
				format.html { redirect_to action: "index" }
				format.json { render json: @survivor}
			else
				format.html { render action: "new" }
				format.json { render json: @survivor.errors, status: :unprocessable_entity }
			end
		end
	end
	def update
		
	end
	def index
		@survivors = Survivor.all
	end
	private
	def survivor_params
		params.require(:survivors).permit(:name, :age, :gender, :latitude, :longitude)
	end
end
