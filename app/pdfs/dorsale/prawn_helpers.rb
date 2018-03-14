require "prawn"
require "prawn/measurement_extensions"

module Dorsale::PrawnHelpers
  include Dorsale::AllHelpers
  include ActionView::Helpers::NumberHelper

  def draw_debug_bounds?
    false
  end

  def draw_debug_bounds!
    transparent(0.5) { stroke_bounds } if draw_debug_bounds?
  end

  def t(*args)
    I18n.t(*args)
  end

  def page_height
    page.dimensions[3]
  end

  def page_width
    page.dimensions[2]
  end

  def bb(options = {}, &block)
    outer_box_left   = options.fetch(:left, bounds.left)
    outer_box_top    = options.fetch(:top, bounds.top)
    outer_box_width  = options.fetch(:width, bounds.width)
    outer_box_height = options.fetch(:height, bounds.height)
    padding          = options.fetch(:padding, 0)
    radius           = options.fetch(:radius, 0)
    rectangle        = options.fetch(:rectangle, false)
    background       = options.fetch(:background, false)

    if rectangle
      stroke do
        rounded_rectangle [outer_box_left, outer_box_top], outer_box_width, outer_box_height, radius
      end
    end

    if background
      previous_fill_color = fill_color
      fill_color background
      fill_rounded_rectangle [outer_box_left, outer_box_top], outer_box_width, outer_box_height, radius
      fill_color previous_fill_color
    end

    bounding_box [outer_box_left, outer_box_top], width: outer_box_width, height: outer_box_height do
      draw_debug_bounds!

      inner_box_left   = bounds.left   + padding
      inner_box_top    = bounds.top    - padding
      inner_box_width  = bounds.width  - (padding * 2)
      inner_box_height = bounds.height - (padding * 2)

      bounding_box [inner_box_left, inner_box_top], width: inner_box_width, height: inner_box_height do
        draw_debug_bounds!

        block&.call
      end
    end
  end

  def tb(text, options = {})
    box_left   = options[:left]   || bounds.left
    box_top    = options[:top]    || bounds.top
    box_width  = options[:width]  || bounds.width
    box_height = options[:height] || bounds.height

    options = {
      :at            => [box_left, box_top],
      :width         => box_width,
      :height        => box_height,
      :overflow      => :shrink_to_fit,
      :inline_format => true,
    }.merge(options)

    text_box(text.to_s, options)
  end

  def btb(text, options = {})
    bb(options) do
      tb(text)
    end
  end

  def get_image(obj)
    return if obj.blank?

    if ApplicationUploader.storage.to_s.end_with?("File") # Local
      obj.path
    elsif ApplicationUploader.storage.to_s.end_with?("Fog") # Amazon S3
      URI.parse(obj.url).open
    else
      raise NotImplementedError
    end
  end

  def placeholder(method)
    return unless Rails.env.development?

    "You can override this text in <b>##{method}</b> method, otherwise it will not be displayed in other environments."
  end
end
