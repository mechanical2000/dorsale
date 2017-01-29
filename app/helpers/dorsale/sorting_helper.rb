module Dorsale::SortingHelper
  def sortable_column(name, column)
    unless column.is_a?(Symbol)
      raise ArgumentError, "invalid column, please use symbol"
    end

    current_column, current_order = sortable_column_order

    if current_column == column.to_s
      if current_order == :asc
        name           = "#{name} ↓"
        new_sort_param = "-#{column}"
      end

      if current_order == :desc
        name           = "#{name} ↑"
        new_sort_param = column
      end

      klass = "sort #{current_order}"
    else
      new_sort_param = column
      klass          = "sort"
    end

    link_to(name, params.merge(sort: new_sort_param), class: klass)
  end

  def sortable_column_order
    sort_param = params[:sort].to_s

    if sort_param.present?
      if sort_param.start_with?("-")
        column = sort_param[1..-1]
        order  = :desc
      else
        column = sort_param
        order  = :asc
      end
    end

    if block_given?
      yield(column, order)
    else
      [column, order]
    end
  end
end
