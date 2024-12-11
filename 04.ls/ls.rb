# frozen_string_literal: true

COLUMN_GAP = 1

COLUMN = 3

def main
  files = Dir.glob('*')
  files_display_arrangement(files)
end

def files_display_arrangement(files)
  max_file = files.map(&:size).max
  files_after_arrangement = files.map { |file| file.ljust(max_file + COLUMN_GAP) }
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
