desc "Pull and update all possible goal integrations"
task update_goal_integrations: :environment do 
  GoalIntegration.all.each do |goal_integration|
    BeeminderIntegration.new({goal_integration: goal_integration}).post_new_activity_to_beeminder
  end
end