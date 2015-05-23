class GoalIntegrationStravaActivity < ActiveRecord::Base
  belongs_to :strava_activity
  belongs_to :goal_integration
  validates_presence_of :goal_integration_id
  validates_presence_of :strava_activity_id
  validates_uniqueness_of :strava_activity_id, scope: [:goal_integration_id]
  delegate :activity_time, to: :strava_activity
  delegate :activity_time_local, to: :strava_activity
  delegate :name, to: :strava_activity
  delegate :url, to: :strava_activity

  scope :by_date, -> { joins(:strava_activity).order('strava_activities.activity_time DESC') }
  scope :for_beeminder, -> { where(should_beemind: true) }
  scope :not_for_beeminder, -> { where(should_beemind: false) }

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
