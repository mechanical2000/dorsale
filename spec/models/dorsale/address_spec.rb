require 'rails_helper'

module Dorsale
  RSpec.describe Address, :type => :model do
    it {should validate_presence_of :city}
    it {should belong_to :addressable}
    describe '#one_line' do
      it 'should build a one line address'do
        address = Address.create(street: '3 Rue Marx Dormoy', 
                                 street_bis: 'L\'atelier',
                                 zip: '13004',
                                 city: 'Marseille', 
                                 country: 'France')
        expect(address.one_line).to eq('3 Rue Marx Dormoy, L\'atelier, 13004 Marseille, France')

      end
    end
  end
end
