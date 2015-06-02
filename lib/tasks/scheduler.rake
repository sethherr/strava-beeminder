desc "Pull and update all possible goal integrations"
task update_goal_integrations: :environment do 
  GoalIntegration.all.pluck(:id).each { |i| GoalIntegrationWorker.perform_async(i) }
end