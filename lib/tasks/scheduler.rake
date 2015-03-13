desc "Pull and update all possible goal integrations"
task update_goal_integrations: :environment do 
  GoalIntegration.all.each do |goal_integration|
    bee_int = BeeminderIntegration.new({goal_integration: goal_integration})
    begin
      bee_int.post_new_activity_to_beeminder
    rescue => e
      puts "SOMETHING BROKEN"
      puts e
    end
  end
end