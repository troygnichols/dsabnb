require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  before do
    # Cannot create visit objects until this is stubbed out
    # And it must be stubbed out prior to attempting to create the visit
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=11211&language=en&sensor=false").
      to_return(:status => 200, :body => "", :headers => {})

    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      '11211', [{'latitude' => 40.7093358, 'longitude' => -73.9565551}]
    )

    Geocoder::Lookup::Test.add_stub(
      '11221', [{'latitude' => 40.6903213, 'longitude' => -73.9271644}]
    )

  end

  describe "New Contacts Digest Email" do
    let(:user) { FactoryGirl.create(:user) }

    let(:hosting) { FactoryGirl.create(:hosting, host_id: user.id) } # needs to be created after Geocoder methods are stubbed

    let(:visit_user_1) { FactoryGirl.create(:user) }
    let(:visit_1) {  FactoryGirl.create(:visit, user: visit_user_1, start_date: Time.zone.now.to_date + 3.days, end_date: Time.zone.now.to_date + 4.days) }
    let(:contact_1) {  FactoryGirl.create(:contact, hosting_id: hosting.id, visit_id: visit_1.id) }

    let(:visit_user_2) { FactoryGirl.create(:user) }
    let(:visit_2) {  FactoryGirl.create(:visit, user: visit_user_1, start_date: Time.zone.now.to_date + 4.days, end_date: Time.zone.now.to_date + 5.days) }
    let(:contact_2) {  FactoryGirl.create(:contact, hosting_id: hosting.id, visit_id: visit_2.id) }

    before do
      expect(hosting.contacts).to include(contact_1, contact_2)

      stub_request(:post, %r{api.mailgun.net/v3/messages})
        .to_return(status: 200)
    end

    it 'does something' do
      puts "hello"
    end
  end
  end
