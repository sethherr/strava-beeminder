class GoalIntegration < ActiveRecord::Base
  belongs_to :user
  serialize :matching_activities

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

  
end
