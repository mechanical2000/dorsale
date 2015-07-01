$(document).on "ready page:load", ->
  if ($('#quotation.edit').size() > 0)
    sum_line = (line) ->
      q = line.find('input.line-quantity').val().replace(',', '.')
      up = line.find('input.line-unit_price').val().replace(',', '.')
      total =  q * up

    update_line_total = (line)->
      total = sum_line(line)
      display_euros(total, line.find('.line-total'))

    update_total = ->
      total_duty = 0
      vat_rate = $('#quotation_vat_rate').val().replace(',', '.')

      $('.quotation-line').each (index, element)->
          remove_me = $(element).find('.remove-line input[type="hidden"]').val()
          total_duty += sum_line $(element) if remove_me == 'false'
      vat_amount = vat_rate * total_duty / 100.0

      display_euros(total_duty, $('#quotation-total_duty'))
      display_euros(vat_amount, $('#quotation-vat_amount'))
      display_euros(vat_amount+total_duty, $('#quotation-total_all_taxes'))


    # Set listener on inputs
    $('#quotation-lines').on 'input', 'input.line-quantity, input.line-unit_price', (event) ->
      update_line_total $(event.currentTarget).parents('.quotation-line')
      update_total()
    $('#quotation').on 'input', 'input#quotation_vat_rate', (event) ->
       update_total()
    $('#quotation').on 'cocoon:after-remove', (event) ->
       update_total()

    # Update values on page loading
    $('.quotation-line').each (index, element)->
      update_line_total $(element)
    update_total()
