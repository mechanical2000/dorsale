pdf = CombinePDF.new
@invoices_without_pagination.each do |invoice|
  pdf << CombinePDF.parse(invoice.pdf_file.read)
end
pdf.to_pdf
