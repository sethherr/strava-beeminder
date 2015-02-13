require 'spec_helper'

describe BeeminderIntegration do

  describe :goal_titles do 
    it "gets titles" do
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      titles = integration.goal_titles
      expect(titles.include?(ENV['SAMPLE_BEEMINDER_GOAL_TITLE'])).to be_truthy
    end
  end

  describe :goal_titles do 
    it "gets titles" do
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      goals = integration.get_goals
    end
  end


  describe :get_activity do 
    it "gets strava activity" do
      user = create_user
      goal_integration = create_goal_integration(user)
      goal_integration.update_attribute :created_at, Time.now - 1.week
      integration = BeeminderIntegration.new({goal_integration: goal_integration})
      integration.update_activity_for_goal_integration
      goal_integration.reload
      expect(goal_integration.matching_activities.count).to be > 3
    end
  end

  describe :get_goal_comments do 
    it "gets datapoints for the goal" do 
      user = create_user
      goal_integration = create_goal_integration(user)
      goal_integration.update_attribute :created_at, Time.now - 1.week
      integration = BeeminderIntegration.new({goal_integration: goal_integration})
      integration.set_goal
      comments = integration.get_goal_comments
      posted = comments.select { |d| d.match(ENV['SAMPLE_STRAVA_URI']) }
      expect(posted).to be_present
    end
  end

  describe :get_slug do 
    it "gets the slug" do 
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      slug = integration.goal_slug(ENV['SAMPLE_BEEMINDER_GOAL_TITLE'])
      # pp slug
      expect(slug).to eq('run')
    end
  end

  describe :get_activity do 
    it "gets strava activity and posts" do
      user = create_user
      goal_integration = create_goal_integration(user)
      integration = BeeminderIntegration.new({goal_integration: goal_integration})
      expect(integration.post_new_activity_to_beeminder).to be_truthy
    end
  end

  describe 'convert' do 
    it "converts distance" do 
      user = User.new
      integration = BeeminderIntegration.new({user: user, unit: 'feet'})
      expect(integration.distance(1)).to eq(3.2808333333)
    end
  end


end
