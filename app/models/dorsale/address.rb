module Dorsale
  class Address < ActiveRecord::Base
    validates_presence_of :city
    belongs_to :addressable, polymorphic: true

    def one_line
      result = [street, street_bis, [zip, city].delete_if {|e| e.blank?}.join(' '), country].delete_if {|e| e.blank?}.join(', ')
    end
  end
end
