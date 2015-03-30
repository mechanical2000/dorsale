module Dorsale
  class Comment < ActiveRecord::Base
    belongs_to :user,        polymorphic: true
    belongs_to :commentable, polymorphic: true
    has_many :events, as: :eventable, dependent: :destroy
    
    validates :commentable, presence: true
    validates :text,        presence: true
  end
end
