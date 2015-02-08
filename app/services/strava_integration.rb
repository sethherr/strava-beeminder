class StravaIntegration
  def self.activity_types
    %w( Ride Run Kitesurf NordicSki Swim RockClimbing Hike RollerSki Walk Rowing 
        AlpineSki Snowboard BackcountrySki Snowshoe Canoeing StairStepper CrossCountrySkiing
        StandUpPaddling Crossfit Surfing Elliptical WeightTraining IceSkate Windsurf
        InlineSkate Workout Kayaking Yoga )
  end

  def self.known_units
    {
      miles: 0.000621371192237334,
      kilometers: 0.001,
      feet: 3.2808333333
    }
  end

  def initialize(opts={})
    if opts[:goal_integration]
      @goal_integration = opts[:goal_integration]
      @user = @goal_integration.user
      @unit = @goal_integration.unit.to_sym
    else
      @user = opts[:user]      
      @unit = opts[:unit] && opts[:unit].to_sym || self.class.known_units.keys.first
    end
    @client = strava_client if @user.strava_token.present?
    @after_i = opts[:start] && opts[:start].to_i || (Time.now.beginning_of_day).to_i
  end

  def strava_client 
    Strava::Api::V3::Client.new(:access_token => @user.strava_token)
  end

  def get_activities
    @client.list_athlete_activities(after: @after_i)
  end

  def activities_matching(activity_type)
    activity_type = activity_type.strip.gsub(/\s/, '_').camelize
    activities = get_activities
    activities.select { |a| a['type'].match(activity_type) }
  end

  def distance(distance_in_m)
    distance_in_m * (self.class.known_units[@unit])
  end

  def goal_integration_format(activities, h={})
    activities.each do |activity| 
      h[activity['id']] = {
        distance: distance(activity['distance']),
        time: Time.parse(activity['start_date']).to_i,
        name: activity['name']
      }
    end
    h
  end

  def activities_for_goal_integration
    raise StandardError, "Not instantiated with goal integration!" unless @goal_integration.present?
    goal_integration_format(activities_matching(@goal_integration.activity_type))
  end

end