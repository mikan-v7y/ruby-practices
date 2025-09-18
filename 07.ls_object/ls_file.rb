# frozen_string_literal: true

require 'etc'

class LsFile
  FILE_TYPE_LIST = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l'
  }.freeze

  FILEMODE_PERMISSION_LIST = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

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
