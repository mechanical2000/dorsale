module Dorsale
  module BillingMachine
    class QuotationsController < ::Dorsale::BillingMachine::ApplicationController
      before_filter :set_objects, only: [
        :show,
        :edit,
        :update,
        :destroy,
      ]

      def index
        authorize! :list, ::Dorsale::BillingMachine::Quotation

        @quotations ||= ::Dorsale::BillingMachine::Quotation.all
        @people     ||= ::Dorsale::CustomerVault::Person.list
        @filters    ||= ::Dorsale::BillingMachine::SmallData::FilterForQuotations.new(cookies)
        @order      ||= {unique_index: :desc}

        @quotations = @filters.apply(@quotations)
        @quotations = @quotations.order(@order)
        @quotations = @quotations.page(params[:page]).per(50)

        respond_to do |format|
          format.csv {
            send_data generate_encoded_csv(@quotations), type: "text/csv"
          }

          format.json {
            respond_with @quotations
          }

          format.html
        end
      end

      def new
        @quotation ||= ::Dorsale::BillingMachine::Quotation.new

        @quotation.lines.build

        @quotation.id_card = @id_cards.first if @id_cards.one?

        authorize! :create, @quotation
      end

      def create
        @quotation ||= ::Dorsale::BillingMachine::Quotation.new(quotation_params)

        authorize! :create, @quotation

        if @quotation.save
          flash[:notice] = t("messages.quotations.create_ok")
          redirect_to dorsale.billing_machine_quotations_path
        else
          ap @quotation.errors
          render :edit
        end
      end

      def show
        authorize! :read, @quotation

        respond_to do |format|
          format.pdf {
              pdf_data  = @quotation.pdf.render

              file_name = [
                ::Dorsale::BillingMachine::Quotation.t,
                @quotation.tracking_id,
                @quotation.customer.try(:short_name),
              ].join("_").concat(".pdf")

              send_data pdf_data,
                :type        => "application/pdf",
                :filename    => file_name,
                :disposition => "inline"
          }

          format.html
        end
      end

      def edit
        authorize! :update, Quotation
      end

      def update
        authorize! :update, @quotation

        if @quotation.update(quotation_params)
          flash[:notice] = t("messages.quotations.update_ok")
          redirect_to dorsale.billing_machine_quotations_path
        else
          render :edit
        end
      end

      def destroy
        authorize! :delete, @quotation

        if @quotation.destroy
          flash[:notice] = t("messages.quotations.update_ok")
        else
          flash[:alert] = t("messages.quotations.update_error")
        end

        redirect_to dorsale.billing_machine_quotations_path
      end

      private

      def set_objects
        @quotation = ::Dorsale::BillingMachine::Quotation.find params[:id]
      end

      def permitted_params
        [
          :label,
          :customer_guid,
          :payment_term_id,
          :id_card_id,
          :date,
          :comments,
          :vat_amount,
          :vat_rate,
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

      def quotation_params
        params.require(:quotation).permit(permitted_params)
      end

    end
  end
end
