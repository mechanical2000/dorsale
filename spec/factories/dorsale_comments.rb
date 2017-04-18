FactoryGirl.define do
  factory :dorsale_comment, class: ::Dorsale::Comment do
    commentable { create(:customer_vault_corporation) }
    author      { create(:user)                       }
    text        { Faker::Lorem.paragraph              }

    after(:create) do |comment|
      if comment.commentable.is_a?(Dorsale::CustomerVault::Person)
        comment.commentable.receive_comment_notification(comment, :create)
      end
    end
  end
end
