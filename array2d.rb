class Array2D
  attr_reader :w, :h

  def initialize w, h
    @w, @h = w, h
    @array = Array.new(@h) { Array.new(@w) }
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
end
