#!/usr/bin/env ruby
# frozen_string_literal: true

# score = ARGV[0]
score = ARGV[0]

scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end


point = 0
frames.each_with_index do |frame, i|
  point += frame.sum
  next if frame.sum != 10 || i >= 9

  next_frame = frames[i + 1]
  next_next_frame = frames[i + 2]

  point += next_frame[0]
  next if frame[0] != 10

  point += next_frame[1]
  next if next_frame[0] != 10 || next_next_frame == nil

  point += next_next_frame[0]
end

p point
