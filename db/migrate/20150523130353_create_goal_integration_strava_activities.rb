class CreateGoalIntegrationStravaActivities < ActiveRecord::Migration
  def change
    create_table :goal_integration_strava_activities do |t|
      t.integer :strava_activity_id
      t.integer :goal_integration_id 
      t.boolean :should_beemind, default: false, null: false

      t.timestamps
    end
  end
end
