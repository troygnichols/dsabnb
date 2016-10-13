class AddStartEndDateToHostings < ActiveRecord::Migration
  def change
    add_column :hostings, :start_date, :date, null: false, :default => "2016-10-10"
    add_column :hostings, :end_date, :date, null: false, :default => "2016-11-10"
  end
end
