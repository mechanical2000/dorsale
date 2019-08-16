class Dorsale::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Agilibox::DefaultValuesConcern
  include Agilibox::ModelToS
  include Agilibox::ModelI18n
  include Agilibox::PolymorphicId
  include Agilibox::TimestampHelpers

  nilify_blanks before: :validation
end
