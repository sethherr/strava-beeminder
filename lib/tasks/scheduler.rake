# since rake task, and daily data forgetting, don't need to compile all on start.
# This is what I would do to compile all,
# putting it in the goal integrations create controller after save:
# BeeminderIntegration.new({goal_integration: @goal_integration, start: (Time.now - 1.years)}).update_activity_for_goal_integration

desc "Pull and update all possible goal integrations"
task update_goal_integrations: :environment do 
  puts "\n#{Time.now}      Running goal integration"
  GoalIntegration.all.each do |goal_integration|
    bee_int = BeeminderIntegration.new({goal_integration: goal_integration})
    puts bee_int
    bee_int.post_new_activity_to_beeminder
  end
  puts "END \n\n\n"
end