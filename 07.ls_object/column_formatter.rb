# frozen_string_literal: true

require 'io/console'

class ColumnFormatter
  COLUMN_PADDING = 3
  MINIMUM_COLUMN_NUMBER = 1

  def display(files)
    return if files.empty?

    column_width = calculate_column_width(files)
    columns_number = calculate_columns_number(column_width)
    rows = build_rows(files, column_width, columns_number)

    print_rows(rows)
  end

  private

  def calculate_column_width(files)
    max_file_characters = files.map(&:size).max
    max_file_characters + COLUMN_PADDING
  end

  def calculate_columns_number(column_width)
    _, terminal_width = IO.console.winsize
    [terminal_width / column_width, MINIMUM_COLUMN_NUMBER].max
  end

  def build_rows(files, column_width, columns_number)
    rows_number = (files.size.to_f / columns_number).ceil
    rows = Array.new(rows_number) { [] }
    files.each_with_index do |file, i|
      row_index = i % rows_number
      rows[row_index] << file.ljust(column_width)
    end
    rows
  end

  def print_rows(rows)
    rows.each { |row| puts row.join }
  end
end
