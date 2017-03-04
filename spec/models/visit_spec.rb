require 'rails_helper'

RSpec.describe Visit, type: :model do

  before(:each) do
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "11211", [{'latitude' => 40.7093358, 'longitude' => -73.9565551, 'city' => 'Brooklyn', 'state' => 'New York'}]
    )

    Geocoder::Lookup::Test.add_stub(
      "9131", [{'latitude' => 0, 'longitude' => 0}]
    )

    Geocoder::Lookup::Test.add_stub(
      "654321", [{'latitude' => 0, 'longitude' => 0}]
    )

    Geocoder::Lookup::Test.add_stub(
      "ABC", [{'latitude' => 0, 'longitude' => 0}]
    )

  end


  it "adds city, state, latitude and longitude after validation" do
    expect(FactoryGirl.create(:visit).city).to eq('Brooklyn')
    expect(FactoryGirl.create(:visit).state).to eq('New York')
  end

  it "has a valid factory - valid zip code - 5 digits" do
    expect(FactoryGirl.create(:visit, location: "11211")).to be_valid
  end

  it "is invalid without a zip code - 0 digits" do
    expect { FactoryGirl.create(:visit, location: nil) }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it "is invalid with a start date two days ago" do
    expect do
      FactoryGirl.create(
        :visit,
        start_date: Date.current - 2.day,
        location: "11211"
      )
    end.to raise_error ActiveRecord::RecordInvalid
  end

  it "is valid with a start date of yesterday" do
    expect do
      FactoryGirl.create(
        :visit,
        start_date: Date.current - 1.day,
        location: "11211"
      )
    end
  end

  it "requires an end date after start date" do
    expect do
      FactoryGirl.create(:visit,
                         location: "11211",
                         start_date: Time.zone.today + 5.days,
                         end_date: Time.zone.today)
    end.to raise_error ActiveRecord::RecordInvalid
  end

  it "valid if end date equals start date" do
    expect(FactoryGirl.create(:visit,
                              location: "11211",
                              start_date: Time.zone.now.to_date,
                              end_date: Time.zone.now.to_date)
    ).to be_valid
  end

  it "should be valid if visit's start_date > app start_date" do
    new_time = Time.zone.now + 12.hours
    Timecop.travel(new_time)
    expect(FactoryGirl.create(:visit,
                              location: "11211",
                              start_date: Time.zone.today,
                              end_date: Time.zone.today)
    ).to be_valid
    Timecop.return
  end

  it "is softly deleted" do
    visit = FactoryGirl.create(:visit)
    visit.destroy
    expect(Visit.first).to be_nil
    expect(Visit.with_deleted.first).to eq(visit)
  end
end
