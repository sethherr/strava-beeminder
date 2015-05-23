class GoalIntegration < ActiveRecord::Base
  belongs_to :user
  has_many :goal_integration_strava_activities
  has_many :strava_activities, through: :goal_integration_strava_activities

  validates_presence_of :user_id, :unit, :activity_type, :goal_title

  validate :user_must_have_beeminder_token

  def user_must_have_beeminder_token
    unless user && user.beeminder_token.present?
      errors.add(:user_must_have_beeminder_token, "User must have beeminder token")
    end
  end

  def activity_keys
    matching_activities && matching_activities.keys || []
  end

  def get_activity
    StravaIntegration.new({goal_integration: self}).activities_for_goal_integration
  end

  
end
