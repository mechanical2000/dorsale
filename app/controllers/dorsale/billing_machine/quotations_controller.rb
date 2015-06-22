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
        # TODO : Déplacer dans modèle
        @quotation          = ::Dorsale::BillingMachine::Quotation.new
        @quotation.date     = Date.today
        @quotation.vat_rate = 20
        @quotation.lines.build

        authorize! :create, @quotation
      end

      def create
        @quotation = ::Dorsale::BillingMachine::Quotation.new(safe_params)

        authorize! :create, @quotation

        if @quotation.save
          save_documents(params)
          flash[:notice] = t("messages.quotations.craete_ok")
          redirect_to dorsale.billing_machine_quotations_path
        else
          render :edit
        end
      end

      def show
        authorize! :read, @quotation

        respond_to do |format|
          format.pdf {
              pdf = @quotation.pdf
              send_data pdf.render, type: 'application/pdf',
              filename: "Devis_#{@quotation.tracking_id}_#{@quotation.customer.try(:short_name).to_s}.pdf", disposition: 'inline'
          }

          format.html
        end
      end


      def edit
        authorize! :update, Quotation
      end

      def update
        authorize! :update, @quotation

        if @quotation.update(safe_params)
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
          :date,
          :payment_term_id,
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
          :documents_attributes => [
            :id,
            :_destroy,
          ],
        ]
      end

      def quotation_params
        params.require(:quotation).permit(permitted_params)
      end

    end
  end
end
