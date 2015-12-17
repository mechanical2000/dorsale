module Dorsale
  module BillingMachine
    class InvoiceMailer < ::Dorsale::ApplicationMailer
      def send_invoice_to_customer(invoice, subject, body, sender = nil)
        return false if invoice.try(:customer).try(:email).blank?

        attachments["#{Invoice.t}_#{invoice.tracking_id}.pdf"] = invoice.pdf.render

        mail(
          :to       => invoice.customer.email,
          :cc       => sender.try(:email),
          :reply_to => sender.try(:email),
          :subject  => subject,
          :body     => body,
        )
      end
    end
  end
end
