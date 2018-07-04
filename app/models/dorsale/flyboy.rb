module Dorsale::Flyboy
  class << self
    attr_writer :progress_increment_buttons

    def progress_increment_buttons
      @progress_increment_buttons ||= [5, 10, 25, 50]
    end
  end
end
