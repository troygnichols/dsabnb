class AddAccomodationTypeToHosting < ActiveRecord::Migration
  def change
    add_column :hostings, :accomodation_type, :integer, :default => 0
  end
end
