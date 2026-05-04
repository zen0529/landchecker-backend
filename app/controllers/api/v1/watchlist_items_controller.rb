module Api
  module V1
    class WatchlistItemsController < ApplicationController
      def index
        items = current_user.watchlist_items.includes(:property)
        render json: { watchlist_items: items.as_json(include: :property) }
      end

      def create
        item = current_user.watchlist_items.create!(watchlist_item_params)
        render json: { watchlist_item: item }, status: :created
      end

      def update
        item = current_user.watchlist_items.find(params[:id])
        item.update!(watchlist_item_params)
        render json: { watchlist_item: item }
      end

      def destroy
        item = current_user.watchlist_items.find(params[:id])
        item.destroy!
        render json: { message: "Removed from watchlist" }, status: :ok
      end

      private

      def watchlist_item_params
        params.require(:watchlist_item).permit(:property_id, :notes, :last_seen_price)
      end
    end
  end
end
