# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks
  validates :original_url, :short_url, presence: true
  validates :original_url, format: { with: URI.regexp }

  scope :latest, -> { order('created_at DESC').limit(10) }

  def self.short_url
    short_path = ('A'..'Z').to_a.sample(5).join

    return short_url if Url.exists?(short_url: short_path)

    short_path
  end
end
