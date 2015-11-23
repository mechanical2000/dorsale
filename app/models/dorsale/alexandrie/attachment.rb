module Dorsale
  module Alexandrie
    class Attachment < ActiveRecord::Base
      self.table_name = "dorsale_alexandrie_attachments"

      belongs_to :attachable, polymorphic: true
      belongs_to :sender,     polymorphic: true

      validates :attachable, presence: true
      validates :sender,     presence: true
      validates :file,       presence: true

      mount_uploader :file, ::Dorsale::Alexandrie::FileUploader

      def to_s
        file_identifier
      end
    end
  end
end
