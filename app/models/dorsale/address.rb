module Dorsale
  class Address < ActiveRecord::Base
    validates_presence_of :city
    belongs_to :addressable, polymorphic: true
  end
end
