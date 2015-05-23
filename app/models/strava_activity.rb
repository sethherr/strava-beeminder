class StravaActivity < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :strava_id, scope: [:user_id]
  has_many :goal_integration_strava_activities
  has_many :goal_integrations, through: :goal_integration_strava_activities

  def self.create_or_update(u_id, api_data)
    s_id = strava_id_from(api_data)
    activity = self.where(user_id: u_id, strava_id: s_id).first
    if activity.present?
      activity.update_attribute :data, api_data.to_json unless activity.data == api_data.to_json
    else
      self.create(user_id: u_id, strava_id: s_id, data: api_data.to_json)
    end
  end

  def self.strava_id_from(api_data=nil)
    return nil unless api_data.present?
    api_data['id'].to_s
  end

  before_validation :set_strava_id
  def set_strava_id
    self.strava_id ||= self.class.strava_id_from(data)
    true
  end

  def self.matching_activity_type(activity_type)
    where("data ->> 'type' = ?", activity_type)
  end

  def self.known_units
    {
      miles: 0.000621371192237334,
      kilometers: 0.001,
      feet: 3.2808333333
    }
  end

  def distance_in_m
    data['distance']
  end

  def distance(u)
    distance_in_m * (self.class.known_units[u.to_sym])
  end

  def distance_round(unit)
    distance(unit).round(1)
  end


  def name
    data['name']
  end

  def url
    "strava.com/activities/#{strava_id}"
  end

  def activity_time
    Time.parse(data['start_date'])
  end

  def message 
    "#{name} #{url}"
  end

end
