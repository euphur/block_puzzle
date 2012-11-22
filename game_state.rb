class GameState
  def initialize game
    @game = game
  end
  def redraw screen
    draw(screen)
    screen.updateRect(0, 0, 0, 0)
  end
  def draw screen
    raise NotImplementedError    
  end
  def process_event event
  end
  def process_key key, state
  end
end
