class AddSentColumnToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :sent, :datetime
  end
end
