class Dorsale::CustomerVault::CorporationData < Dorsale::CustomerVault::PersonData
  attribute :legal_form,                String
  attribute :immatriculation_number,    String
  attribute :naf,                       String
  attribute :european_union_vat_number, String
  attribute :societe_com,               String
  attribute :capital,                   Integer
  attribute :revenue,                   Integer
  attribute :number_of_employees,       Integer
end
