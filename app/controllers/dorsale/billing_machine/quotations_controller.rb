class Dorsale::BillingMachine::QuotationsController < ::Dorsale::BillingMachine::ApplicationController
  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :copy,
    :create_invoice,
    :email,
  ]

  def index
    # callback in BillingMachine::ApplicationController
    authorize model, :list?

    @quotations ||= scope.all.preload(:customer)
    @filters    ||= ::Dorsale::BillingMachine::SmallData::FilterForQuotations.new(filters_jar)

    @quotations = @filters.apply(@quotations)
    @quotations_without_pagination = @quotations # All filtered quotations (not paginated)
    @quotations = @quotations.page(params[:page]).per(50)

    @statistics = ::Dorsale::BillingMachine::Invoice::Statistics.new(@quotations_without_pagination)
  end

  def new
    # callback in BillingMachine::ApplicationController
    @quotation ||= scope.new

    @quotation.lines.build if @quotation.lines.empty?

    authorize @quotation, :create?
  end

  def create
    # callback in BillingMachine::ApplicationController
    @quotation ||= scope.new(quotation_params_for_create)

    authorize @quotation, :create?

    if @quotation.save
      Dorsale::BillingMachine::PdfFileGenerator.(@quotation)
      flash[:notice] = t("messages.quotations.create_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def show
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :read?
    authorize @quotation, :download? if request.format.pdf?
  end

  def edit
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :update?
    if ::Dorsale::BillingMachine.vat_mode == :single
      @quotation.lines.build(vat_rate: @quotation.vat_rate) if @quotation.lines.empty?
    else
      @quotation.lines.build if @quotation.lines.empty?
    end
  end

  def update
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :update?

    if @quotation.update(quotation_params_for_update)
      Dorsale::BillingMachine::PdfFileGenerator.(@quotation)
      flash[:notice] = t("messages.quotations.update_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def destroy
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :delete?

    if @quotation.destroy
      flash[:notice] = t("messages.quotations.update_ok")
    else
      flash[:alert] = t("messages.quotations.update_error")
    end

    redirect_to url_for(action: :index, id: nil)
  end

  def copy
    authorize @quotation, :copy?

    @original  = @quotation
    @quotation = Dorsale::BillingMachine::Quotation::Copy.(@original)

    flash[:notice] = t("messages.quotations.copy_ok")

    redirect_to dorsale.edit_billing_machine_quotation_path(@quotation)
  end

  def create_invoice
    authorize @quotation, :create_invoice?

    @invoice = Dorsale::BillingMachine::Quotation::ToInvoice.(@quotation)

    render "dorsale/billing_machine/invoices/new"
  end

  def email
    authorize @quotation, :email?

    @email = Dorsale::BillingMachine::Email.new(@quotation, email_params)

    return if request.get?

    if @email.save
      flash[:notice] = t("messages.quotations.email_ok")
      redirect_to back_url
    else
      flash.now[:alert] = t("messages.quotations.email_error")
      render
    end
  end

  private

  def model
    ::Dorsale::BillingMachine::Quotation
  end

  def default_back_url
    if @quotation
      url_for(action: :show, id: @quotation.to_param)
    else
      url_for(action: :index, id: nil)
    end
  end

  def set_objects
    @quotation ||= scope.find(params[:id])
  end

  def permitted_params
    [
      :label,
      :state,
      :customer_guid,
      :payment_term_id,
      :date,
      :expires_at,
      :comments,
      :vat_rate,
      :commercial_discount,
      :lines_attributes => [
        :_destroy,
        :id,
        :label,
        :quantity,
        :unit,
        :unit_price,
        :vat_rate,
      ],
    ]
  end

  def quotation_params
    params.fetch(:quotation, {}).permit(permitted_params)
  end

  def quotation_params_for_create
    quotation_params
  end

  def quotation_params_for_update
    quotation_params
  end
end
