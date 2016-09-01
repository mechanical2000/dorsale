module Dorsale
  module BillingMachine
    class PaymentTermsController < ::Dorsale::BillingMachine::ApplicationController
      def index
        authorize! :index, PaymentTerm
        @paymentterms ||= ::Dorsale::BillingMachine::PaymentTerm.all
      end

      def new
        @paymentterm = ::Dorsale::BillingMachine::PaymentTerm.new
        authorize! :create, PaymentTerm
      end

      def create
        @paymentterm = ::Dorsale::BillingMachine::PaymentTerm.new(paymentterm_params)
        authorize! :create, PaymentTerm
        if @paymentterm.save
          flash[:notice] = "Payment Term successfully added"
          redirect_to billing_machine_payment_terms_path
        else
          render action: "new"
        end
      end

      def edit
        @paymentterm = ::Dorsale::BillingMachine::PaymentTerm.find(params[:id])
        authorize! :update, PaymentTerm
      end

      def update
        @paymentterm = ::Dorsale::BillingMachine::PaymentTerm.find(params[:id])
        authorize! :update, PaymentTerm
        if @paymentterm.update_attributes(paymentterm_params)
          flash[:notice] = "Payment Term successfully updated"
          redirect_to billing_machine_payment_terms_path
        else
          render action: "edit"
        end
      end

      private

      def permitted_params
        [
          :label,
        ]
      end

      def paymentterm_params
        params.require(:billing_machine_payment_term).permit(permitted_params)
      end
    end
  end
end