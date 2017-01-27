module Dorsale::BillingMachine::QuotationPdfCommonMethods
  def build_bank_informations
  end

  def build_expiry
    return if main_document.expires_at.nil?

    top    = bounds.top - 11.5.cm
    height = 0.5.cm
    width  = 7.5.cm

    bounding_box [bounds.left, top], height: height, width: width do
      draw_bounds_debug
      text "<b>#{main_document.t(:expires_at)}</b> #{I18n.l(main_document.expires_at)}", inline_format: true, size: 9
    end
  end
end
