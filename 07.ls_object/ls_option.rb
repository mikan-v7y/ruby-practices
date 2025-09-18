# frozen_string_literal: true

require 'optparse'

class LsOption
  def initialize(argv)
    @all = false
    @long = false
    @reverse = false

    parse(argv)
  end

  def all?
    @all
  end

  def long?
    @long
  end

  def reverse?
    @reverse
  end

  private

  def parse(argv)
    opt = OptionParser.new
    options = {}

    opt.on('-a') do
      @all = true
    end

    opt.on('-l') do
      @long = true
    end

    opt.on('-r') do
      @reverse = true
    end

    opt.parse!(argv)
    options
  end
end
