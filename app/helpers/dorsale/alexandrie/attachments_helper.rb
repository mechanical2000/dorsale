module Dorsale
  module Alexandrie
    module AttachmentsHelper
      def attachment_form_for(attachable)
        render "dorsale/alexandrie/attachments/form", attachable: attachable
      end

      def attachments_list_for(attachable)
        render "dorsale/alexandrie/attachments/list", attachable: attachable
      end

      def attachments_for(attachable)
        render "dorsale/alexandrie/attachments/form_and_list", attachable: attachable
      end
    end
  end
end
