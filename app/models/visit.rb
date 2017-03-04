class Visit < ActiveRecord::Base
  attr_accessor :skip_geocode

  validates_date :start_date, on: :create, presence: true
  validate :validate_start_date_is_not_in_the_past, if: :start_date
  validates :location, presence: true

  validates_date :end_date, on: :create, on_or_after: :start_date

  belongs_to :user
  has_many :contacts

  after_validation :geocode, unless: ->(visit) {
    visit.skip_geocode
  }

  geocoded_by :location do |visit, results|
    if geo = results.first
      visit.city = geo.city
      visit.state = geo.state
      visit.latitude = geo.latitude
      visit.longitude = geo.longitude
      visit.postal_code = geo.postal_code
    else
      visit.errors.add(:base, "Unknown location") unless visit.location.blank?
    end
  end

  def has_geo_data?
    geocoded? && attributes.values_at("city", "state", "postal_code").all?(&:present?)
  end

  acts_as_paranoid

  def validate_start_date_is_not_in_the_past
    # We compare to yesterday because user's "today" may be yesterday in UTC.  But
    # we're OK since datepicker in javascript enforces using the user's time zone.
    errors.add(:start_date, :in_past) unless start_date >= Date.current - 1.day
  end

  def available_hostings(current_user)
    available_hostings = Hosting
      .near(self, 75, order: 'distance')
      .where("start_date <= ?", self.end_date)
      .where("end_date >= ?", self.start_date)

    if Rails.env.production? or Rails.env.staging?
      # :nocov:
      return available_hostings.where("host_id != (?)", self.user_id)
      # :nocov:
    else
      return available_hostings
    end
  end

  def start_and_end_dates
    starting = start_date.strftime("%m/%d/%y")
    ending = end_date.strftime("%m/%d/%y")

    "#{starting} - #{ending}"
  end
end
