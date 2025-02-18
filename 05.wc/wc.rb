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
  if file_names.empty?
    [{ name: '', content: $stdin.read }]
  else
    file_names.map do |file_name|
      {
        name: file_name,
        content: File.read(file_name)
      }
    end
  end
end

def show_stats(options, file_names, file_contents)
  total_counts = { line: 0, word: 0, character: 0 }

  file_contents.each do |file|
    name = file[:name]
    content = file[:content]

    counts = calculate_stats(options, content)
    grid_format = format(counts)

    puts "#{grid_format} #{name}"

    count_total(total_counts, counts)
  end

  return if file_names.size < 2

  show_total(total_counts)
end

def calculate_stats(options, content)
  counts = { line: 0, word: 0, character: 0 }

  counts[:line] += options[:l] ? content.lines.size : 0
  counts[:word] += options[:w] ? content.strip.split(/\s+/).size : 0
  counts[:character] += options[:c] ? content.bytesize : 0

  counts
end

def format(counts)
  format = []

  format << counts[:line] if counts[:line]
  format << counts[:word] if counts[:word]
  format << counts[:character] if counts[:character]

  grid_format = format.map { |value| value.to_s.rjust(8) }

  grid_format.join(' ')
end

def count_total(total_counts, counts)
  counts.each do |key, value|
    total_counts[key] += value
  end
end

def show_total(total_counts)
  total_format = []

  total_format << total_counts[:line] if total_counts[:line] >= 1
  total_format << total_counts[:word] if total_counts[:word] >= 1
  total_format << total_counts[:character] if total_counts[:character] >= 1

  totals = total_format.map { |total_value| total_value.to_s.rjust(8) }.join(' ')

  puts "#{totals} total"
end

main
