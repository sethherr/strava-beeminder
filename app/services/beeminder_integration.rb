# Rake task in scheduler is run every hour. 
# To set initial datapoints, the goal integrations create controller after save has this:
# BeeminderIntegration.new({goal_integration: @goal_integration, start: (Time.now - 1.years)}).update_activity_for_goal_integration
# 
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
      @unit = opts[:unit] && opts[:unit].to_sym || self.class.known_units.keys.first
    end
    @after_i = opts[:start] && opts[:start].to_i || (Time.now - 1.weeks).to_i
    @client = beeminder_client if @user.beeminder_token.present?
  end

  def beeminder_client
    Beeminder::User.new(@user.beeminder_token)
  end

  def self.known_units
    {
      miles: 0.000621371192237334,
      kilometers: 0.001,
      feet: 3.2808333333
    }
  end

  def distance(distance_in_m)
    distance_in_m * (self.class.known_units[@unit])
  end

  def distance_round(distance_in_m)
    distance(distance_in_m).round(1)
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

  def message_from_strava_output(activity)
    # msg = "#{activity[:name]} (#{@goal_integration.activity_type} #{pluralize(activity[:distance], @unit.to_s)})"
    "#{activity[:name]} #{activity[:uri]}"
  end

  def post_new_activity_to_beeminder
    activities = get_activity
    unposted = activities.keys - @goal_integration.activity_keys
    return true unless unposted.any?
    unposted.each do |k|
      activity = activities[k]
      goal = @client.goal "#{goal_slug(@goal_integration.goal_title)}"
      point = Beeminder::Datapoint.new :value => distance_round(activity[:distance_in_m]), :comment => message_from_strava_output(activity)
      goal.add point
    end
    activities = activities.merge(@goal_integration.matching_activities) if @goal_integration.matching_activities
    update_activity_for_goal_integration(activities)
  end

  def update_activity_for_goal_integration(activity=get_activity)
    @goal_integration.update_attribute :matching_activities, activity
  end

end