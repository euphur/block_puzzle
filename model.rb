require './array2d.rb'


class Event
  def initialize
    @handlers = []
  end
  def << handler
    @handlers << handler
  end
  def dispatch *args
    @handlers.each do |h|
      h.call(*args)
    end
  end
end

module PosBase
  attr_accessor :x, :y
  
  def initialize x=0, y=0
    @x, @y = x, y
  end
  def pos
    self
  end
  def pos= pos
    self.x = pos.x
    self.y = pos.y
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
  def nega
    Pos(-@x, -@y)
  end
end

class Pos
  include PosBase
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

def Size w=0,  h=0
  Size.new(w, h)
end

class Rect
  attr_accessor :x, :y
  attr_accessor :w, :h
  
  def initialize a, b
    @x, @y = a.x, a.y
    case b
    when Size then @w, @h = b.w, b.h
    when Pos  then @w, @h = b.x-a.x, b.y-a.y
    else raise ArgumentError
    end
  end
  def to_s
    "#<Rect (#{left}, #{top})-(#{right}, #{bottom}) #{w}x#{h}>"
  end
  def right
    @x + @w
  end
  def bottom
    @y + @h
  end
  def right= r
    @w = r - @x
  end
  def bottom= b
    @h = b - @y
  end

  alias l       x
  alias t       y
  alias left    l
  alias top     t
  alias r   right 
  alias r=  right=
  alias b   bottom
  alias b=  bottom=
end

def Rect a, b
  Rect.new(a, b)
end

class Block
  attr_reader :name, :map, :deltas
  
  def initialize name, map, deltas
    @name, @map, @delta = name, Array2D.new(map.reverse)
    @deltas = deltas.map { |xy| Pos(*xy) }
  end
  def rotate_cw
    @map = @map.rotate_cw
  end
  def rotate_ccw
    @map = @map.rotate_ccw
  end
end


class Model
  attr_reader :field, :current_block, :block_pos, :current_stack
  # event :on_redraw, :on_delete_line, :on_game_over
  attr_reader :on_redraw, :on_delete_line, :on_game_over

  @@blocks = []
  @@blocks << Block.new('I', [[1,1,1,1]],
                        [[2,-2],[-2,1],[1,-1],[-1,2]])     # BPS
                        # [[2,-1], [-2,1]]*2)              # SEGA
  @@blocks << Block.new('T',
                        [[0,1,0], [1,1,1]],                # BPS
                        [[1,0],[-1,1],[0,-1]] + [[0,0]]*4) # BPS
                        # [[1,1,1], [0,1,0]],              # SEGA
                        # [[0,-1], [0,1], [1,-1], [-1,1]]) # SEGA
  @@blocks << Block.new('O', [[1,1], [1,1]],
                        [[0,0]]*4)
  @@blocks << Block.new('S', [[0,1,1], [1,1,0]],
                        [[1,0],[-1,1],[0,-1]]+[[0,0]]*4)   # BPS
                        # [[0,-1], [0,1]]*2)               # SEGA
  @@blocks << Block.new('Z', [[1,1,0], [0,1,1]],
                        [[1,0],[-1,1],[0,-1],[0,0]])       # BPS
                        # [[1,-1], [-1,1]]*2)              # SEGA
  @@blocks << Block.new('J',
                        [[1,0,0], [1,1,1]],                # BPS
                        [[1,0],[-1,1],[0,-1]]+[[0,0]]*4)   # BPS
                        # [[1,1,1], [0,0,1]],              # SEGA
                        # [[0,-1], [0,1], [1,-1], [-2,1]]) # SEGA
  @@blocks << Block.new('L',
                        [[0,0,1],[1,1,1]],                 # BPS
                        [[1,0],[-1,1],[0,-2],[0,1]])       # BPS
                        # [[1,1,1,], [1,0,0]],             # SEGA
                        # [[0,-1],[-1,1],[2,-1],[-1,1]])   # SEGA
  @@blocks.freeze
  
  def initialize
    @field = Array2D.new(10, 20)
    @on_redraw = Event.new
    @on_delete_line = Event.new
    @on_game_over = Event.new

    next_block
  end
  def next_block
    @current_block = shift_block
    @current_block.extend(PosBase)
    @current_block.x = (10 - @current_block.map.w) / 2
    @current_block.y = 20
    @rotation = 0
    
    on_redraw.dispatch
  end
  def move_left
    return false if @current_block.x == 0
    
    @current_block.x -= 1
    
    on_redraw.dispatch
    true
  end
  def move_right
    return false if @current_block.x + @current_block.map.w >= 10

    @current_block.x += 1
    
    on_redraw.dispatch
    true
  end
  def move_down
    @current_block.y -= 1
    unless lower_valid?
      @current_block.y += 1
      exit
      return false
    end
    
    on_redraw.dispatch
    true
  end
  def rotate_cw
    @current_block.rotate_cw
    @current_block.pos += @current_block.deltas[@rotation%4]
    @rotation += 1

    unless left_valid?
      @current_block.x -= 1 until left_valid?
      return false unless right_valid?
    end
    unless right_valid?
      @current_block.x -= 1 until right_valid?
      return false unless left_valid?
    end
    
    on_redraw.dispatch
    true
    end
  def left_valid?
    @current_block.x >= 0
  end
  def right_valid?
    @current_block.x + @current_block.map.w <= 9
  end
  def lower_valid?
    @current_block.y >= 0
  end
  def rotate_ccw
    @current_block.rotate_ccw
    @current_block.pos += @current_block.deltas[@rotation%4].nega
    @rotation -= 1
    
    on_redraw.dispatch
    true
  end
  def stack
    on_redraw.dispatch
  end
  def hard_drop
    on_redraw.dispatch
  end
  def shift_block
    coming_blocks(1) # make sure @coming_blocks has least 1 block
    @coming_blocks.shift
  end
  def coming_blocks n=7
    @coming_blocks ||= []
    
    while @coming_blocks.size < n
      @coming_blocks += @@blocks.shuffle.map { |block| block.dup }
    end
    @coming_blocks[0, n].freeze
  end
  
  private
  def delete_lines
  end
end

