class CreateGoalIntegrations < ActiveRecord::Migration
  def change
    create_table :goal_integrations do |t|
      t.integer :user_id
      t.string :goal_title
      t.string :activity_type
      t.text :matching_activities
      t.string :unit

      t.timestamps
    end
  end
end
