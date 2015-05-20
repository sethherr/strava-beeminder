class StravaActivity < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :strava_id, scope: [:user_id]

  def self.create_or_update(u_id, api_data)
    s_id = strava_id_from(api_data)
    activity = self.where(user_id: u_id, strava_id: s_id)
    if activity.present?
      activity.update_attribute :data, api_data.to_json unless data == api_data.to_json
    else
      self.create(user_id: u_id, strava_id: s_id, data: api_data.to_json)
    end
  end

  def self.strava_id_from(api_data)
    api_data['id'].to_s
  end

  def self.matching_activity_type(activity_type)
    where("data ->> 'type' = ?", activity_type)
  end

  def output_format
    {
      id: strava_id,
      distance_in_m: data['distance'],
      time: activity_time.to_i,
      name: data['name'],
      uri: "strava.com/activities/#{strava_id}"
    }
  end

  def activity_time
    Time.parse(data['start_date'])
  end

end
