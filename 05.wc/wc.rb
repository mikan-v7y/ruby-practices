# frozen_string_literal: true

require 'optparse'

def main
  options, file_names = parse_options
  file_names.empty? ? show_stdin_data(options) : show_files_data(options)
end

def parse_options
  opt = OptionParser.new

  options = {}

  opt.on('-l') { options[:l] = true }
  opt.on('-w') { options[:w] = true }
  opt.on('-c') { options[:c] = true }
  opt.parse!(ARGV)

  if options.empty?
    options[:l] = true
    options[:w] = true
    options[:c] = true
  end

  file_names = ARGV

  [options, file_names]
end

def show_stdin_data(options)
  text = $stdin.read
  lwc_data = count_lwc_from_file_text(options, text)
  lwc_data_format = arrange_file_data_lwc(lwc_data)
  puts lwc_data_format
end

def show_files_data(options)
  total_data = { line: 0, word: 0, character: 0 }

  ARGV.each do |file_name|
    text = File.read(file_name)
    lwc_data = count_lwc_from_file_text(options, text)
    lwc_data_format = arrange_file_data_lwc(lwc_data)
    lwc_data_with_file = add_file_name(lwc_data_format, file_name)
    puts lwc_data_with_file

    total_data[:line] += lwc_data[:line]
    total_data[:word] += lwc_data[:word]
    total_data[:character] += lwc_data[:character]
  end

  return unless ARGV.size > 1

  total_data_format = count_total_data(total_data)
  puts "#{total_data_format} total"
end

def count_lwc_from_file_text(options, text)
  lwc_data = { line: 0, word: 0, character: 0 }

  line_number = options[:l] ? text.lines.size : 0
  word_number = options[:w] ? text.split(/\s+/).size : 0
  character_number = options[:c] ? text.bytesize : 0

  lwc_data[:line] += line_number
  lwc_data[:word] += word_number
  lwc_data[:character] += character_number

  lwc_data
end

def arrange_file_data_lwc(lwc_data)
  lwc_data_format = []

  lwc_data_format << lwc_data[:line].to_s.rjust(8) unless lwc_data[:line].zero?
  lwc_data_format << lwc_data[:word].to_s.rjust(8) unless lwc_data[:word].zero?
  lwc_data_format << lwc_data[:character].to_s.rjust(8) unless lwc_data[:character].zero?

  lwc_data_format.join(' ')
end

def add_file_name(lwc_data_format, file_name)
  lwc_data_format << " #{file_name}"
end

def count_total_data(total_data)
  total_data_format = []

  total_data_format << total_data[:line].to_s.rjust(8) unless total_data[:line].zero?
  total_data_format << total_data[:word].to_s.rjust(8) unless total_data[:word].zero?
  total_data_format << total_data[:character].to_s.rjust(8) unless total_data[:character].zero?

  total_data_format.join(' ')
end

main
