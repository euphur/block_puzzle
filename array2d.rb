class Array2D
  attr_reader :w, :h

  def initialize *args
    case args[0]
    when Array
      @array = args[0]
      @w, @h = @array[0].size, @array.size
    when Integer
      @w, @h = args
      @array = Array.new(@h) { Array.new(@w) }
    else
      raise
    end
  end
  def [] x, y
    @array[y][x]
  end
  def []= x, y, value
    @array[y][x] = value
  end
  def rows
    @array
  end
  def each &block
    @array.each do |row|
      row.each do |value|
        yield value
      end
    end
  end
  def rotate_cw
    new = Array2D.new(@h, @w)
    
    new.h.times do |y|
      new.w.times  do |x|
        new[x,y] = self[y, @h-x-1]
      end
    end

    new
  end
  def rotate_ccw
    new = Array2D.new(@h, @w)
    
    new.h.times do |y|
      new.w.times  do |x|
        new[x,y] = self[@w-y-1, x]
      end
    end

    new
  end
end
