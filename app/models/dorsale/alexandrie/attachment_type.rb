class Dorsale::Alexandrie::AttachmentType < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_alexandrie_attachment_types"

  has_many :attachments, dependent: :nullify

  validates :name, presence: true

  default_scope -> {
    order(:name)
  }

end
