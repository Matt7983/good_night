require 'rails_helper'

RSpec.describe ClockPrinter, type: :printer do
  subject(:render_hash) { described_class.render_as_hash(clock) }

  let(:clock) { FactoryBot.create(:clock) }

  describe 'fields' do
    it { is_expected.to include(user_id: clock.user_id) }
    it { is_expected.to include(user_name: clock.user_name) }
    it { is_expected.to include(clock_in: clock.clock_in) }
    it { is_expected.to include(clock_out: clock.clock_out) }
    it { is_expected.to include(duration: clock.duration) }
  end
end
