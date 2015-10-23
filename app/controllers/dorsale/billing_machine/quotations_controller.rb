module Dorsale
  module BillingMachine
    class QuotationsController < ::Dorsale::BillingMachine::ApplicationController
      before_filter :set_objects, only: [
        :show,
        :edit,
        :update,
        :destroy,
        :copy,
      ]

      def index
        # callback in BillingMachine::ApplicationController
        authorize! :list, ::Dorsale::BillingMachine::Quotation

        @quotations ||= ::Dorsale::BillingMachine::Quotation.all
        @filters    ||= ::Dorsale::BillingMachine::SmallData::FilterForQuotations.new(cookies)
        @order      ||= {unique_index: :desc}

        @quotations = @filters.apply(@quotations)
        @quotations = @quotations.order(@order)
        @quotations_without_pagination = @quotations # All filtered quotations (not paginated)
        @quotations = @quotations.page(params[:page]).per(50)

        respond_to do |format|
          format.csv {
            send_data generate_encoded_csv(@quotations_without_pagination), type: "text/csv"
          }

          format.json {
            respond_with @quotations_without_pagination
          }

          format.html
        end
      end

      def new
        # callback in BillingMachine::ApplicationController
        @quotation ||= ::Dorsale::BillingMachine::Quotation.new

        @quotation.lines.build

        @quotation.id_card = @id_cards.first if @id_cards.one?

        authorize! :create, @quotation
      end

      def create
        # callback in BillingMachine::ApplicationController
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
        # callback in BillingMachine::ApplicationController
        authorize! :read, @quotation

        respond_to do |format|
          format.pdf {
              pdf_data  = @quotation.pdf.render_with_attachments

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
        # callback in BillingMachine::ApplicationController
        authorize! :update, @quotation
      end

      def update
        # callback in BillingMachine::ApplicationController
        authorize! :update, @quotation

        if @quotation.update(quotation_params)
          flash[:notice] = t("messages.quotations.update_ok")
          redirect_to dorsale.billing_machine_quotations_path
        else
          render :edit
        end
      end

      def destroy
        # callback in BillingMachine::ApplicationController
        authorize! :delete, @quotation

        if @quotation.destroy
          flash[:notice] = t("messages.quotations.update_ok")
        else
          flash[:alert] = t("messages.quotations.update_error")
        end

        redirect_to dorsale.billing_machine_quotations_path
      end

      def copy
        authorize! :create, @quotation

        new_quotation = @quotation.create_copy!
        flash[:notice] = t("messages.quotations.copy_ok")

        redirect_to dorsale.edit_billing_machine_quotation_path(new_quotation)
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
          :expires_at,
          :comments,
          :vat_amount,
          :vat_rate,
          :commercial_discount,
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
