class Dorsale::BillingMachine::InvoiceMailer < ::Dorsale::ApplicationMailer
  def send_invoice_to_customer(invoice, subject, body, sender = nil)
    attachments["#{invoice.t}_#{invoice.tracking_id}.pdf"] = invoice.pdf_file.read

    mail(
      :to       => invoice.customer.email,
      :cc       => sender.email,
      :reply_to => sender.email,
      :subject  => subject,
      :body     => body,
    )
  end

end
