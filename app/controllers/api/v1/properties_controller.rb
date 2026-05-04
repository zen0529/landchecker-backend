

module Api
  module V1
    class PropertiesController < ApplicationController
      skip_before_action :authenticate_request!, only: [:index, :show]

      def index
        result = PropertySearchService.new(params).call

        render json: {
          properties: result[:properties],
          meta:       result[:meta]
        }
      end

      def show
        property = Property.find(params[:id])
        render json: { property: property }
      end
    end
  end
end