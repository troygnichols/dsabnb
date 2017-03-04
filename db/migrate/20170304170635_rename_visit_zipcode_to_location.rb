class RenameVisitZipcodeToLocation < ActiveRecord::Migration
  def up
    add_column :visits, :location, :string, null: true
    Visit.find_each do |v|
      execute "UPDATE visits SET location='#{v.zipcode}' WHERE id = '#{v.id}'"
    end
    remove_column :visits, :zipcode
    change_column :visits, :location, :string, null: false
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This would be a destructive migration. If you really want to do it see #{__FILE__} and comment out this raise"

    remove_column :visits, :location
    add_column :visits, :zipcode, :string, null: true
    Visit.find_each do |v|
      execute "UPDATE visits set zipcode='00000'"
    end
    change_column :visits, :zipcode, :string, null: false
  end
end
