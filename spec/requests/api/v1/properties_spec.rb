require 'rails_helper'

RSpec.describe "Api::V1::Properties", type: :request do
  let!(:properties) { create_list(:property, 5) }
  let(:property_id) { properties.first.id }

  describe "GET /api/v1/properties" do
    before { get "/api/v1/properties" }

    it "returns properties" do
      expect(json).not_to be_empty
      expect(json['properties'].size).to eq(5)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
    
    it "includes meta information" do
      expect(json['meta']).to have_key('total_count')
    end
  end

  describe "GET /api/v1/properties/:id" do
    before { get "/api/v1/properties/#{property_id}" }

    context "when the record exists" do
      it "returns the property" do
        expect(json).not_to be_empty
        expect(json['property']['id']).to eq(property_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the record does not exist" do
      let(:property_id) { 100 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Property/)
      end
    end
  end
  
  # Helper method to parse JSON response
  def json
    JSON.parse(response.body)
  end
end
