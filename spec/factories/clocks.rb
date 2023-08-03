FactoryBot.define do
  factory :clock do
    user { create(:user) }
    clock_in { Time.zone.now - 8.hours }
    clock_out { Time.zone.now }
    duration { clock_out - clock_in }
  end
end
