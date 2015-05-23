# Rake task in scheduler is run every hour. 
# I made this too clever by half

class BeeminderIntegration
  include ActionView::Helpers::TextHelper
  def initialize(opts={})
    if opts[:goal_integration]
      @goal_integration = opts[:goal_integration]
      @user = @goal_integration.user
      @unit = @goal_integration.unit.to_sym
    else
      @user = opts[:user]
    end
    @client = beeminder_client if @user.beeminder_token.present?
  end

  def beeminder_client
    Beeminder::User.new(@user.beeminder_token)
  end

  def get_goals
    @client.goals
  end

  def goal_titles
    get_goals.map{ |g| g.title }
  end

  def goal_slug(title)
    goal = get_goals.select{ |g| g.title.match(title) }
    raise StandardError, "Does not have a matching goal!" unless goal.first.present?
    goal.first.slug
  end

  def update_goal_integration_strava_activities
    raise StandardError, "Not instantiated with goal integration!" unless @goal_integration.present?
    StravaIntegration.new({goal_integration: @goal_integration}).update_goal_integration_strava_activities
  end

  def set_goal
    @goal = @client.goal "#{goal_slug(@goal_integration.goal_title)}"
  end

  def get_goal_comments
    @goal ||= set_goal
    datapoints = @goal.datapoints
    datapoints.map(&:comment)
  end

  def post_new_activity_to_beeminder
    goal_integration_strava_activities = update_goal_integration_strava_activities
    datapoints = get_goal_comments
    goal_integration_strava_activities.each do |gisa|
      posted = datapoints.select { |d| d.match("#{gisa.strava_activity[:uri]}") }
      next if posted.present?
      point = Beeminder::Datapoint.new(value: gisa.distance_for_integration,
        comment: gisa.strava_activity.message)
      @goal.add point
    end
  end

end