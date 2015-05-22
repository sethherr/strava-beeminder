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
      @unit = opts[:unit] && opts[:unit].to_sym || self.class.known_units.keys.first
    end
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
    raise StandardError, "Does not have a matching goal!" unless goal.first.present?
    goal.first.slug
  end

  def get_activity
    raise StandardError, "Not instantiated with goal integration!" unless @goal_integration.present?
    strava = StravaIntegration.new({goal_integration: @goal_integration})
    strava.activities_for_goal_integration
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
    activities = get_activity
    datapoints = get_goal_comments
    activities.each do |activity|
      posted = datapoints.select { |d| d.match(activity[:uri]) }
      next if posted.present?
      point = Beeminder::Datapoint.new(value: distance_round(activity[:distance_in_m]),
        comment: activity.message)
      @goal.add point
    end
  end

end