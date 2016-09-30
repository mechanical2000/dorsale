class Dorsale::Alexandrie::AttachmentType < ActiveRecord::Base
  self.table_name = "dorsale_alexandrie_attachment_types"

  has_many :attachments, dependent: :nullify

  validates :name, presence: true

  default_scope -> {
    order(:name)
  }

end
