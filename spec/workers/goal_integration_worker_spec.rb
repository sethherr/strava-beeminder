require 'spec_helper'

describe GoalIntegrationWorker do

  it "reads request blocks" do 
    user = create_user
    goal_integration = create_goal_integration(user)
    BeeminderIntegration.any_instance.should_receive(:post_new_activity_to_beeminder)
    GoalIntegrationWorker.new.perform(goal_integration.id)
  end

end
