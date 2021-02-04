FactoryBot.define do
  factory :url do
    short_url { ('A'..'Z').to_a.sample(5).join }
    original_url { 'http://foo.bar/zoo' }
  end
end
