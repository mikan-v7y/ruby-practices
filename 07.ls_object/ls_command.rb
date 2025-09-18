# frozen_string_literal: true

require 'io/console'

class LsCommand
  def initialize(argv)
    @options = LsOption.new(argv)
  end

  def run
    files = Dir.entries('.')
    files.reject! { |f| f.start_with?('.') } unless @options.all?
    files.sort!
    files.reverse! if @options.reverse?

    if @options.long?
      display_total_blocks(files)

      files.each do |file|
        puts LsFile.new(file).details
      end
    else
      display_files_in_ls_format(files)
    end
  end

  private

  def display_total_blocks(files)
    total_blocks = files.sum { |file| File.stat(file).blocks }
    puts "total #{total_blocks}"
  end
end
