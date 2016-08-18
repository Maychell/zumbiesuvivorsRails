class AddFieldToUser < ActiveRecord::Migration
  def change
  	add_column :survivors, :gender, :integer
  end
end
