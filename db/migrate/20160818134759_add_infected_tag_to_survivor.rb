class AddInfectedTagToSurvivor < ActiveRecord::Migration
  def change
  	add_column :survivors, :infected, :boolean, default: false
  end
end
