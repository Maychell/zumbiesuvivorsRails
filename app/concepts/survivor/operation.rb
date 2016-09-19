class Survivor < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Survivor, :create

    contract Contract::Create

    def process(params)
      # binding.pry
      # binding.pry
      validate(params[:survivor]) do |f|
        f.save
      end
    end
  end

  class Update < Create
    action :update

    contract Contract::Update
  end
end