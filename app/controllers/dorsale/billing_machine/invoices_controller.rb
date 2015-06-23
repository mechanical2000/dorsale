module Dorsale
  module BillingMachine
    class InvoicesController < ::Dorsale::BillingMachine::ApplicationController
      before_filter :set_objects, only: [
        :show,
        :edit,
        :update,
        :copy,
        :pay,
      ]

      before_filter :set_form_variables, only: [
        :new,
        :create,
        :edit,
        :update,
        :copy,
      ]

      def index
        authorize! :list, ::Dorsale::BillingMachine::Invoice

        @invoices ||= ::Dorsale::BillingMachine::Invoice.all
        @people   ||= ::CustomerVault::Person.list
        @filters  ||= ::Dorsale::BillingMachine::SmallData::FilterForInvoices.new(cookies)
        @order    ||= {unique_index: :desc}

        @invoices = @filters.apply(@invoices)
        @invoices = @invoices.order(@order)
        @invoices = @invoices.page(params[:page]).per(50)

        respond_to do |format|
          format.csv {
            send_data generate_encoded_csv(@invoices), type: "text/csv"
          }

          format.json {
            respond_with @invoices
          }

          format.html
        end
      end

      def new
        @invoice ||= ::Dorsale::BillingMachine::Invoice.new
        @invoice.lines.build

        @invoice.id_card = @id_cards.first if @id_cards.one?

        authorize! :create, @invoice
      end

      def create
        @invoice ||= ::Dorsale::BillingMachine::Invoice.new(invoice_params)

        authorize! :create, Invoice

        if @invoice.save
          flash[:notice] = t("messages.invoices.create_ok")
          redirect_to dorsale.billing_machine_invoices_path
        else
          ap @invoice.errors
          render :edit
        end
      end

      def show
        authorize! :read, @invoice

        respond_to do |format|
          format.pdf {
              pdf_data  = @invoice.pdf.render

              file_name = [
                ::Dorsale::BillingMachine::Invoice.model_name.human,
                @invoice.tracking_id,
                @invoice.customer.try(:short_name),
              ].join("_").concat(".pdf")

              send_data pdf_data,
                :type        => "application/pdf",
                :filename    => file_name,
                :disposition => "inline"
          }

          format.html
        end
      end

      def copy
        @original = @invoice
        authorize! :read, @original

        @invoice = @original.dup

        @original.lines.each do |line|
          @invoice.lines << line.dup
        end

        @invoice.date         = Date.today
        @invoice.due_date     = Date.today + 30.days
        @invoice.unique_index = nil
        @invoice.paid         = false

        render :new
      end

      def edit
        authorize! :update, @invoice
      end

      def update
        authorize! :update, @invoice

        if @invoice.update(invoice_params)
          flash[:notice] = t("messages.invoices.update_ok")
          redirect_to dorsale.billing_machine_invoices_path
        else
          render :edit
        end
      end

      def pay
        authorize! :update, @invoice

        if @invoice.update_attributes(paid: true)
          flash[:notice] = t("messages.invoices.pay_ok")
        else
          flash[:alert] = t("messages.invoices.pay_error")
        end

        redirect_to dorsale.billing_machine_invoices_path
      end

      private

      def set_objects
        @invoice = ::Dorsale::BillingMachine::Invoice.find params[:id]
      end

      def set_form_variables
        @payment_terms ||= ::Dorsale::BillingMachine::PaymentTerm.all
        @id_cards      ||= ::Dorsale::BillingMachine::IdCard.all
        @people        ||= ::CustomerVault::Person.list
      end

      def permitted_params
        [
          :id_card_id,
          :customer_guid,
          :payment_term_id,
          :label,
          :paid,
          :date,
          :vat_amount,
          :advance,
          :vat_rate,
          :due_date,
          :lines_attributes => [
            :_destroy,
            :id,
            :label,
            :quantity,
            :unit,
            :unit_price,
          ],
        ]
      end

      def invoice_params
        params.require(:invoice).permit(permitted_params)
      end

      def generate_encoded_csv(invoices)
        invoices.to_csv.encode("WINDOWS-1252",
          :crlf_newline => true,
          :invalid      => :replace,
          :undef        => :replace,
          :replace      => "?"
        )
      end

    end
  end
end
