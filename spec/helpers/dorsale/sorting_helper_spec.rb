require 'rails_helper'

describe Dorsale::SortingHelper, type: :helper do
  describe "#sortable_column" do
    let(:params) {{
      :controller => "home",
      :action     => "home",
    }}

    it "current sort is nil" do
      link = sortable_column("text", :col)
      expect(link).to eq %(<a class="sort" href="/?sort=col">text</a>)
    end

    it "current sort is col" do
      params.merge!(sort: "col")
      link = sortable_column("text", :col)
      expect(link).to eq %(<a class="sort asc" href="/?sort=-col">text ↓</a>)
    end

    it "current sort is -col" do
      params.merge!(sort: "-col")
      link = sortable_column("text", :col)
      expect(link).to eq %(<a class="sort desc" href="/?sort=col">text ↑</a>)
    end

    it "current sort is other" do
      params.merge!(sort: "other")
      link = sortable_column("text", :col)
      expect(link).to eq %(<a class="sort" href="/?sort=col">text</a>)
    end

    it "current sort is -other" do
      params.merge!(sort: "-other")
      link = sortable_column("text", :col)
      expect(link).to eq %(<a class="sort" href="/?sort=col">text</a>)
    end

    it "should raise on invalid column type" do
      # old handles_sortable_columns syntax
      expect {
        sortable_column("text", {column: "col"})
      }.to raise_error ArgumentError
    end
  end # describe "#sortable_column"

  describe "#sortable_column_order" do
    attr_reader :params

    it "should parse asc column" do
      @params = {sort: "col"}
      expect(sortable_column_order).to eq ["col", :asc]
    end

    it "should parse desc column" do
      @params = {sort: "-col"}
      expect(sortable_column_order).to eq ["col", :desc]
    end

    it "should parse nil" do
      @params = {}
      expect(sortable_column_order).to eq [nil, nil]
    end

    it "should accept block" do
      @params = {sort: "-col"}

      sortable_column_order do |column, order|
        expect(column).to eq "col"
        expect(order).to eq :desc
      end
    end
  end # describe "#sortable_column_order"
end
