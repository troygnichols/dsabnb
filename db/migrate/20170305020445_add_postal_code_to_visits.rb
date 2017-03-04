class AddPostalCodeToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :postal_code, :string
  end
end
