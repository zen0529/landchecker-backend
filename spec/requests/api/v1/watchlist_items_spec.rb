require 'rails_helper'

RSpec.describe "Api::V1::WatchlistItems", type: :request do
  let(:user) { create(:user) }
  let(:property) { create(:property) }
  let!(:watchlist_items) { create_list(:watchlist_item, 3, user: user) }
  let(:watchlist_item_id) { watchlist_items.first.id }
  let(:headers) { authenticated_headers(user) }

  describe "GET /api/v1/watchlist_items" do
    context "when authenticated" do
      before { get "/api/v1/watchlist_items", headers: headers }

      it "returns watchlist items" do
        expect(json).not_to be_empty
        expect(json['watchlist_items'].size).to eq(3)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when not authenticated" do
      before { get "/api/v1/watchlist_items" }

      it "returns status code 401" do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "POST /api/v1/watchlist_items" do
    let(:valid_attributes) { { watchlist_item: { property_id: property.id, notes: "Nice house" } } }

    context "when authenticated" do
      context "with valid attributes" do
        before { post "/api/v1/watchlist_items", params: valid_attributes, headers: headers }

        it "creates a watchlist item" do
          expect(json['watchlist_item']['property_id']).to eq(property.id)
          expect(json['watchlist_item']['notes']).to eq("Nice house")
        end

        it "returns status code 201" do
          expect(response).to have_http_status(201)
        end
      end
    end
  end

  describe "PATCH /api/v1/watchlist_items/:id" do
    let(:valid_attributes) { { watchlist_item: { notes: "Updated notes" } } }

    context "when authenticated" do
      before { patch "/api/v1/watchlist_items/#{watchlist_item_id}", params: valid_attributes, headers: headers }

      it "updates the record" do
        expect(json['watchlist_item']['notes']).to eq("Updated notes")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /api/v1/watchlist_items/:id" do
    context "when authenticated" do
      before { delete "/api/v1/watchlist_items/#{watchlist_item_id}", headers: headers }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
      
      it "removes the record" do
        expect(WatchlistItem.exists?(watchlist_item_id)).to be false
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end
