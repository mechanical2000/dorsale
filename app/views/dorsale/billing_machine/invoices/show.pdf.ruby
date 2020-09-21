filename = [
  @invoice.t.capitalize,
  @invoice.tracking_id,
  @invoice.customer.to_s.tr(" ", "_"),
].join("_").concat(".pdf")

response.headers["Content-Disposition"] = %(inline; filename="#{filename}")

@invoice.pdf_file.read
