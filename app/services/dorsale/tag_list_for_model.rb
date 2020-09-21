class Dorsale::TagListForModel < ::Dorsale::Service
  attr_reader :model

  def initialize(model)
    super()
    @model = model
  end

  def call
    model
      .tags_on(:tags)
      .order(:name)
      .pluck(:name)
  end
end
