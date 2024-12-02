# frozen_string_literal: true

COLUMN_GAP = 1

COLUMN = 3

def logic
  files = Dir.glob('*')
  files_display_arrangement(files)
end

def files_display_arrangement(files)
  longest_file_characters = files.map(&:size).max
  files_after_arrangement = files.map { |file| file.ljust(longest_file_characters + COLUMN_GAP) }

  files_number = files.size
  quotient, remainder = files_number.divmod(COLUMN)
  rows_number = remainder.zero? ? quotinet : quotient + 1

  ls_format_files = files_dimensional_array(files_after_arrangement, rows_number)
  show_file(ls_format_files)
end

def files_dimensional_array(files, rows_number)
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

logic
