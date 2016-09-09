class Dorsale::BillingMachine::PaymentTermsController < ::Dorsale::BillingMachine::ApplicationController
  def index
    authorize model, :list?

    @payment_terms ||= model.all
  end

  def new
    @payment_term = model.new

    authorize @payment_term, :create?
  end

  def create
    @payment_term ||= model.new(payment_term_params)

    authorize @payment_term, :create?
    if @payment_term.save

      flash[:notice] = t("payment_terms.create_ok")
      redirect_to back_url
    else
      render action: "new"
    end
  end

  def edit
    @payment_term = model.find(params[:id])

    authorize @payment_term, :update?
  end

  def update
    @payment_term = model.find(params[:id])

    authorize @payment_term, :update?

    if @payment_term.update_attributes(payment_term_params)
      flash[:notice] = t("payment_terms.update_ok")
      redirect_to back_url
    else
      render action: "edit"
    end
  end

  private

  def model
    ::Dorsale::BillingMachine::PaymentTerm
  end

  def back_url
    url_for(action: :index, id: nil)
  end

  def permitted_params
    [
      :label,
    ]
  end

  def payment_term_params
    params.fetch(:billing_machine_payment_term, {}).permit(permitted_params)
  end

end
