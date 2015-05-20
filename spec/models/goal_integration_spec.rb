require 'spec_helper'

RSpec.describe GoalIntegration, type: :model do
  describe :validations do
    it { should have_many :strava_activities }
    it { should have_many :beeminder_points }
    it { should belong_to :user }
  end

end
