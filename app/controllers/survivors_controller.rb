class SurvivorsController < ApplicationController
  include Trailblazer::Operation::Controller
  skip_before_action :verify_authenticity_token

  respond_to :html, :json

  def new
    form Survivor::Create
  end

  def create
    # test = survivor_params
    # binding.pry
    @survivor = run Survivor::Create do
      return redirect_to action: "index"
    end

    render :new
  end

  def edit
    form Survivor::Update
  end

  def update
    @survivor = run Survivor::Update do
      return redirect_to action: "index"
    end

    render :new
  end

  def index
    @survivors = Survivor.all
  end
end
