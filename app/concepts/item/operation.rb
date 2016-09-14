class Item < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Item, :create

  	contract do
  		property :name,  validates: { presence: true }
  		property :points

      validates_uniqueness_of :name
  	end

  	def process(params)
      validate(params[:item]) do |f|
        f.save
      end
    end
  end
end