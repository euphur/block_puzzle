require './array2d.rb'


class Model
  attr_reader :field, :current_block, :current_stack, :next_blocks
  
  def initialize
    @field = Array2D.new(10, 20)
  end
  def block_next
  end
  def move_left
  end
  def move_right
  end
  def move_down
  end
  def rotate_cw
  end
  def rotate_ccw
  end
  def stack
  end
  
  private
  def delete_lines
  end
end
