class Dorsale::Serializers::Base
  attr_reader :data, :options

  def initialize(data, options = {})
    @data    = data
    @options = options
  end

  def render_inline
    raise NotImplementedError
  end

  def render_file(file_path)
    raise NotImplementedError
  end

end
