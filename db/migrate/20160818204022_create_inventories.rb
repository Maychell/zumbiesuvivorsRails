class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
    	t.belongs_to :survivor
    	t.belongs_to :item

      t.timestamps null: false
    end
  end
end
