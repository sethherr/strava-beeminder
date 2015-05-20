require 'spec_helper'

RSpec.describe StravaActivity, type: :model do
  describe :validations do
    it { should belong_to :user }
    it { should validate_uniqueness_of :strava_id }
  end

end
