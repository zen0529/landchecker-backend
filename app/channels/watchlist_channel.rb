# class WatchlistChannel < ApplicationCable::Channel
#   def subscribed
#     stream_from "watchlist_#{current_user.id}"
#     transmit({ event: "initial_state", watchlist: current_watchlist })
#   end

#   def unsubscribed
#     stop_all_streams
#   end

#   def request_property_update(data)
#     property_id = data["property_id"].to_i
#     property    = current_user.watchlist_items
#                               .includes(:property)
#                               .find_by(property_id: property_id)
#                               &.property

#     return transmit({ event: "error", message: "Property not found" }) unless property

#     transmit({
#       event:    "property_updated",
#       property: serialize_property(property),
#       changes:  {}
#     })
#   end

#   private

#   def current_watchlist
#     current_user.watchlist_items.includes(:property).map do |item|
#       {
#         watchlist_item_id: item.id,
#         notes:             item.notes,
#         last_seen_price:   item.last_seen_price,
#         property:          serialize_property(item.property)
#       }
#     end
#   end

#   def serialize_property(property)
#     {
#       id:            property.id,
#       title:         property.title,
#       price:         property.price,
#       status:        property.status,
#       suburb:        property.suburb,
#       state:         property.state,
#       bedrooms:      property.bedrooms,
#       bathrooms:     property.bathrooms,
#       property_type: property.property_type,
#       images:        property.images
#     }
#   end
# end


class WatchlistChannel < ApplicationCable::Channel
  def subscribed
    stream_from "watchlist_#{current_user.id}"
    transmit({ event: "initial_state", watchlist: current_watchlist })
  end

  def unsubscribed
    stop_all_streams
  end

  def request_property_update(data)
    property_id = data["property_id"].to_i
    property    = current_user.watchlist_items
                              .includes(:property)
                              .find_by(property_id: property_id)
                              &.property

    return transmit({ event: "error", message: "Property not found" }) unless property

    transmit({
      event:    "property_updated",
      property: serialize_property(property),
      changes:  {}
    })
  end

  private

  def current_watchlist
    current_user.watchlist_items.includes(:property).map do |item|
      {
        watchlist_item_id: item.id,
        notes:             item.notes,
        last_seen_price:   item.last_seen_price,
        property:          serialize_property(item.property)
      }
    end
  end

  def serialize_property(property)
    {
      id:            property.id,
      title:         property.title,
      price:         property.price,
      status:        property.status,
      suburb:        property.suburb,
      state:         property.state,
      bedrooms:      property.bedrooms,
      bathrooms:     property.bathrooms,
      property_type: property.property_type,
      images:        property.images
    }
  end
end