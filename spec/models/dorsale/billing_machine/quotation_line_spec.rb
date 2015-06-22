require 'spec_helper'

describe QuotationLine do
  
  it 'should have a valid factory' do
    FactoryGirl.build(:quotation_line).should be_valid
  end 
  
  it { should belong_to :quotation }
  it { should respond_to :quantity?}
  it { should respond_to :label?}
  it { should respond_to :total?}
  it { should respond_to :unit?}
  it { should respond_to :unit_price?}
  
  it 'should be sorted by created_at' do
    line1 = FactoryGirl.create(:quotation_line,:created_at => DateTime.now + 1.seconds)
    line2 = FactoryGirl.create(:quotation_line,:created_at => DateTime.now + 2.seconds)
    line3 = FactoryGirl.create(:quotation_line,:created_at => DateTime.now + 3.seconds)
    line4 = FactoryGirl.create(:quotation_line,:created_at => DateTime.now + 4.seconds)
    line3.update(:created_at => DateTime.now+5.seconds)
    lines = QuotationLine.all
    lines.should == ([line1, line2, line4, line3])
  end

  it 'should update the total upon save' do
    quotation = FactoryGirl.create(:quotation_line, quantity: 10, unit_price: 10, total: 0)
    expect(quotation.total).to eq(100)
  end
  it 'should update the total gracefully with invalid data' do
    quotation = FactoryGirl.create(:quotation_line, quantity: nil, unit_price: nil, total: 0)
    expect(quotation.total).to eq(0)
  end
  
end

