# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'ls_file'
require_relative 'ls_option'

LsCommand.new(ARGV).run
