class Create < Trailblazer::Operation
  include Model; model Survivor, :create

	contract do
		property :name, validates: {presence: true}
		property :age, validates: {presence: true, inclusion: { in: 1..105, message: "invalid age" } }
		property :gender, validates: {presence: true, inclusion: { in: %i[ male female ], message: "invalid gender" } }
	end

	def process(params)
    validate(params[:survivor]) do |f|
      f.save
    end
  end
end