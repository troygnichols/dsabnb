class AddStartEndDateToHostings < ActiveRecord::Migration
  def change
    add_column :hostings, :start_date, :date
    add_column :hostings, :end_date, :date
  end
end
