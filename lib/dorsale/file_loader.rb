module Kernel
  def dorsale_file
    app_file      = caller(1..1).first.split(":").first
    app_root      = ::Rails.application.root.to_s
    relative_file = app_file.sub(app_root, "")
    dorsale_root  = ::Dorsale::Engine.root.to_s

    ::File.join(dorsale_root, relative_file)
  end
end
