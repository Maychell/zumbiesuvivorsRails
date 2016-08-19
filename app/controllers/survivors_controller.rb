class SurvivorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @survivor = Survivor.new
    @survivor.inventories.build
  end

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

  def edit
    @survivor = Survivor.find(params[:id])
  end

  def update
    @survivor = Survivor.find(params[:id])
    respond_to do |format|
      if @survivor.update(survivor_update_params)
        format.html { redirect_to action: "index" }
        format.json { render json: @survivor}
      else
        format.html { redirect_to :back }
        format.json { render json: @survivor.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @survivors = Survivor.all
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :latitude, :longitude, inventories_attributes: [:item_id])
  end

  def survivor_update_params
    params.require(:survivor).permit(:latitude, :longitude)
  end
end
