# frozen_string_literal: true

require 'optparse'

FILE_STATUS_ORIGIN = { line: 0, word: 0, character: 0 }.freeze

def main
  options = define_option
  ARGV.empty? ? accept_standard_input(options) : load_file_content(options)
end

def define_option
  opt = OptionParser.new

  options = {}

  opt.on('-l') do
    options[:l] = true
  end

  opt.on('-w') do
    options[:w] = true
  end

  opt.on('-c') do
    options[:c] = true
  end

  opt.parse!(ARGV)

  options
end

def accept_standard_input(options)
  file_name = nil
  text = $stdin.read
  count_lwc_from_text(options, file_name, text)
end

def load_file_content(options)
  file_name = ARGV[0]
  text = File.read(file_name)
  count_lwc_from_text(options, file_name, text)
end

def count_lwc_from_text(options, file_name, text)
  lines_number = options[:l] || options.empty? ? text.lines.size : 0
  words_number = options[:w] || options.empty? ? text.split(/\s+/).size : 0
  characters_number = options[:c] || options.empty? ? text.bytesize : 0

  file_status = FILE_STATUS_ORIGIN.dup

  file_status[:line] += lines_number
  file_status[:word] += words_number
  file_status[:character] += characters_number

  display_text = arrange_display_text(options, file_status)
  print_display_text(display_text, file_name)
end

def arrange_display_text(options, file_status)
  display_text = []

  if options.empty?
    display_text = [file_status[:line].to_s.rjust(8), file_status[:word].to_s.rjust(7), file_status[:character].to_s.rjust(7)]
  else
    display_text << file_status[:line].to_s.rjust(8) if options[:l]
    display_text << file_status[:word].to_s.rjust(8) if options[:w]
    display_text << file_status[:character].to_s.rjust(8) if options[:c]
  end
  display_text.join(' ')
end

def print_display_text(display_text, file_name)
  if file_name.nil?
    puts display_text
  else
    file_name = file_name.rjust(6)
    puts "#{display_text} #{file_name}"
  end
end

main
