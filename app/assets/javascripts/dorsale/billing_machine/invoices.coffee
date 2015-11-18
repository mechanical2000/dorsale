$(document).on "ready page:load", ->

  if ($('#invoice.edit').size() > 0)
    sum_line = (line) ->
      q = line.find('input.line-quantity').val().replace(',', '.')
      up = line.find('input.line-unit_price').val().replace(',', '.')
      vat_rate = line.find('input.line-vat_rate').val().replace(',', '.')
      total =  q * up


    update_line_total = (line)->
      total = sum_line(line)
      display_euros(total, line.find('.line-total'))

    update_total = ->
      total_excluding_taxes = 0
      total_including_taxes = 0
      vat_amount = 0
      advance = parseFloat $('#invoice_advance').val().replace(',', '.') || 0
      commercial_discount = parseFloat $('#invoice_commercial_discount').val().replace(',', '.') || 0

      $('.invoice-line').each (index, element)->
          remove_me = $(element).find('.remove-line input[type="hidden"]').val()
          total_excluding_taxes += sum_line $(element) if remove_me == 'false'
      total_excluding_taxes -= commercial_discount
     

      display_euros(commercial_discount, $('#invoice-commercial_discount'))
      display_euros(total_excluding_taxes, $('#invoice-total_excluding_taxes'))
      display_euros(vat_amount, $('#invoice-vat_amount'))
      display_euros(vat_amount + total_excluding_taxes, $('#invoice-total_including_taxes'))
      display_euros(commercial_discount, $('#invoice-commercial_discount'))
      display_euros(vat_amount+total_including_taxes-advance-commercial_discount, $('#invoice-balance'))

    # Set listener on inputs
    $('#invoice-lines').on 'input', 'input.line-quantity, input.line-unit_price, input.line-vat_rate', (event) ->
      update_line_total $(event.currentTarget).parents('.invoice-line')
      update_total()
    $('#invoice').on 'input','input#invoice_commercial_discount, input#invoice_advance', (event) ->
       update_total()
    $('#invoice').on 'cocoon:after-remove', (event) ->
       update_total()

    # Update values on page loading
    $('.invoice-line').each (index, element)->
      update_line_total $(element)
    update_total()
