class GoalIntegrationStravaActivity < ActiveRecord::Base
  belongs_to :strava_activity
  belongs_to :goal_integration
  validates_presence_of :goal_integration_id
  validates_presence_of :strava_activity_id
  validates_uniqueness_of :strava_activity_id, scope: [:goal_integration_id]

  def distance_for_integration
    strava_activity.distance_round(goal_integration.unit)
  end

  def self.create_from(gi, sa)
    unless self.where(goal_integration_id: gi.id, strava_activity_id: sa.id).present?
      create(goal_integration_id: gi.id,
        strava_activity_id: sa.id,
        should_beemind: (gi.created_at < sa.activity_time))
    end
  end

end
