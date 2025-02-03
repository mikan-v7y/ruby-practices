# frozen_string_literal: true

require 'optparse'

def main
  options, file_names = parse_options
  texts = fetch_text_for_count_wc(file_names)
  show_wc_stats(options, file_names, texts)
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

def fetch_text_for_count_wc(file_names)
  texts = []

  if file_names.empty?
    texts << $stdin.read
  else
    file_names.each do |file_name|
      texts << File.read(file_name)
    end
  end
  texts
end

def show_wc_stats(options, file_names, texts)
  total_wc_data = { line: 0, word: 0, character: 0 }

  texts.each_with_index do |text, index|
    wc_data = caluculate_wc_from_text(options, text)
    wc_format = create_wc_format(wc_data)

    file_name = file_names.any? ? file_names[index] : ' '
    puts "#{wc_format} #{file_name}"

    count_total_wc(total_wc_data, wc_data)
  end

  return if file_names.size < 2

  show_total_wc(total_wc_data)
end

def caluculate_wc_from_text(options, text)
  wc_data = { line: 0, word: 0, character: 0 }

  wc_data[:line] += options[:l] ? text.lines.size : 0
  wc_data[:word] += options[:w] ? text.split(/\s+/).size : 0
  wc_data[:character] += options[:c] ? text.bytesize : 0

  wc_data
end

def create_wc_format(wc_data)
  wc = []

  wc << wc_data[:line] if wc_data[:line] >= 1
  wc << wc_data[:word] if wc_data[:word] >= 1
  wc << wc_data[:character] if wc_data[:character] >= 1

  wc_format = wc.map { |wc_value| wc_value.to_s.rjust(8) }

  wc_format.join(' ')
end

def count_total_wc(total_wc_data, wc_data)
  wc_data.each do |key, wc_data_value|
    total_wc_data[key] += wc_data_value
  end
end

def show_total_wc(total_wc_data)
  total_wc = []

  total_wc << total_wc_data[:line] if total_wc_data[:line] >= 1
  total_wc << total_wc_data[:word] if total_wc_data[:word] >= 1
  total_wc << total_wc_data[:character] if total_wc_data[:character] >= 1

  total_wc_format = total_wc.map { |total_wc_value| total_wc_value.to_s.rjust(8) }.join(' ')

  puts "#{total_wc_format} total"
end

main
