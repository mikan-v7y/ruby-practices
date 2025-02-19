# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_GAP = 1
COLUMN = 3
FILE_TYPE_LIST = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l'
}.freeze
FILEMODE_PERMISSION_LIST = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  options = define_option
  files = fetch_file(options)
  options[:l] ? show_file_details(files) : files_display_arrangement(files)
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

  opt.on('-l') do
    options[:l] = true
  end

  opt.parse!(ARGV)

  options
end

def fetch_file(options)
  options[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  options[:r] ? Dir.glob('*').reverse : Dir.glob('*')
end

def show_file_details(files)
  total_blocks = files.sum { |file| File.stat(file).blocks }
  puts "total #{total_blocks}"
  show_file_informations(files)
end

def show_file_informations(files)
  files.each do |file|
    fs = File.stat(file)
    file_type = fs.ftype
    mode_number = fs.mode.to_s(8)

    print FILE_TYPE_LIST.fetch(file_type)
    print_filemode(mode_number)
    print " #{fs.nlink.to_s.rjust(3)}"
    print " #{Etc.getpwuid(fs.uid).name}"
    print " #{Etc.getgrgid(fs.gid).name}"
    print " #{fs.size.to_s.rjust(5)}"
    print " #{fs.mtime.strftime('%m %d %H:%M')}"
    puts " #{file}"
  end
end

def print_filemode(mode_number)
  owner_permission = mode_number.to_s[-3].to_s
  group_permission = mode_number.to_s[-2].to_s
  other_permission = mode_number.to_s[-1].to_s

  print FILEMODE_PERMISSION_LIST.fetch(owner_permission)
  print FILEMODE_PERMISSION_LIST.fetch(group_permission)
  print FILEMODE_PERMISSION_LIST.fetch(other_permission)
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
