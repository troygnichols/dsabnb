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

  describe "Immediate Contact Email" do
    let(:user) { FactoryGirl.create(:user) }

    let(:hosting) { FactoryGirl.create(:hosting, host_id: user.id) } # needs to be created after Geocoder methods are stubbed

    let(:visit_user) { FactoryGirl.create(:user) }
    let(:visit) {  FactoryGirl.create(:visit, user: visit_user, start_date: Time.zone.now.to_date + 1.day, end_date: Time.zone.now.to_date + 4.days) }
    let(:contact) {  FactoryGirl.create(:contact, hosting_id: hosting.id, visit_id: visit.id) }

    let(:contact_data) do
      {
        visitor: contact.visit.user,
        visit: contact.visit,
        contact: contact
      }
    end

    before do
      expect(contact.sent).to be_nil

      stub_request(:post, %r{api.mailgun.net/v3/messages})
        .to_return(status: 200)
    end

    it 'updates the contact as sent' do
      UserMailer.new_contact_immediate(
        contact.hosting,
        contact.hosting.host,
        contact_data
      ).deliver_now

      contact.reload

      expect(contact.sent).to_not be_nil
    end
  end
end

