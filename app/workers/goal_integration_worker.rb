class GoalIntegrationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'checker', backtrace: true, :retry => false

  def perform(id)
    goal_integration = GoalIntegration.find(id)
    integration = BeeminderIntegration.new({goal_integration: goal_integration})
    integration.post_new_activity_to_beeminder
  end
  
end
