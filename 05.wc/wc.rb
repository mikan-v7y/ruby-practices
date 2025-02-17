# frozen_string_literal: true

require 'optparse'

def main
  options, file_names = parse_options
  file_contents = fetch_file_contents(file_names)
  show_stats(options, file_names, file_contents)
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

def fetch_file_contents(file_names)
  files = []

  if file_names.empty?
    files << { name: '', content: $stdin.read }
  else
    file_names.each do |file_name|
      file = {}
      file[:name] = file_name
      file[:content] = File.read(file_name)
      files << file
    end
  end
  files
end

def show_stats(options, file_names, file_contents)
  total_data = { line: 0, word: 0, character: 0 }

  file_contents.each do |file|
    name = file[:name]
    content = file[:content]

    counts = calculate_stats(options, content)
    grid_format = format(counts)

    puts "#{grid_format} #{name}"

    count_total(total_data, counts)
  end

  return if file_names.size < 2

  show_total(total_data)
end

def calculate_stats(options, content)
  counts = { line: 0, word: 0, character: 0 }

  counts[:line] += options[:l] ? content.lines.size : 0
  counts[:word] += options[:w] ? content.split(/\s+/).size : 0
  counts[:character] += options[:c] ? content.bytesize : 0

  counts
end

def format(counts)
  format = []

  format << counts[:line] if counts[:line] >= 1
  format << counts[:word] if counts[:word] >= 1
  format << counts[:character] if counts[:character] >= 1

  grid_format = format.map { |value| value.to_s.rjust(8) }

  grid_format.join(' ')
end

def count_total(total_data, counts)
  counts.each do |key, value|
    total_data[key] += value
  end
end

def show_total(total_data)
  total = []

  total << total_data[:line] if total_data[:line] >= 1
  total << total_data[:word] if total_data[:word] >= 1
  total << total_data[:character] if total_data[:character] >= 1

  total_format = total.map { |total_value| total_value.to_s.rjust(8) }.join(' ')

  puts "#{total_format} total"
end

main
