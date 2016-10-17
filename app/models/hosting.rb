class Hosting < ActiveRecord::Base
  enum accomodation_type: [ :home, :hotel ]

  validates :max_guests, presence: true
  validates :zipcode, zipcode: { country_code: :es }
  validates :comment, length: { maximum: 5000 }
  validates :accomodation_type, presence: true

  validates_date :start_date, on: :create, presence: true
  validate :validate_start_date_is_not_in_the_past, if: :start_date
  validates_date :end_date, on: :create, on_or_after: :start_date

  acts_as_paranoid

  belongs_to :host, class_name: "User", foreign_key: :host_id
  has_many :contacts

  after_validation :geocode, :if => lambda{ |obj| obj.zipcode_changed? }

  geocoded_by :zipcode do |hosting, results|
    if geo = results.first
      hosting.city = geo.city
      hosting.state = geo.state
      hosting.latitude = geo.latitude
      hosting.longitude = geo.longitude
    else
      hosting.errors.add(:base, "Unknown Zip Code") unless hosting.zipcode.nil?
    end
  end

  def first_name
    host.first_name
  end

  def was_contacted_for?(visit)
    Contact.exists?(visit_id: visit.id, hosting_id: self.id)
  end

  def validate_start_date_is_not_in_the_past
    # We compare to yesterday because user's "today" may be yesterday in UTC.  But
    # we're OK since datepicker in javascript enforces using the user's time zone.
    errors.add(:start_date, :in_past) unless start_date >= Date.current - 1.day
  end

  def start_and_end_dates
    starting = start_date.strftime("%m/%d/%y")
    ending = end_date.strftime("%m/%d/%y")

    "#{starting} - #{ending}"
  end
end
