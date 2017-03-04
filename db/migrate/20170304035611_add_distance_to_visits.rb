class AddDistanceToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :distance, :integer
  end
end
