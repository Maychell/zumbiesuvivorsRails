class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
    	t.belongs_to :survivor

      t.timestamps null: false
    end
  end
end
