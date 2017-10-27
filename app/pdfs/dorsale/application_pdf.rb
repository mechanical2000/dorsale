require "prawn"
require "prawn/table"
require "prawn/measurement_extensions"

class Dorsale::ApplicationPdf < Prawn::Document
  include ::Dorsale::PrawnHelpers
end
