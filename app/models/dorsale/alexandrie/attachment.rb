class Dorsale::Alexandrie::Attachment < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_alexandrie_attachments"

  belongs_to :attachable, polymorphic: true
  belongs_to :sender, class_name: User

  belongs_to :attachment_type, required: false

  validates :attachable, presence: true
  validates :file,       presence: true

  mount_uploader :file, ::Dorsale::Alexandrie::FileUploader

  def download_filename
    if File.extname(file_identifier) == File.extname(name)
      name
    else
      name.parameterize + File.extname(file_identifier)
    end
  end

  private

  before_save :assign_default_name

  def assign_default_name
    self.name = file_identifier if name.blank?
  end
end
