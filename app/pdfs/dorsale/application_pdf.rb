require "prawn"
require "prawn/table"
require "prawn/measurement_extensions"

class Dorsale::ApplicationPdf < Prawn::Document
  include Dorsale::PrawnHelpers
  include Dorsale::Alexandrie::Prawn::RenderWithAttachments

  # Pour le dev
  def open!
    build
    f = Tempfile.new(%w(pdf pdf))
    f.binmode
    f.write(render_with_attachments)
    Launchy.open(f.path)
  end
end
