FactoryGirl.define do
  factory :dorsale_comment, class: ::Dorsale::Comment do
    commentable {
      DummyModel.create!(name: "abc")
    }
    text "the text"
    author { create(:user) }
  end
end
