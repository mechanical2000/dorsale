module Dorsale
  module Alexandrie
    module AttachmentsHelper
      def attachments_for(attachable)
        render "dorsale/alexandrie/attachments/loader", attachable: attachable
      end
    end
  end
end
