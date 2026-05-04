# app/services/property_search_service.rb

class PropertySearchService
  VALID_SORT_COLUMNS = %w[price created_at bedrooms land_size_sqm floor_area_sqm].freeze
  VALID_SORT_DIRECTIONS = %w[asc desc].freeze
  DEFAULT_PER_PAGE = 20
  MAX_PER_PAGE = 100

  def initialize(params = {})
    @params = params
  end

  def call
    scope = Property.all
    scope = apply_status_filter(scope)
    scope = apply_type_filter(scope)
    scope = apply_price_filter(scope)
    scope = apply_bedroom_filter(scope)
    scope = apply_bathroom_filter(scope)
    scope = apply_suburb_filter(scope)
    scope = apply_keyword_search(scope)
    scope = apply_sorting(scope)
    paginate(scope)
  end

  private

  def apply_status_filter(scope)
    # Default to active listings only unless a status is explicitly provided
    status = @params[:status].presence
    if status && Property.statuses.key?(status)
      scope.where(status: status)
    else
      scope.active_listings
    end
  end

  def apply_type_filter(scope)
    type = @params[:property_type].presence
    return scope unless type && Property.property_types.key?(type)

    scope.where(property_type: type)
  end

  def apply_price_filter(scope)
    min = @params[:min_price].presence&.to_f
    max = @params[:max_price].presence&.to_f

    scope = scope.where("price >= ?", min) if min
    scope = scope.where("price <= ?", max) if max
    scope
  end

  def apply_bedroom_filter(scope)
  # support both ?bedrooms=3 and ?min_bedrooms=3
    min = (@params[:min_bedrooms] || @params[:bedrooms]).presence&.to_i
    max = @params[:max_bedrooms].presence&.to_i
    scope = scope.where("bedrooms >= ?", min) if min
    scope = scope.where("bedrooms <= ?", max) if max
    scope
  end 

  def apply_bathroom_filter(scope)
    min = (@params[:min_bathrooms] || @params[:bathrooms]).presence&.to_f
    return scope unless min
    scope.where("bathrooms >= ?", min)
  end

  def apply_suburb_filter(scope)
    suburb = @params[:suburb].presence
    state  = @params[:state].presence

    scope = scope.where("suburb ILIKE ?", "%#{suburb}%") if suburb
    scope = scope.where(state: state.upcase)              if state
    scope
  end

  def apply_keyword_search(scope)
    query = @params[:q].presence
    return scope unless query

    # Uses the GIN full-text index defined in the migration
    scope.where(
      "to_tsvector('english', coalesce(title, '') || ' ' || coalesce(description, '') || ' ' || coalesce(suburb, '')) @@ plainto_tsquery('english', ?)",
      query
    )
  end

  def apply_sorting(scope)
    column    = @params[:sort_by].presence
    direction = @params[:sort_dir].presence&.downcase

    column    = VALID_SORT_COLUMNS.include?(column)    ? column    : "created_at"
    direction = VALID_SORT_DIRECTIONS.include?(direction) ? direction : "desc"

    scope.order("#{column} #{direction}")
  end

  def paginate(scope)
    per_page = [@params[:per_page].presence&.to_i || DEFAULT_PER_PAGE, MAX_PER_PAGE].min
    per_page = DEFAULT_PER_PAGE if per_page < 1
    page     = [@params[:page].presence&.to_i || 1, 1].max

    {
      properties: scope.limit(per_page).offset((page - 1) * per_page),
      meta: {
        total_count:  scope.count,
        page:         page,
        per_page:     per_page,
        total_pages:  (scope.count.to_f / per_page).ceil
      }
    }
  end
end