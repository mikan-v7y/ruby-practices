# frozen_string_literal: true

class ColumnCalculator
  MINIMUM_COLUMN_NUMBER = 1

  def initialize(files, column_padding: 3)
    @files = files
    @column_padding = column_padding
  end

  def column_width
    max_file_characters = @files.map(&:size).max
    max_file_characters + @column_padding
  end

  def columns_number
    _, terminal_width = IO.console.winsize
    [terminal_width / column_width, MINIMUM_COLUMN_NUMBER].max
  end
end
