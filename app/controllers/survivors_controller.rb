class SurvivorsController < ApplicationController
  include Trailblazer::Operation::Controller
  skip_before_action :verify_authenticity_token

  respond_to :html, :json

  def new
    @survivor = Survivor.new
    @survivor.inventories.build

    form Survivor::Create
  end

  # respond_to :html

  def create

    @contract = run Survivor::Create do
      return redirect_to action: "index"
    end
    # binding.pry

    @survivor = @contract.model
    render :new

    # render :new

    # run Survivor::Create

    # respond_to do |format|
    #   run Survivor::Create do |op|
    #     format.html { redirect_to action: "index" }
    #     format.json { render json: op.model, status: :success }
    #   end

    #   format.html { render action: "new" }
    #   format.json { render json: @op.model.contract.errors, status: :unprocessable_entity }
    # end

    # run Survivor::Create do |op|
    #   return redirect_to op.model, status: :success # success.
    # end

    # Survivor::Create.run(params[:survivor]) do |contract|
    #   return redirect_to(contract.model)
    # end

    # @survivors = Survivor.all

    # render action: :index

    # run Comment::Create do |op|
    #   flash[:notice] = "Created comment for \"#{op.thing.name}\""
    #   return redirect_to thing_path(op.thing)
    # end

    # @thing = Thing.find(params[:thing_id]) # UI-specific logic!

    # render :new


    # @survivor = Survivor.new(survivor_params)

    # run Survivor::Create do |op|
    #   # format.json { render status: :created, json: op.to_json }
    #   # format.html { redirect_to action: "index" }
    #   render 'index'
    # end

    # @survivor = Survivor.new
    # render 'new'


    # respond Survivor::Create do |op, formats|

    #   formats.html { redirect_to(op.model, :notice => op.valid? ? "All good!" : "Fail!") }
    #   formats.json { render nothing: true }
    # end
    
    # respond_to do |format|
      # run Survivor::Create do |survivor|
      #   # return format.html { redirect_to action: "index" }
      #   # format.json { render json: survivor}
      #   flash[:notice] = "Success!"
      #   render 'index'
      # end

      # @survivor = Survivor.new

      # format.html { render action: "new" }
      # format.json { render json: @survivor.errors, status: :unprocessable_entity }
    # end
  end

  def edit
    @survivor = Survivor.find(params[:id])
    # form Survivor::Update

    # render action: :new
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
