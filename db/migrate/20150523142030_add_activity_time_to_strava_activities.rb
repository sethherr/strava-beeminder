class AddActivityTimeToStravaActivities < ActiveRecord::Migration
  def change
    add_column :strava_activities, :activity_time, :datetime
  end
end
