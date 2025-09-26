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
      permissions,
      @stat.nlink.to_s.rjust(2),
      Etc.getpwuid(@stat.uid).name,
      Etc.getgrgid(@stat.gid).name,
      size.to_s.rjust(5),
      mtime.strftime('%b %d %H:%M'),
      @name
    ].join(' ')
  end

  def permissions
    file_type_and_permissions
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end

  private

  def file_type_and_permissions
    file_type = FILE_TYPE_LIST.fetch(@stat.ftype)

    mode_number = @stat.mode.to_s(8)

    owner_permission = mode_number[-3]
    group_permission = mode_number[-2]
    other_permission = mode_number[-1]

    permissions = [
      FILEMODE_PERMISSION_LIST.fetch(owner_permission),
      FILEMODE_PERMISSION_LIST.fetch(group_permission),
      FILEMODE_PERMISSION_LIST.fetch(other_permission)
    ].join

    file_type + permissions
  end
end
