module Dorsale
  class Comment < ActiveRecord::Base
    belongs_to :user,        polymorphic: true
    belongs_to :commentable, polymorphic: true
    
    validates :commentable, presence: true
    validates :text,        presence: true
  end
end
