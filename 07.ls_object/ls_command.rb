# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'ls_file'
require 'io/console'

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

    max_file_characters = files.map(&:size).max
    column_width = max_file_characters + COLUMN_PADDING

    _, terminal_width = IO.console.winsize
    columns_number = [terminal_width / column_width, MINIMUM_COLUMN_NUMBER].max
    rows_number = (files.size.to_f / columns_number).ceil

    rows = Array.new(rows_number) { [] }
    files.each_with_index do |file, i|
      row_index_to_be_placed = i % rows_number
      rows[row_index_to_be_placed] << file.ljust(column_width)
    end

    rows.each { |row| puts row.join }
  end
end
