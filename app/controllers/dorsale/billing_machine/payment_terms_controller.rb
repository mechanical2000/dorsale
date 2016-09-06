module Dorsale
  module BillingMachine
    class PaymentTermsController < ::Dorsale::BillingMachine::ApplicationController
      def index
        authorize! :list, PaymentTerm
        @payment_terms ||= ::Dorsale::BillingMachine::PaymentTerm.all
      end

      def new
        @payment_term = ::Dorsale::BillingMachine::PaymentTerm.new
        authorize! :create, @payment_term
      end

      def create
        @payment_term ||= ::Dorsale::BillingMachine::PaymentTerm.new(payment_term_params)
        authorize! :create, @payment_term
        if @payment_term.save
          flash[:notice] = t("payment_terms.create_ok")
          redirect_to billing_machine_payment_terms_path
        else
          render action: "new"
        end
      end

      def edit
        @payment_term = ::Dorsale::BillingMachine::PaymentTerm.find(params[:id])
        authorize! :update, @payment_term
      end

      def update
        @payment_term = ::Dorsale::BillingMachine::PaymentTerm.find(params[:id])
        authorize! :update, @payment_term
        if @payment_term.update_attributes(payment_term_params)
          flash[:notice] = t("payment_terms.update_ok")
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

      def payment_term_params
        params.require(:billing_machine_payment_term).permit(permitted_params)
      end
    end
  end
end
