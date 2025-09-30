# frozen_string_literal: true

require 'io/console'
require_relative 'ls_file'
require_relative 'ls_option'
require_relative 'list_format'
require_relative 'column_format'
require_relative 'column'

class LsCommand
  COLUMN_PADDING = 3

  def initialize(argv)
    @options = LsOption.new(argv)
  end

  def run
    files = Dir.entries('.')
    files.reject! { |f| f.start_with?('.') } unless @options.all?
    files.sort!
    files.reverse! if @options.reverse?

    formatter(files).display
  end

  private

  def formatter(files)
    if @options.long?
      ListFormat.new(files)
    else
      column = Column.new(files, column_padding: COLUMN_PADDING)
      column_width    = column.width
      columns_number  = column.number(column_width)
      ColumnFormat.new(files, column_width, columns_number)
    end
  end
end
