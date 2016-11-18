class Dorsale::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include Dorsale::ActiveRecordUUIDConcern
  include Dorsale::DefaultValuesConcern
  nilify_blanks

  def self.last_created
    reorder(:created_at, :id).last
  end
end

ActsAsTaggableOn::Tagging.send(:include, Dorsale::ActiveRecordUUIDConcern)
ActsAsTaggableOn::Tag.send(:include, Dorsale::ActiveRecordUUIDConcern)
