#!/usr/bin/env ruby

# Dateクラスを使うために宣言
require 'date'

# optparserクラスを使うために宣言
require 'optparse'

options = {}
opt = OptionParser.new

opt.on('-m MONTH'){|m|
    options[:month] = m.to_i
}

opt.on('-y YEAR'){|y|
    options[:year] = y.to_i
}

opt.parse!(ARGV)

options[:month] = Date.today.month if options[:month].nil?

if options[:year] == nil
    options[:year] = Date.today.year
end

if options[:month] < 1 || options[:month] > 12
    abort "Month can be entered from 1 to 12"
end

if options[:year] < 1970 || options[:year] > 2100
    abort "Year can be entered from 1970 to 2100"
end

CALENDAR_WIDTH = 20
puts "#{options[:month]}月 #{options[:year]}".center(CALENDAR_WIDTH)

WEEKDAYS = ["日", "月", "火", "水", "木", "金", "土"]
puts WEEKDAYS.join(" ")

first_day = Date.new(options[:year], options[:month], 1)
last_day = Date.new(options[:year], options[:month], -1)

print " " * (first_day.wday * 3)

(first_day..last_day).each do |date|
    print date.day.to_s.rjust(2) + " "

    puts if date.saturday?
end

puts
