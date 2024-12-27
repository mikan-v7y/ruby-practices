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
  # show_file_details(files) デバッガ用
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

# show_file_detailsを定義

def show_file_details(files)
  stat = files.map { |file| [file, File.stat(file)] }.to_h
  mode = stat.transform_values { |file_stat| file_stat.mode.to_s(8) }
  show_total_blocks(files, stat)
  show_file_informations(mode)
end

# ブロック数を表示

def show_total_blocks(files, stat)
  total_blocks = files.sum { |file| stat[file].blocks }
  puts "total #{total_blocks}"
end

# ファイルの詳細情報を表示する

def show_file_informations(mode)
  mode.each do |file, mode_number|
    file_type = File.stat(file).ftype
    print FILE_TYPE_LIST.fetch(file_type)

    file_stat = File.stat(file)
    print_filemode(mode_number)

    print " #{file_stat.nlink.to_s.rjust(3)}"
    print " #{Etc.getpwuid(file_stat.uid).name}"
    print " #{Etc.getgrgid(file_stat.gid).name}"
    print " #{file_stat.size.to_s.rjust(5)}"
    print " #{file_stat.mtime.strftime('%m %d %H:%M')}"
    puts " #{file}"
  end
end

# ファイルモードを表示するメソッド

def print_filemode(mode_number)
  owner_permission = mode_number.to_s[2].to_s
  group_permission = mode_number.to_s[3].to_s
  other_permission = mode_number.to_s[4].to_s

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
