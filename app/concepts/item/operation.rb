class Item < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Item, :create

    contract Contract::Create

    def process(params)
      validate(params[:item]) do |f|
        f.save
      end
    end
  end
end