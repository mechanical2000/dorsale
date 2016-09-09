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

    @invoices ||= model.all
    @filters  ||= ::Dorsale::BillingMachine::SmallData::FilterForInvoices.new(cookies)
    @order    ||= {unique_index: :desc}

    @invoices = @filters.apply(@invoices)
    @invoices = @invoices.order(@order)
    @invoices_without_pagination = @invoices
    @invoices = @invoices.page(params[:page]).per(50)

    @total_excluding_taxes = @invoices_without_pagination.to_a
      .map(&:total_excluding_taxes)
      .delete_if(&:blank?)
      .sum

    @vat_amount = @invoices_without_pagination.to_a
      .map(&:vat_amount)
      .delete_if(&:blank?)
      .sum

    @total_including_taxes = @invoices_without_pagination.to_a
      .map(&:total_including_taxes)
      .delete_if(&:blank?)
      .sum

    respond_to do |format|
      format.csv {
        send_data generate_encoded_csv(@invoices_without_pagination), type: "text/csv"
      }

      format.json {
        respond_with @invoices_without_pagination
      }

      format.html
    end
  end

  def new
    # callback in BillingMachine::ApplicationController
    @invoice ||= model.new
    @invoice.lines.build if @invoice.lines.empty?

    @invoice.id_card = @id_cards.first if @id_cards.one?

    authorize @invoice, :create?
  end

  def create
    # callback in BillingMachine::ApplicationController
    @invoice ||= model.new(invoice_params)

    authorize model, :create?

    if @invoice.save
      flash[:notice] = t("messages.invoices.create_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def show
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :read?

    respond_to do |format|
      format.pdf {
          authorize @invoice, :download?
          pdf_data  = @invoice.pdf.render

          file_name = [
            model.t.capitalize,
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
    # callback in BillingMachine::ApplicationController
    @original = @invoice
    authorize @original, :copy?

    @invoice = @original.dup

    @original.lines.each do |line|
      @invoice.lines << line.dup
    end

    @invoice.date         = Time.zone.now.to_date
    @invoice.due_date     = Time.zone.now.to_date + 30.days
    @invoice.unique_index = nil
    @invoice.paid         = false

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

    if @invoice.update(invoice_params)
      flash[:notice] = t("messages.invoices.update_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def pay
    # callback in BillingMachine::ApplicationController
    authorize @invoice, :update?

    if @invoice.update_attributes(paid: true)
      flash[:notice] = t("messages.invoices.pay_ok")
    else
      flash[:alert] = t("messages.invoices.pay_error")
    end

    redirect_to back_url
  end

  def email
    authorize @invoice, :email?

    @subject =
    begin
      params[:email][:subject]
    rescue
      "#{model.t} #{@invoice.tracking_id} : #{@invoice.label}"
    end

    @body =
    begin
      params[:email][:body]
    rescue
      t("emails.invoices.send_invoice_to_customer",
        :from => current_user.to_s,
        :to   => @invoice.customer.to_s,
      )
    end

    if request.get?
      return
    end

    email = ::Dorsale::BillingMachine::InvoiceMailer
      .send_invoice_to_customer(@invoice, @subject, @body, current_user)

    if email.deliver_later
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
    @invoice = model.find params[:id]
  end

  def permitted_params
    [
      :id_card_id,
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

  def generate_encoded_csv(invoices)
    invoices.to_csv.encode("WINDOWS-1252",
      :crlf_newline => true,
      :invalid      => :replace,
      :undef        => :replace,
      :replace      => "?"
    )
  end

end
