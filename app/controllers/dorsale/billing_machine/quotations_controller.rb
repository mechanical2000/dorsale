class Dorsale::BillingMachine::QuotationsController < ::Dorsale::BillingMachine::ApplicationController
  before_action :set_objects, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :copy,
    :create_invoice,
  ]

  def index
    # callback in BillingMachine::ApplicationController
    authorize model, :list?

    @quotations ||= scope.all
    @filters    ||= ::Dorsale::BillingMachine::SmallData::FilterForQuotations.new(cookies)
    @order      ||= {unique_index: :desc}

    @quotations = @filters.apply(@quotations)
    @quotations = @quotations.order(@order)
    @quotations_without_pagination = @quotations # All filtered quotations (not paginated)
    @quotations = @quotations.page(params[:page]).per(50)

    @total_excluding_taxes = @quotations_without_pagination.to_a
      .select{ |q| q.state != "canceled" }
      .map(&:total_excluding_taxes)
      .delete_if(&:blank?)
      .sum

    @vat_amount = @quotations_without_pagination.to_a
      .select{ |q| q.state != "canceled" }
      .map(&:vat_amount)
      .delete_if(&:blank?)
      .sum

    @total_including_taxes = @quotations_without_pagination.to_a
      .select{ |q| q.state != "canceled" }
      .map(&:total_including_taxes)
      .delete_if(&:blank?)
      .sum

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
    @quotation ||= scope.new

    @quotation.lines.build               if @quotation.lines.empty?
    @quotation.id_card = @id_cards.first if @id_cards.one?

    authorize @quotation, :create?
  end

  def create
    # callback in BillingMachine::ApplicationController
    @quotation ||= scope.new(quotation_params)

    authorize @quotation, :create?

    if @quotation.save
      flash[:notice] = t("messages.quotations.create_ok")
      redirect_to default_back_url
    else
      render :edit
    end
  end

  def show
    # callback in BillingMachine::ApplicationController
    authorize @quotation, :read?

    respond_to do |format|
      format.pdf {
          authorize @quotation, :download?
          pdf_data  = @quotation.pdf.render_with_attachments

          file_name = [
            model.t,
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

    if @quotation.update(quotation_params)
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

    new_quotation = @quotation.create_copy!
    flash[:notice] = t("messages.quotations.copy_ok")

    redirect_to dorsale.edit_billing_machine_quotation_path(new_quotation)
  end

  def create_invoice
    authorize @quotation, :read?
    authorize ::Dorsale::BillingMachine::Invoice, :create?

    @invoice = @quotation.to_new_invoice

    render "dorsale/billing_machine/invoices/new"
  end

  private

  def model
    ::Dorsale::BillingMachine::Quotation
  end

  def scope
    policy_scope(model)
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
      :id_card_id,
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

end
