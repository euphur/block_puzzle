require './gamestate.rb'


class Playing < GameState
  def initialize
    super
    @model = Model.new
    redraw
  end
  def process_key key, state
    case key
    when SDL::Key::ESCAPE
      @game.shift_state(PauseMenu)
    when SDL::Key::LSHIFT
      @model.stack
    when SDL::Key::SPACE
      @model.hard_drop
    when SDL::Key::LEFT
      @model.move_left
    when SDL::Key::RIGHT
      @model.move_right
    when SDL::Key::DOWN
      @model.move_down
    when SDL::Key::UP
      @model.rotate_cw
    when SDL::Key::LCTRL
      @model.rotate_ccw
    end
  end
  def draw screen
    
  end
end
