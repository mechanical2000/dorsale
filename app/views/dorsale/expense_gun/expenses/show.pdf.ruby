filename = "Note de frais - #{@expense.user} - #{@expense}.pdf"
response.headers["Content-Disposition"] = %(inline; filename="#{filename}")
Dorsale::ExpenseGun::ExpensePdf.new(@expense).tap(&:build).render_with_attachments
