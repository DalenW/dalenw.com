class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :turbo_frame_request_variant

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def agGridJson(collection, query)
    # Handle server-side pagination, sorting, and filtering
    # page_size = params[:endRow].to_i - params[:startRow].to_i
    # page = (params[:startRow].to_i / page_size) + 1

    _model = collection.model

    start_row = query[:startRow].to_i
    end_row = query[:endRow].to_i

    page_size = end_row - start_row
    _page = (start_row / page_size) + 1

    sort_model = JSON.parse query[:sortModel].to_s, symbolize_names: true
    filter_model = JSON.parse query[:filterModel].to_s, symbolize_names: true

    columns = collection.select_values
    columns = collection.model.column_names if columns.empty?

    # Handle sorting
    if sort_model.present?
      sort_model.each do |sort|
        direction = sort[:sort] == "asc" ? "ASC" : "DESC"
        column = sort[:colId]

        if columns.include? column
          collection = collection.order("#{column} #{direction}")
        else
          puts "Unknown column: #{column}"
        end
      end
    end

    # Handle filtering
    if filter_model.present?
      filter_model.each do |field, filter|
        next unless filter[:filter].present?
        next unless columns.include? field.to_s

        # example filter:
        # {filterType: "text", type: "contains", filter: "some"}

        next unless filter[:filterType] == "text"

        case filter[:type]
        when "contains"
          collection = collection.where("#{field} ILIKE ?", "%#{filter[:filter]}%")
        when "notContains"
          collection = collection.where.not("#{field} ILIKE ?", "%#{filter[:filter]}%")
        when "equals"
          collection = collection.where("#{field} = ?", filter[:filter])
        when "notEqual"
          collection = collection.where.not("#{field} = ?", filter[:filter])
        when "startsWith"
          collection = collection.where("#{field} ILIKE ?", "#{filter[:filter]}%")
        when "endsWith"
          collection = collection.where("#{field} ILIKE ?", "%#{filter[:filter]}")
        when "blank"
          collection = collection.where("#{field} = ?", "")
        when "notBlank"
          collection = collection.where.not("#{field} = ?", "")
        else
          puts "Unknown filter type: #{filter[:type]}"
        end

        collection = collection.where("#{field} ILIKE ?", "%#{filter[:filter]}%")
      end
    end

    total = collection.size
    results = collection.offset(start_row).limit(page_size)

    render json: {
      rows: results,
      lastRow: total
    }
  end
end
