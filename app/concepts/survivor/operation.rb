class Survivor < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Survivor, :create

  	contract do
  		property :name,     validates: { presence: true }
  		property :age,      validates: { presence: true, numericality: { greater_than: 1, less_than: 105, message: "invalid age" } }
  		property :gender,   validates: { presence: true }
      property :latitude
      property :longitude
      collection :items
  	end

  	def process(params)
      validate(params[:survivor]) do |f|
        f.save
      end
    end

    class JSON < self
      # include JSON
    end
  end

  class Update < Create
    action :update

    contract do
      property :name, writeable: false
      property :age, writeable: false
      property :gender, writeable: false

      if :infected
        property :items, writeable: false
      end
    end
  end

  class Show < Trailblazer::Operation
  end

  class Delete < Trailblazer::Operation
  end
end