fields = %w(
  person_type
  first_name
  last_name
  name
  short_name
  email
  phone
  mobile
  fax
  skype
  www
  twitter
  facebook
  linkedin
  viadeo
  legal_form
  capital
  immatriculation_number_1
  immatriculation_number_2
  european_union_vat_number
  address.street
  address.street_bis
  address.city
  address.zip
  address.country
)

data = []

data << fields.map { |field| model.t(field) }

@people_without_pagination.each do |person|
  line = []

  fields.each do |field|
    if field == "person_type"
      line << person.class.t
    elsif field.include?("address.")
      line << person.address.public_send(field.gsub("address.", ""))
    else
      line << person.public_send(:try, field)
    end
  end

  data << line
end

Agilibox::Serializers::XLSX.new(data).render_inline
