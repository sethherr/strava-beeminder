require 'spec_helper'

describe BeeminderIntegration do

  describe :goal_titles do 
    it "gets titles" do
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      titles = integration.goal_titles
      expect(titles.include?(ENV['SAMPLE_BEEMINDER_GOAL_TITLE'])).to be_true
    end
  end

  describe :goal_titles do
    it "gets titles" do
      user = User.new(beeminder_token: ENV['BEEMINDER_ACCESS_TOKEN'] )
      integration = BeeminderIntegration.new(user: user)
      goals = integration.get_goals
    end
  end


  describe :update_goal_integration_strava_activities do 
    it "gets strava activity" do
      user = create_user
      goal_integration = create_goal_integration(user)
      integration = BeeminderIntegration.new({goal_integration: goal_integration})
      expect_any_instance_of(StravaIntegration).to receive(:update_goal_integration_strava_activities)
      integration.update_goal_integration_strava_activities
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

    it "doesn't ruin everything if someone puts a goal they don't have in" do 
      user = create_user
      goal_integration = create_goal_integration(user)
      goal_integration.update_attribute :goal_title, 'for fucks sake put a functioning title in you dofus'
      integration = BeeminderIntegration.new({goal_integration: goal_integration})
      expect { integration.set_goal }.to raise_error
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

  describe :post_new_activity_to_beeminder do 
    it "gets strava activity and posts" do
      user = create_user
      goal_integration = create_goal_integration(user)
      integration = BeeminderIntegration.new({goal_integration: goal_integration})
      expect(integration.post_new_activity_to_beeminder).to be_true
    end
  end


end
