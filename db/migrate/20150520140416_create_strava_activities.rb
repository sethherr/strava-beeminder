class CreateStravaActivities < ActiveRecord::Migration
  def change
    create_table :strava_activities do |t|
      t.integer :user_id
      t.string :strava_id
      t.json :data

      t.timestamps
    end
  end
end
