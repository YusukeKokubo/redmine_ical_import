class CreateIcalUidRelation < ActiveRecord::Migration
  def self.up
    create_table :ical_uid_relations do |t|
      t.column :uid, :string, :null => false
      t.column :issue_id, :integer, :null => false
      t.column :ical_setting_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ical_uid_relations
  end
end

