class Dorsale::BillingMachine::InvoicesController < ::Dorsale::BillingMachine::ApplicationController
  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :copy,
    :pay,
    :email,
  ]

  def index
    # callback in BillingMachine::ApplicationController
    authorize model, :list?

    @invoices ||= scope.all.preload(:customer)
    @filters  ||= ::Dorsale::BillingMachine::SmallData::FilterForInvoices.new(filters_jar)

    @invoices = @filters.apply(@invoices)
    @invoices_without_pagination = @invoices
    @invoices = @invoices.page(params[:page]).per(50)

    @statistics = ::Dorsale::BillingMachine::Invoice::Statistics.new(@invoices_without_pagination)
  end

  def new
    # callback in BillingMachine::ApplicationController
    @invoice ||= scope.new

    @invoice.lines.build if @invoice.lines.empty?

    authorize @invoice, :create?
  end

  def create
    # callback in BillingMachine::ApplicationController
    @invoice ||= scope.new(invoice_params_for_create)

    authorize model, :create?

    if @invoice.save
      Dorsale::BillingMachine::PdfFileGenerator.(@invoice)
      flash[:notice] = t("messages.invoices.create_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def show
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :read?
    authorize @invoice, :download? if request.format.pdf?
  end

  def copy
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :copy?

    @original = @invoice
    @invoice  = Dorsale::BillingMachine::Invoice::Copy.(@original)

    render :new
  end

  def edit
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :update?

    if ::Dorsale::BillingMachine.vat_mode == :single
      @invoice.lines.build(vat_rate: @invoice.vat_rate) if @invoice.lines.empty?
    else
      @invoice.lines.build if @invoice.lines.empty?
    end
  end

  def update
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :update?

    if @invoice.update(invoice_params_for_update)
      Dorsale::BillingMachine::PdfFileGenerator.(@invoice)
      flash[:notice] = t("messages.invoices.update_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def preview
    authorize model, :preview?

    @invoice ||= scope.new(invoice_params_for_preview)
    @invoice.update_totals
    Dorsale::BillingMachine::PdfFileGenerator.(@invoice)

    render :show, formats: :pdf
  end

  def pay
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :update?

    if @invoice.update(paid: true)
      flash[:notice] = t("messages.invoices.pay_ok")
    else
      flash[:alert] = t("messages.invoices.pay_error")
    end

    redirect_to back_url
  end

  def email
    authorize @invoice, :email?

    @email = Dorsale::BillingMachine::Email.new(@invoice, email_params)

    return if request.get?

    if @email.save
      flash[:notice] = t("messages.invoices.email_ok")
      redirect_to back_url
    else
      flash.now[:alert] = t("messages.invoices.email_error")
      render
    end
  end

  private

  def model
    ::Dorsale::BillingMachine::Invoice
  end

  def default_back_url
    if @invoice
      url_for(action: :show, id: @invoice.to_param)
    else
      url_for(action: :index, id: nil)
    end
  end

  def set_objects
    @invoice ||= scope.find(params[:id])
  end

  def permitted_params
    [
      :customer_guid,
      :payment_term_id,
      :label,
      :paid,
      :date,
      :commercial_discount,
      :vat_rate,
      :advance,
      :due_date,
      :comments,
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

  def invoice_params
    params.fetch(:invoice, {}).permit(permitted_params)
  end

  def invoice_params_for_create
    invoice_params
  end

  def invoice_params_for_update
    invoice_params
  end

  def invoice_params_for_preview
    invoice_params
  end
end
