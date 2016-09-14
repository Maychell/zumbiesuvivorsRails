class SurvivorsController < ApplicationController
  include Trailblazer::Operation::Controller
  skip_before_action :verify_authenticity_token

  respond_to :html, :json

  def new
    form Survivor::Create
  end

  def create
    respond Survivor::Create do |op, format|
      if op.valid?
        format.html { redirect_to action: :index }
        format.json { render json: op.model }
      else
        format.html { render :new }
        format.json { render json: op.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    form Survivor::Update
  end

  def update
    respond Survivor::Update do |op, format|
      if op.valid?
        format.html { redirect_to action: :index }
        format.json { render json: op.model }
      else
        format.html { render :new }
        format.json { render json: op.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @survivors = Survivor.all
  end
end
