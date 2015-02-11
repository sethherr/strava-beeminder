require 'spec_helper'

describe BeeminderIntegration do

  describe :goal_titles do 
    it "should get titles" do
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      titles = integration.goal_titles
      expect(titles.include?(ENV['SAMPLE_BEEMINDER_GOAL_TITLE'])).to be_truthy
    end
  end

  describe :goal_titles do 
    it "should get titles" do
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      goals = integration.get_goals
    end
  end


  describe :get_activity do 
    it "should get strava activity" do
      user = create_user
      goal_integration = create_goal_integration(user)
      integration = BeeminderIntegration.new({goal_integration: goal_integration, start: (Time.now - 1.years)})
      integration.update_activity_for_goal_integration
      goal_integration.reload
      expect(goal_integration.matching_activities.keys.count).to be > 5
    end
  end

  describe :get_slug do 
    it "should get the slug" do 
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      slug = integration.goal_slug(ENV['SAMPLE_BEEMINDER_GOAL_TITLE'])
      # pp slug
      expect(slug).to eq('run')
    end
  end

  describe :get_activity do 
    it "should get strava activity" do
      user = create_user
      goal_integration = create_goal_integration(user)
      integration = BeeminderIntegration.new({goal_integration: goal_integration})
      expect(integration.post_new_activity_to_beeminder).to be_truthy
    end
  end


end
