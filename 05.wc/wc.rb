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
  if file_names.empty?
      [$stdin.read]
  else
      file_names.map { |file_name| File.read(file_name) }
  end
end

def show_wc_stats(options, file_names, texts)
  total_data = { line: 0, word: 0, character: 0 }

  texts.each_with_index do |text, index|
    counts = calculate_wc_stats(options, text)
    grid_format = create_format(counts)

    file_name = file_names.any? ? file_names[index] : ' '
    puts "#{grid_format} #{file_name}"

    count_total(total_data, counts)
  end

  return if file_names.size < 2

  show_total(total_data)
end

def calculate_wc_stats(options, text)
  counts = { line: 0, word: 0, character: 0 }

  counts[:line] += options[:l] ? text.lines.size : 0
  counts[:word] += options[:w] ? text.split(/\s+/).size : 0
  counts[:character] += options[:c] ? text.bytesize : 0

  counts
end

def create_format(counts)
  format = []

  format << counts[:line] if counts[:line] >= 1
  format << counts[:word] if counts[:word] >= 1
  format << counts[:character] if counts[:character] >= 1

  grid_format = format.map { |wc_value| wc_value.to_s.rjust(8) }

  grid_format.join(' ')
end

def count_total(total_data, counts)
  counts.each do |key, wc_data_value|
    total_data[key] += wc_data_value
  end
end

def show_total(total_data)
  total = []

  total << total_data[:line] if total_data[:line] >= 1
  total << total_data[:word] if total_data[:word] >= 1
  total << total_data[:character] if total_data[:character] >= 1

  total_format = total.map { |total_wc_value| total_wc_value.to_s.rjust(8) }.join(' ')

  puts "#{total_format} total"
end

main
