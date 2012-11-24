require './array2d.rb'


class Pos
  attr_accessor :x, :y
  
  def initialize x=0, y=0
    @x, @y = x, y
  end
  def + pos
    self.x += pos.x
    self.y += pos.y
    self
  end
  def - pos
    self.x -= pos.x
    self.y -= pos.y
    self
  end
end

def Pos x=0, y=0
  Pos.new(x, y)
end

class Size
  attr_accessor :w, :h

  def initialize w=0, h=0
    @w, @h = w, h
  end
end


class Block
  attr_reader :name, :map, :deltas
  
  def initialize name, map, deltas
    @name, @map, @delta = name, Array2D.new(map)
    @deltas = deltas.map { |xy| Pos(*xy) }
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
  @@blocks << Block.new('I', [[1,1,1,1]],
                        [[2,-1], [-2,1]]*2)
  @@blocks << Block.new('T', [[1,1,1], [0,1,0]],
                        [[0,-1], [0,1], [1,-1], [-1,1]])
  @@blocks << Block.new('O', [[1,1], [1,1]],
                        [[0,0]]*4)
  @@blocks << Block.new('S', [[0,1,1], [1,1,0]],
                        [[0,-1], [0,1]]*2)
  @@blocks << Block.new('Z', [[1,1,0], [0,1,1]],
                        [[1,-1], [-1,1]]*2)
  @@blocks << Block.new('J', [[1,1,1], [0,0,1]],
                        [[0,-1], [0,1], [1,-1], [-2,1]])
  @@blocks << Block.new('L', [[1,1,1,], [1,0,0]],
                        [[0,-1],[-1,1],[2,-1],[-1,1]])
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

