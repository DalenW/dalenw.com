class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :turbo_frame_request_variant

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def ag_grid_json(collection, query)
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
        filter_query = filter[:filter] # the value
        filter_type = filter[:filterType].to_s # text, number, etc
        filter_comparison = filter[:type].to_s

        unless filter[:filter].present?
          puts "No filter value for field: #{field}"
          next
        end
        unless columns.include? field.to_s
          puts "Unknown column: #{field}"
          next
        end

        # example filter:
        # {filterType: "text", type: "contains", filter: "some"}

        supported_filter_types = %w[text number]

        next unless supported_filter_types.include? filter_type

        column = ActiveRecord::Base.connection.quote_column_name(field)

        case filter_type
        when "text"
          filter_query = filter_query.to_s
          case filter_comparison
          when "contains"
            collection = collection.where("#{column} ILIKE ?", "%#{filter_query}%")
          when "notContains"
            collection = collection.where.not("#{column} ILIKE ?", "%#{filter_query}%")
          when "equals"
            collection = collection.where("#{column} = ?", filter_query)
          when "notEqual"
            collection = collection.where.not("#{column} = ?", filter_query)
          when "startsWith"
            collection = collection.where("#{column} ILIKE ?", "#{filter_query}%")
          when "endsWith"
            collection = collection.where("#{column} ILIKE ?", "%#{filter_query}")
          when "blank"
            collection = collection.where("#{column} = ?", "")
          when "notBlank"
            collection = collection.where.not("#{column} = ?", "")
          else
            puts "Unknown filter type: #{filter[:type]}"
          end
        when "number"
          filter_query = filter_query.to_i

          case filter_comparison
          when "equals"
            collection = collection.where("#{column} = ?", filter_query)
          when "greaterThan"
            collection = collection.where("#{column} > ?", filter_query)
          when "greaterThanOrEqual"
            collection = collection.where("#{column} >= ?", filter_query)
          when "lessThan"
            collection = collection.where("#{column} < ?", filter_query)
          when "lessThanOrEqual"
            collection = collection.where("#{column} <= ?", filter_query)
          when "inRange"
            range_start = filter_query
            range_end = filter[:filterTo].to_i

            collection = collection.where("#{column} BETWEEN ? AND ?", range_start, range_end)
          when "blank"
            collection = collection.where("#{column} = ?", nil)
          when "notBlank"
            collection = collection.where.not("#{column} = ?", nil)
          else
            puts "Unknown filter type: #{filter[:type]}"
          end
        else
          puts "Unknown filter type: #{filter_type}"
        end
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
