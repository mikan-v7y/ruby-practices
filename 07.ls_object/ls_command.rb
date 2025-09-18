# frozen_string_literal: true

class LsCommand
  def initialize(argv)
    @options = LsOption.new(argv)
  end
end
