# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'ls_option'
require_relative 'ls_file'

LsCommand.new(ARGV).run
