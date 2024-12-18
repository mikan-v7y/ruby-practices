# frozen_string_literal: true

require 'optparse'

COLUMN_GAP = 1

COLUMN = 3

def main
  options = define_option
  files = fetch_file(options)
  files_display_arrangement(files)
end

def define_option
  opt = OptionParser.new

  options = {}

  opt.on('-a') do
    options[:a] = true
  end

  opt.on('-r') do
    options[:r] = true
  end

  opt.parse!(ARGV)

  options
end

def fetch_file(options)
  options[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  options[:r] ? Dir.glob('*').reverse : Dir.glob('*')
end

def files_display_arrangement(files)
  max_filename_length = files.map(&:size).max
  files_after_arrangement = files.map { |file| file.ljust(max_filename_length + COLUMN_GAP) }
  ls_format_files = files_dimensional_array(files_after_arrangement)
  show_file(ls_format_files)
end

def files_dimensional_array(files)
  quotient, remainder = files.size.divmod(COLUMN)
  rows_number = remainder.zero? ? quotient : quotient + 1

  ls_format_files = Array.new(rows_number) { Array.new(COLUMN) }
  files.each_with_index do |file, i|
    column, row = i.divmod(rows_number)
    ls_format_files[row][column] = file
  end
  ls_format_files
end

def show_file(ls_format_files)
  ls_format_files.each do |row|
    puts row.join(' ')
  end
end

main
