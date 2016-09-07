class Create < Trailblazer::Operation
  include Model; model Survivor, :create

	contract do
		property :name, validates: {presence: true}
		property :age, validates: {presence: true, numericality: { greater_than: 1, less_than: 105, message: "invalid age" } }
		property :gender, validates: {presence: true, inclusion: { in: %i[ male female ], message: "invalid gender" } }
    property :latitude
    property :longitude
    collection :items
	end

	def process(params)
    validate(params[:survivor]) do |f|
      f.save
    end
  end
end