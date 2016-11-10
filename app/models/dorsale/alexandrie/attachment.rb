class Dorsale::Alexandrie::Attachment < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_alexandrie_attachments"

  belongs_to :attachable, polymorphic: true
  belongs_to :sender,     polymorphic: true

  belongs_to :attachment_type, required: false

  validates :attachable, presence: true
  validates :file,       presence: true

  mount_uploader :file, ::Dorsale::Alexandrie::FileUploader

  before_save :set_default_name

  default_scope -> {
    all
      .order(id: :desc)
      .preload(:attachment_type)
  }

  def set_default_name
    self.name = file_identifier if name.blank?
  end

  def download_filename
    if File.extname(file_identifier) == File.extname(name)
      name
    else
      name.parameterize + File.extname(file_identifier)
    end
  end

end
