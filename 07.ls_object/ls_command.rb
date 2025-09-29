# frozen_string_literal: true

require 'io/console'
require_relative 'ls_file'
require_relative 'ls_option'
require_relative 'list_formatter'
require_relative 'column_formatter'

class LsCommand
  COLUMN_PADDING = 3
  MINIMUM_COLUMN_NUMBER = 1

  def initialize(argv)
    @options = LsOption.new(argv)
  end

  def run
    files = Dir.entries('.')
    files.reject! { |f| f.start_with?('.') } unless @options.all?
    files.sort!
    files.reverse! if @options.reverse?

    formatter.display(files)
  end

  private

  def formatter
    if @options.long?
      ListFormatter.new
    else
      calculator      = ColumnCalculator.new(files, column_padding: COLUMN_PADDING)
      column_width    = calculator.column_width
      columns_number  = calculator.columns_number
      ColumnFormatter.new(column_width, columns_number)
    end
  end
end
