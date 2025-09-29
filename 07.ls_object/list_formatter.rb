# frozen_string_literal: true

require_relative 'ls_file'

class ListFormat
  def display(files)
    return if files.empty?

    display_total_blocks(files)
    files.each { |file| puts LsFile.new(file).details }
  end

  private

  def display_total_blocks(files)
    total_blocks = files.sum { |file| File.stat(file).blocks }
    puts "total #{total_blocks}"
  end
end
