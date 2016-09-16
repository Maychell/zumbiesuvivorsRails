class TradesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  respond_to :json, :html

  def create
    respond TradeOperation::Create do |op, format|
      if op.valid?
        format.html { render :new }
        format.json { render json: op.model }
      else
        format.html { render :new }
        format.json { render json: op.errors, status: :unprocessable_entity }
      end
    end
  end
end
