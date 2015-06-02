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
  end

  def after_time
    # Used to be based on the goal integration created date - but we don't need all that
    # ... and we were getting rate limited. This now will work - so long as no-one does more than
    # 200 requests in the last two weeks.
    (Time.now - 1.weeks).to_i
  end

  def get_activities
    opts = {
      access_token: @user.strava_token,
      after: after_time,
      per_page: 200
    }
    response = HTTParty.get("https://www.strava.com/api/v3/athlete/activities", query: opts,
      :headers => { 'Content-Type' => 'application/json' } )
    JSON.parse(response.body)
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