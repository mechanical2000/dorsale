module Kernel
  def load_dorsale_file
    app_file      = caller.first.split(":").first
    app_root      = ::Rails.application.root.to_s
    relative_file = app_file.gsub(app_root, "")
    dorsale_root  = ::Dorsale::Engine.root.to_s
    dorsale_file  = ::File.join(dorsale_root, relative_file)

    require dorsale_file
  end
end
