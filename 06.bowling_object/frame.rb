# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark) if first_mark
    @second_shot = Shot.new(second_mark) if second_mark
    @third_shot = Shot.new(third_mark) if third_mark
  end

  # 1フレームの合計点を計算
  def score
    [@first_shot, @second_shot, @third_shot].compact.sum(&:score)
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    !strike? && @first_shot.score + @second_shot.score == 10
  end

  def bonus_shot_count
    return 2 if strike?

    return 1 if spare?

    0
  end
end
