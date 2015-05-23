require 'spec_helper'

RSpec.describe GoalIntegration, type: :model do
  describe :validations do
    it { should belong_to :user }
    it { should have_many :goal_integration_strava_activities }
    it { should have_many :strava_activities }
  end

  describe :get_activity do 
    it "gets activity" do 
      goal_integration = GoalIntegration.new
      expect_any_instance_of(StravaIntegration).to receive(:initialize).with({goal_integration: goal_integration})
      expect_any_instance_of(StravaIntegration).to receive(:activities_for_goal_integration)
      goal_integration.get_activity
    end
  end

end
