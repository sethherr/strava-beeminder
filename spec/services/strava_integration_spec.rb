require 'spec_helper'

describe StravaIntegration do

  describe :activity_types do 
    it "should get activities matching type" do 
      types = StravaIntegration.activity_types
      expect(types.count).to be > 20 
    end
  end

  describe :get_activities do 
    it "should get today's activities" do 
      user = FactoryGirl.create(:user, strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      integration = StravaIntegration.new(user: user)
      activities = integration.get_activities
      expect(activities.kind_of?(Array)).to be_true
    end
  end

  describe :store_activities do 
    it "should store activities" do
      user = FactoryGirl.create(:user, strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      integration = StravaIntegration.new(user: user)
      integration.store_activities
      user.reload
      expect(user.strava_activities.count).to be >= 2
      expect(user.strava_activities.first.data['type']).to match('Ride')
    end
  end

  describe :activities_matching do 
    it "should get activities matching type" do 
      user = FactoryGirl.create(:user, strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      start = Time.now - 1.years # So that we have enough activity ;)
      integration = StravaIntegration.new({user: user})
      activities = integration.activities_matching(' run')
      expect(activities.count).to be >= 1
    end
  end

  describe :activities_for_goal_integration do
    it "should get activities matching type and store them as goal_integration_strava_activities" do
      user = create_user
      goal_integration = create_goal_integration(user)
      goal_integration.update_attribute :created_at, Time.now - 2.weeks
      integration = StravaIntegration.new({goal_integration: goal_integration})
      integration.update_goal_integration_strava_activities
      goal_integration.reload
      expect(goal_integration.strava_activities.count).to be >= 2
      expect(goal_integration.goal_integration_strava_activities.first.should_beemind).to be_true
    end
  end

end
