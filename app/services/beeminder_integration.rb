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
    @after_i = opts[:start] && opts[:start].to_i || (Time.now.beginning_of_day).to_i
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
    goal.first.slug
  end


  def get_activity
    raise StandardError, "Not instantiated with goal integration!" unless @goal_integration.present?
    strava = StravaIntegration.new({goal_integration: @goal_integration, start: @after_i})
    strava.activities_for_goal_integration
  end

  def post_new_activity_to_beeminder
    activities = get_activity
    unposted = activities.keys - @goal_integration.activity_keys
    return true unless unposted.any?
    unposted.each do |k|
      activity = activities[k]
      goal = @client.goal "#{goal_slug(@goal_integration.goal_title)}"
      # msg = "#{activity[:name]} (#{@goal_integration.activity_type} #{pluralize(activity[:distance], @unit.to_s)})"
      msg = "#{activity[:name]} (#{pluralize(activity[:distance], @unit.to_s)})"
      point = Beeminder::Datapoint.new :value => activity[:distance], :comment => msg
      goal.add point
    end
  end

  def update_activity_for_goal_integration(activity=get_activity)
    @goal_integration.update_attribute :matching_activities, activity
  end

end