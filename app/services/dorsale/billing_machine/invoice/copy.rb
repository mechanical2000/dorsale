class Dorsale::BillingMachine::Invoice::Copy < ::Dorsale::Service
  attr_accessor :invoice, :copy

  def initialize(invoice)
    super()
    @invoice = invoice
  end

  def call
    @copy = invoice.dup

    @invoice.lines.each do |line|
      @copy.lines << line.dup
    end

    @copy.date         = Date.current
    @copy.due_date     = Date.current + 30.days
    @copy.unique_index = nil
    @copy.paid         = false

    @copy
  end
end
