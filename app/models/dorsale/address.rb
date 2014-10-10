module Dorsale
  class Address < ActiveRecord::Base
    validates_presence_of :city
  end
end
