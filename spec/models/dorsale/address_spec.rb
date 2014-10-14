require 'rails_helper'

module Dorsale
  RSpec.describe Address, :type => :model do
    it {should validate_presence_of :city}
    it {should belong_to :addressable}
    describe '#one_line' do
      it 'should build a one line address' do
        address = Address.create(street: '3 Rue Marx Dormoy', 
                                 street_bis: 'L\'atelier',
                                 zip: '13004',
                                 city: 'Marseille', 
                                 country: 'France')
        expect(address.one_line).to eq('3 Rue Marx Dormoy, L\'atelier, 13004 Marseille, France')
      end

      it 'should remove useless commas' do
        address = Address.create(street: '3 Rue Marx Dormoy', 
                                 street_bis: '',
                                 zip: '13004',
                                 city: 'Marseille', 
                                 country: '')
        expect(address.one_line).to eq('3 Rue Marx Dormoy, 13004 Marseille')
      end

      it 'should remove useless commas' do
        address = Address.create(street: '3 Rue Marx Dormoy', 
                                 street_bis: '',
                                 zip: '',
                                 city: 'Marseille', 
                                 country: '')
        expect(address.one_line).to eq('3 Rue Marx Dormoy, Marseille')
      end
    end
  end
end
