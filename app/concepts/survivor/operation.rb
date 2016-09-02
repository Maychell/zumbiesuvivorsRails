
  class Create < Trailblazer::Operation
  	# include Resolver
   #  include Representer
    include Model
  	model Survivor, :create

  	contract do
  		property :name, validates: {presence: true}
  		property :age, validates: {presence: true}
  		property :gender, validates: {presence: true}
  	end

  	def process(params)
	    model = Survivor.new

	    validate(params[:survivor]) do |f|
	      f.save
	    end
	  end
  end