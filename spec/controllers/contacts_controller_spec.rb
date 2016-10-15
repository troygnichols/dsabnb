require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe '#create' do

    let(:user) { FactoryGirl.create(:user, email_confirmed: true) }
    let(:visit_user) { FactoryGirl.create(:user) }

    let(:user_mailer_double) { double('UserMailer', deliver: true, deliver_now: true) }

    before do
      allow(controller).to receive(:current_user).and_return(user)

      stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=11211&language=en&sensor=false").
        to_return(:status => 200, :body => "", :headers => {})

      Geocoder.configure(:lookup => :test)

      Geocoder::Lookup::Test.add_stub(
        '11211', [{'latitude' => 40.7093358, 'longitude' => -73.9565551}]
      )
      Geocoder::Lookup::Test.add_stub(
        '11221', [{'latitude' => 40.6903213, 'longitude' => -73.9271644}]
        )

      stub_request(:post, %r{api.mailgun.net/v3/messages})
        .to_return(status: 200)
    end

    context 'when the visit is within the next 48 hours' do
      let(:hosting) { FactoryGirl.create(:hosting, host_id: user.id) } # needs to be created after Geocoder methods are stubbed

      let(:visit) {  FactoryGirl.create(:visit, user: visit_user, start_date: Time.zone.now.to_date + 1.day) } # start data is within 48 hours

      let(:contact) {  FactoryGirl.create(:contact, hosting_id: hosting.id, visit_id: visit.id) }

      before do
        allow(Contact).to receive(:new).and_return(contact)
      end

      it 'immediately mails the contact info' do
        new_contact_data = {
          visitor: contact.visit.user,
          visit: contact.visit,
          contact: contact
        }

        expect(UserMailer).to receive(:new_contact_immediate).with(hosting, hosting.host, new_contact_data).and_return(user_mailer_double)
        expect(user_mailer_double).to receive(:deliver_now)

        post :create, visit_id: visit.id, hosting_id: hosting.id
      end
    end

    context 'when the visit is not within the next 48 hours' do

      let(:hosting) { FactoryGirl.create(:hosting, host_id: user.id) } # needs to be created after Geocoder methods are stubbed

      let(:visit) {  FactoryGirl.create(:visit, user: visit_user, start_date: Time.zone.now.to_date + 3.days) } # start data is > 48 hours out

      let(:contact) {  FactoryGirl.create(:contact, hosting_id: hosting.id, visit_id: visit.id) }

      before do
        allow(Contact).to receive(:new).and_return(contact)
      end

      it 'does not immediately mail the contact info' do
        new_contact_data = {
          visitor: contact.visit.user,
          visit: contact.visit,
          contact: contact
        }

        expect(UserMailer).to_not receive(:new_contacts_digest).with(hosting, hosting.host, new_contact_data)

        post :create, visit_id: visit.id, hosting_id: hosting.id
      end
    end
  end
end
