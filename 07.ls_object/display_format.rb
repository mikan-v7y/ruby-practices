# frozen_string_literal: true

require 'io/console'

class DisplayFormat
  def initialize(files, column_width, columns_number)
    @files          = files
    @column_width   = column_width
    @columns_number = columns_number
  end

  def display
    return if @files.empty?

    rows = build_rows
    print_rows(rows)
  end

  private

  def build_rows
    rows_number = (@files.size.to_f / @columns_number).ceil
    rows = Array.new(rows_number) { [] }
    @files.each_with_index do |file, i|
      row_index = i % rows_number
      rows[row_index] << file.ljust(@column_width)
    end
    rows
  end

  def print_rows(rows)
    rows.each { |row| puts row.join }
  end
end
