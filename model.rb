require './array2d.rb'


class Pos
  attr_accessor :x, :y
  
  def initialize x=0, y=0
    @x, @y = x, y
  end
end


class Size
  attr_accessor :w, :h

  def initialize w=0, h=0
    @w, @h = w, h
  end
end


class Block
  attr_reader :name, :map
  
  def initialize name, map
    @name, @map = name, Array2D.new(map)
  end
  def rotate_cw
    @map = @map.rotate_cw
  end
  def rotate_ccw
    # @map = @map.rotate_ccw
  end
end


class Model
  attr_reader :field, :current_block, :current_stack

  @@blocks = []
  @@blocks << Block.new('I', [[1,1,1,1]])
  @@blocks << Block.new('T', [[0,1,0], [1,1,1]])
  @@blocks << Block.new('O', [[1,1], [1,1]])
  @@blocks << Block.new('S', [[0,1,1], [1,1,0]])
  @@blocks << Block.new('Z', [[1,1,0], [0,1,1]])
  @@blocks << Block.new('J', [[1,0,0], [1,1,1]])
  @@blocks << Block.new('L', [[0,0,1], [1,1,1]])
  @@blocks.freeze
  
  def initialize
    @field = Array2D.new(10, 20)
    @next_blocks = []
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
  def hard_drop
  end
  def next_blocks n=7
    while @next_blocks.size < n
      @next_blocks += @@blocks.shuffle
    end
    @next_blocks[0, n].freeze
  end
  
  private
  def delete_lines
  end
end

