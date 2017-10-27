module Dorsale::Users::Avatar
  def self.included(user_model)
    user_model.class_eval do
      mount_uploader :avatar, ::Dorsale::AvatarUploader

      def avatar_url
        local_avatar_url || gravatar_url
      end

      def local_avatar_url
        avatar.try(:url)
      end

      def gravatar_url
        gravatar_id = Digest::MD5.hexdigest(email.to_s)
        "https://www.gravatar.com/avatar/#{gravatar_id}?default=mm&size=200"
      end
    end
  end
end
