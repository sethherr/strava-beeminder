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
      user = User.new(strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      integration = StravaIntegration.new(user: user)
      activities = integration.get_activities
      expect(activities.kind_of?(Array)).to be_truthy
    end
  end

  describe :activities_matching do 
    it "should get activities matching type" do 
      user = User.new(strava_token: ENV['STRAVA_ACCESS_TOKEN'] )
      start = Time.now - 1.years # So that we have enough activity ;)
      integration = StravaIntegration.new({user: user})
      activities = integration.activities_matching(' run')
      expect(activities.count).to be > 4
    end
  end

  describe :activities_for_goal_integration do 
    it "should set the activity hash" do 
      user = create_user
      goal_integration = create_goal_integration(user)
      goal_integration.update_attribute :created_at, Time.now - 1.week
      integration = StravaIntegration.new({goal_integration: goal_integration})
      formatted_activities = integration.activities_for_goal_integration
      expect(formatted_activities.count).to be > 4
      expect(formatted_activities.first.keys).to eq([:id, :distance_in_m, :time, :name, :uri])
    end
  end

end
