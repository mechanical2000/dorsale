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
          values = line.map do |value|
            if value.is_a?(Integer)
              value
            elsif value.is_a?(Numeric)
              value.to_f # Fix BigDecimal
            elsif value == true || value == false
              I18n.t(value.to_s)
            else
              value.to_s
            end
          end

          sheet.add_row(values)
        end
      end

      p.use_shared_strings = true
    end
  end

end
