require "axlsx"

class Dorsale::Serializers::XLSX < Dorsale::Serializers::Base
  def render_inline
    xlsx.to_stream.read.force_encoding("BINARY")
  end

  def render_file(file_path)
    xlsx.serialize(file_path)
  end

  def xlsx
    @xlsx ||= Axlsx::Package.new do |p|
      p.workbook.add_worksheet do |sheet|
        data.each do |line|
          types = [:string] * line.length
          sheet.add_row(line, types: types)
        end
      end

      p.use_shared_strings = true
    end
  end

end
