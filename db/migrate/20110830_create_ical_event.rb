class CreateIcalEvent < ActiveRecord::Migration
  def self.up
    create_table :ical_events do |t|
      t.column :uid, :string, :null => false
      t.column :issue_id, :integer, :null => false
      t.column :ical_setting_id, :integer, :null => false
      t.column :start_date, :datetime, :null => true
      t.column :due_date, :datetime, :null => true
      t.column :location, :string, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :ical_events
  end
end

