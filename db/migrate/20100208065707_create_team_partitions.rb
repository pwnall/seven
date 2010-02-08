class CreateTeamPartitions < ActiveRecord::Migration
  def self.up
    create_table :team_partitions do |t|
      t.string :name
      t.boolean :manual
      t.boolean :frozen
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :team_partitions
  end
end
