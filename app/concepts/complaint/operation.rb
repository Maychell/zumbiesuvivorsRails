class Complaint < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Complaint, :create
    
    MAX_NUMBER_OF_COMPLAINTS = 3

    contract do
      property :survivor_id
    end

    def process(params)
      validate(params[:complaint]) do |form|
        form.save

        on_high_number_of_complaints { set_survivor_as_infected }
      end
    end

    private

    def on_high_number_of_complaints
      yield if model.survivor.complaints.count >= MAX_NUMBER_OF_COMPLAINTS
    end

    def set_survivor_as_infected
      model.survivor.mark_infected
    end
  end
end