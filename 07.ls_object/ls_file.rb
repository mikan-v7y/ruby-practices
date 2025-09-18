# frozen_string_literal: true

require 'etc'

class LsFile
  def initialize(name)
    @name = name
    @stat = File.stat(@name)
  end

  def details
    [
      file_type_and_permissions,
      @stat.nlink.to_s.rjust(2),
      Etc.getpwuid(@stat.uid).name,
      Etc.getgrgid(@stat.gid).name,
      @stat.size.to_s.rjust(5),
      @stat.mtime.strftime('%b %d %H:%M'),
      @name
    ].join(' ')
  end
end
