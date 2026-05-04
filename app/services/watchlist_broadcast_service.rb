# app/services/watchlist_broadcast_service.rb

class WatchlistBroadcastService
  # Call this after a property is updated (e.g. from an admin action or price change job)
  #
  # Usage:
  #   WatchlistBroadcastService.call(property)
  #   WatchlistBroadcastService.call(property, changed_fields: [:price, :status])

  def self.call(property, changed_fields: nil)
    new(property, changed_fields: changed_fields).call
  end

  def initialize(property, changed_fields: nil)
    @property       = property
    @changed_fields = changed_fields || detect_changes
  end

  def call
    return if @changed_fields.empty?

    watchlist_items.find_each do |item|
      update_last_seen_price(item)
      broadcast_to_user(item)
    end
  end

  private

  # All watchlist items for this property, eager-loading the owner
  def watchlist_items
    @property.watchlist_items.includes(:user)
  end

  # If the caller didn't specify which fields changed, infer from ActiveRecord dirty tracking
  def detect_changes
    relevant = %i[price status]
    relevant.select { |field| @property.saved_change_to_attribute?(field) }
  end

  def update_last_seen_price(item)
    return unless @changed_fields.include?(:price) || @changed_fields.include?("price")

    item.update_columns(
      last_seen_price: @property.price,
      notified_at:     Time.current
    )
  end

  def broadcast_to_user(item)
    ActionCable.server.broadcast(
      "watchlist_#{item.user_id}",
      build_payload(item)
    )
  end

  def build_payload(item)
    {
      event:    "property_updated",
      property: serialize_property,
      changes:  build_changes(item)
    }
  end

  def serialize_property
    {
      id:            @property.id,
      title:         @property.title,
      price:         @property.price,
      status:        @property.status,
      suburb:        @property.suburb,
      state:         @property.state,
      bedrooms:      @property.bedrooms,
      bathrooms:     @property.bathrooms,
      property_type: @property.property_type,
      images:        @property.images
    }
  end

  def build_changes(item)
    changes = {}

    if price_changed?
      changes[:price] = {
        from: item.last_seen_price,
        to:   @property.price,
        diff: price_diff(item.last_seen_price)
      }
    end

    if status_changed?
      prev, curr = @property.saved_change_to_status
      changes[:status] = { from: prev, to: curr }
    end

    changes
  end

  def price_changed?
    @changed_fields.include?(:price) || @changed_fields.include?("price")
  end

  def status_changed?
    @changed_fields.include?(:status) || @changed_fields.include?("status")
  end

  def price_diff(last_seen)
    return nil unless last_seen && @property.price
    @property.price - last_seen
  end
end