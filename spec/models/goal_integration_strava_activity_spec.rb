require 'spec_helper'

describe GoalIntegrationStravaActivity do
  describe :validations do
    it { should belong_to :goal_integration }
    it { should belong_to :strava_activity }
    it { should validate_presence_of :strava_activity_id }
    it { should validate_presence_of :goal_integration_id }
    it { should validate_uniqueness_of(:strava_activity_id).scoped_to(:goal_integration_id) }
  end
  
end
