require 'spec_helper'

RSpec.describe StravaActivity, type: :model do
  describe :validations do
    it { should belong_to :user }
    it { should have_many :goal_integrations }
    it { should have_many :goal_integration_strava_activities }
    it { should validate_uniqueness_of(:strava_id).scoped_to(:user_id) }
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

  describe 'convert' do 
    it "converts distance" do 
      strava_activity = StravaActivity.new(data: {distance: 100})
      expect(strava_activity.distance('feet')).to eq(328.08333333)
      expect(strava_activity.distance_round('feet')).to eq(328.1)
    end
  end

end
