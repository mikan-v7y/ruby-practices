# frozen_string_literal: true

require 'io/console'
require_relative 'ls_file'
require_relative 'ls_option'

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

    if @options.long?
      display_total_blocks(files)

      files.each do |file|
        puts LsFile.new(file).details
      end
    else
      display_files_in_ls_format(files)
    end
  end

  private

  def display_total_blocks(files)
    total_blocks = files.sum { |file| File.stat(file).blocks }
    puts "total #{total_blocks}"
  end

  def display_files_in_ls_format(files)
    return if files.empty?

    column_width = calculate_column_width(files)
    columns_number = calculate_columns_number(column_width)
    rows = build_rows(files, column_width, columns_number)

    print_rows(rows)
  end

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
