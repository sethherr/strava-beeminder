require 'spec_helper'

RSpec.describe User, type: :model do

  describe :validations do
    it { should have_many :goal_integrations }
    it { should have_many :beeminder_points }
    it { should have_many :strava_activities }
  end
  
end