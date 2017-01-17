pdf = CombinePDF.new
@invoices_without_pagination.each do |invoice|
  pdf << CombinePDF.parse(invoice.to_pdf)
end
pdf.to_pdf