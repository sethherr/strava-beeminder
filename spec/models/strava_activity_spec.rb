require 'spec_helper'

RSpec.describe StravaActivity, type: :model do
  describe :validations do
    it { should belong_to :user }
    it { should validate_uniqueness_of :strava_id }
  end

  describe :message do 
    it "formats message correctly" do 
      user = FactoryGirl.create(:user)
      activity_json = {id: 42, name: 'Cool name'}.to_json
      strava_activity = StravaActivity.create(user_id: user.id, data: activity_json)
      expect(strava_activity.message).to eq("Cool name strava.com/activities/42")
    end
  end

  describe :seet_strava_id do 
    it "sets strava id" do 
      strava_activity = StravaActivity.new(data: {id: 42}.to_json)
      strava_activity.set_strava_id 
      expect(strava_activity.strava_id).to eq('42')
    end
  end

end
