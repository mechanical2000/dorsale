FactoryGirl.define do
  factory :customer_vault_event, class: ::Dorsale::CustomerVault::Event do
    author { build(:user)                       }
    person { build(:customer_vault_corporation) }
    action { "create"                           }
    text   { "Création de la personne"          }
  end

  factory :customer_vault_event_comment, parent: :customer_vault_event do
    action { "comment"                }
    text   { "Je suis un commentaire" }
  end
end
