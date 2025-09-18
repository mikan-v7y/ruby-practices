# frozen_string_literal: true

class LsFile
  def initialize(name)
    @name = name
    @stat = File.stat(@name)
  end
end
