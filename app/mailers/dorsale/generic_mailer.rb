class Dorsale::GenericMailer < Dorsale::ApplicationMailer
  def generic_email(data)
    data.delete(:attachments).each do |filename, content|
      attachments[filename] = content
    end

    mail(data)
  end
end
