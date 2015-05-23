class StravaIntegration
  def self.activity_types
    %w( Ride Run Kitesurf NordicSki Swim RockClimbing Hike RollerSki Walk Rowing 
        AlpineSki Snowboard BackcountrySki Snowshoe Canoeing StairStepper CrossCountrySkiing
        StandUpPaddling Crossfit Surfing Elliptical WeightTraining IceSkate Windsurf
        InlineSkate Workout Kayaking Yoga )
  end

  def initialize(opts={})
    if opts[:goal_integration]
      @goal_integration = opts[:goal_integration]
      @user = @goal_integration.user
    else
      @user = opts[:user]      
    end
    @client = strava_client if @user.strava_token.present?
    @after_i = @goal_integration && @goal_integration.created_at.to_i || (Time.now - 1.weeks).to_i
  end

  def strava_client 
    Strava::Api::V3::Client.new(:access_token => @user.strava_token)
  end

  def get_activities
    @client.list_athlete_activities(after: @after_i)
  end

  def store_activities
    get_activities.each { |a| StravaActivity.create_or_update(@user.id, a) }
  end

  def activities_matching(activity_type)
    activity_type = activity_type.strip.gsub(/\s/, '_').camelize
    store_activities
    @user.reload
    @user.strava_activities.matching_activity_type(activity_type)
  end

  def update_goal_integration_strava_activities
    raise StandardError, "Not instantiated with goal integration!" unless @goal_integration.present?
    activities_matching(@goal_integration.activity_type).
      each { |a| GoalIntegrationStravaActivity.create_from(@goal_integration, a)}
    @goal_integration.reload
    @goal_integration.goal_integration_strava_activities
  end

end