class Create < Trailblazer::Operation
  include Model
	# model Survivor, :create
  include Model; model Survivor, :create

	contract do
		property :name, validates: {presence: true}
		property :age, validates: {presence: true, inclusion: { in: 1..105, message: "invalid age" } }
		property :gender, validates: {presence: true, inclusion: { in: %i[ male female ], message: "invalid gender" } }
    # property :gender, validates: {presence: true, acceptance: { accept: [:male, :female] } }
	end

	def process(params)
    model = Survivor.new

    validate(params[:survivor]) do |f|
      f.save
    end
  end
end