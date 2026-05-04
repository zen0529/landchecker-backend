module Api
  module V1
    class SavedSearchesController < ApplicationController
      def index
        searches = current_user.saved_searches
        render json: { saved_searches: searches }
      end

      def create
        search = current_user.saved_searches.create!(saved_search_params)
        render json: { saved_search: search }, status: :created
      end

      def destroy
        search = current_user.saved_searches.find(params[:id])
        search.destroy!
        render json: { message: "Saved search deleted" }, status: :ok
      end

      private

      def saved_search_params
        params.require(:saved_search).permit(:name, filters: {})
      end
    end
  end
end
