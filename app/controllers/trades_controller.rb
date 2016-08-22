class TradesController < ApplicationController
	skip_before_action :verify_authenticity_token
  
	def create
    trade = Trade.new(params)

    respond_to do |format|
      if TradeService.new(trade).call
        flash[:success] = "Troca realizada com sucesso!"
        format.html { render action: "new" }
        format.json { render json: params }
      else
        flash[:success] = "Troca não realizada."
        format.html { render action: "new" }
        format.json { render json: @survivor.errors, status: :unprocessable_entity }
      end
    end
	end
end
