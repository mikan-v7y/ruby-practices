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
    # 現在の投球数を表すインデックス
    idx = 0

    # 1~9フレームの処理
    9.times do
      first_mark = @marks[idx] if @marks[idx]
      second_mark = @marks[idx + 1] if @marks[idx + 1]

      if first_mark == 'X'
        frames << Frame.new(first_mark)
        idx += 1
      else
        frames << Frame.new(first_mark, second_mark)
        idx += 2
      end
    end

    # 10フレームの処理
    frames << Frame.new(@marks[idx], @marks[idx + 1], @marks[idx + 2])
    frames
  end

  def calculate_bonus_points(frame_idx, bonus_shot_count)
    # 次のフレーム以降の、全てのFrameオブジェクトを取得。
    @frames[(frame_idx + 1)..]
      # FrameオブジェクトからShotクラスのオブジェクトを取得し、点数の文字列が格納された配列を作成。
      .map { |frame| [frame.first_shot, frame.second_shot, frame.third_shot].compact }.flatten
      # 配列の先頭から、bonus_shot_count数分の点数の文字列を取得。
      .first(bonus_shot_count)
  end
end
