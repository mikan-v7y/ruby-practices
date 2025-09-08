# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @marks = marks.split(',')
    @frames = build_frames
  end

  def total_score
    total = 0
    @frames.each_with_index do |frame, frame_idx|
      # 素点の計算
      total += frame.score

      # ボーナス点の計算
      total += calculate_bonus_points(frame_idx, frame.bonus_shot_count).map(&:score).sum if frame_idx < 9 && frame.bonus_shot_count.positive?
    end
    total
  end

  private

  def build_frames
    frames = []
    marks_idx = 0

    9.times do
      first_mark = @marks[marks_idx] if @marks[marks_idx]
      second_mark = @marks[marks_idx + 1] if @marks[marks_idx + 1]

      if first_mark == 'X'
        frames << Frame.new(first_mark)
        marks_idx += 1
      else
        frames << Frame.new(first_mark, second_mark)
        marks_idx += 2
      end
    end

    frames << Frame.new(@marks[marks_idx], @marks[marks_idx + 1], @marks[marks_idx + 2])
    frames
  end

  def calculate_bonus_points(frame_idx, bonus_shot_count)
    @frames[(frame_idx + 1)..]
      .map { |frame| [frame.first_shot, frame.second_shot, frame.third_shot].compact }.flatten
      .first(bonus_shot_count)
  end
end
