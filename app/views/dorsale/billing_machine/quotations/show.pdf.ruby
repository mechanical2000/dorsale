filename = [
  @quotation.t.capitalize,
  @quotation.tracking_id,
  @quotation.customer.to_s.tr(" ", "_"),
].join("_").concat(".pdf")

response.headers["Content-Disposition"] = %(inline; filename="#{filename}")

@quotation.pdf_file.read
