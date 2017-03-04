require 'rails_helper'

# For some reason trying to instrument Geocoder with something like
#
#     expect(Geocoder).to receive(:search)
#
# doesn't work so we stub `Visit#geocode` with a method that raises
# `TestGeocoderException` and expect to see the exception in any case
# we expect the geocoder to be called.
class TestGeocoderException < RuntimeError; end

RSpec.describe VisitsController, type: :controller do
  describe '#create' do
    let(:user) { FactoryGirl.create(:user, email_confirmed: true) }
    let(:valid_params) {
      {
        location:      'new york',
        num_travelers: 1,
        start_date:    '3000-01-01',
        end_date:      '3000-02-01'
      }
    }

    before do
      allow(controller).to receive(:current_user).and_return(user)

      Geocoder.configure(:lookup => :test)

      Geocoder::Lookup::Test.add_stub(
        '11211', [{'latitude' => 40.7093358, 'longitude' => -73.9565551}]
      )
      Geocoder::Lookup::Test.add_stub(
        '11221', [{'latitude' => 40.6903213, 'longitude' => -73.9271644}]
      )
      Geocoder::Lookup::Test.add_stub('00000', [])
    end

    context 'given a valid location without geo data' do
      it 'responds as expected and creates a geocoded visit' do
        expect {
          post :create, visit: valid_params.merge(location: '11211')
          expect(flash.now[:errors]).to be_nil
          expect(response).to redirect_to action: :show, id: assigns(:visit).id
        }.to change {
          Visit.count
        }.by(1)
      end

      it 'geocodes the visit' do
        allow_any_instance_of(Visit).to receive(:geocode)
          .and_raise(TestGeocoderException, "should raise")
        expect {
          post :create, visit: valid_params.merge(location: '11211')
        }.to raise_error(TestGeocoderException),
          "Expected geocoder to be called but it wasn't"
      end
    end

    context 'given valid location and geo data' do
      it 'does not need to geocode' do
        allow_any_instance_of(Visit).to receive(:geocode)
          .and_raise(TestGeocoderException, "should not raise")
        expect {
          post :create, visit: valid_params.merge(
            location:    '75208',
            city:        'Dallas',
            state:       'Texas',
            postal_code: '75208',
            latitude:    '32.7457134',
            longitude:   '-96.8458204')
        }.not_to raise_error(TestGeocoderException),
          "Did not expect geocoder to be called but it was"
      end
    end

    context 'given an invalid location' do
      it 'returns error and does not create a visit' do
        expect {
          post :create, visit: valid_params.merge(location: '00000')
          expect(flash.now[:errors]).to be_present
          expect(response.status).to eq(422)
        }.not_to change {
          Visit.count
        }
      end

      it "calls tries to geocode (but can't)" do
        allow_any_instance_of(Visit).to receive(:geocode)
          .and_raise(TestGeocoderException, "should raise")
        expect {
          post :create, visit: valid_params.merge(location: '00000')
        }.to raise_error(TestGeocoderException),
          "Expected geocoder to be called but it wasn't"
      end
    end

    context 'given a blank location' do
      it 'returns error and does not create a visit' do
        expect {
          post :create, visit: valid_params.merge(location: '')
          expect(flash.now[:errors]).to be_present
          expect(response.status).to eq(422)
        }.not_to change {
          Visit.count
        }
      end
    end
  end
end
