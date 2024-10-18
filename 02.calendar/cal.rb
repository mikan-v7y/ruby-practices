#!/usr/bin/env ruby

# Dateクラスを使うために宣言
require 'date'

# optparserクラスを使うために宣言
require 'optparse'

# -mオプションを使って月を、-yオプションを使って年を表示する

# コマンドライン引数のオプションを定義
hash = {}
opt = OptionParser.new

# -mオプションを定義
opt.on('-m MONTH'){|m|
    hash[:month] = m.to_i
}

#  -yオプションを定義
opt.on('-y YEAR'){|y|
    hash[:year] = y.to_i
}

# -mと-yの後ろで渡した引数を解析する。これにより、定義したオプションが作動する。
opt.parse!(ARGV)

# -mに引数が指定されていない場合は、今月を表示する
if hash[:month] == nil
    hash[:month] = Date.today.month
end

# -yに引数が指定されていない場合は、今年を表示する
if hash[:year] == nil
    hash[:year] = Date.today.year
end

# 月は1~12の範囲で入力できる
if hash[:month] < 1 || hash[:month] > 12
    puts "Month can be entered from 1 to 12"
end

# 年は1970年~2100年の範囲で入力できる
if hash[:year] < 1970 || hash[:year] > 2100
    puts "Year can be entered from 1970 to 2100"
end

# カレンダーの表示画面を作る

# カレンダーに年月を中央寄せで表示する
calender_width = 20
puts "#{hash[:month]}月 #{hash[:year]}".center(calender_width)

# カレンダーに曜日を表す
Sun_to_Sat = ["日", "月", "火", "水", "木", "金", "土"]
puts Sun_to_Sat.join(" ")

# カレンダーの日にち（1日~31日）を取得する
first_day = Date.new(hash[:year], hash[:month], 1)
last_day = Date.new(hash[:year], hash[:month], -1)

days = Enumerator.new { |yielder|
    (first_day..last_day).each do |date|
        yielder << date
    end
}

# 最初の曜日に対するスペース
print " " * (first_day.wday * 3)

# カレンダーの日にちを出力。土曜日なら改行
days.each do |date|
    print date.day.to_s.rjust(2) + " "

    puts if date.wday == 6
end

# カレンダー終了後の改行
puts
