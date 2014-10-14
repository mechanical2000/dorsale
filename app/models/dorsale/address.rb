module Dorsale
  class Address < ActiveRecord::Base
    validates_presence_of :city
    belongs_to :addressable, polymorphic: true

    def one_line
      result = [street, street_bis, [zip, city].join(' '), country].join(', ')
    end
  end
end
