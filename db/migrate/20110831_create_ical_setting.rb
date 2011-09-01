class CreateIcalSetting < ActiveRecord::Migration
  def self.up
    create_table :ical_settings do |t|
      t.column :project_id, :integer, :null => false
      t.column :tracker_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :url, :string, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ical_settings
  end
end

