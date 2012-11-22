require './gamestate.rb'


class Playing < GameState
  def initialize *args
    super
    @model = Model.new
    load_bk_image
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
    puts @bk_image.w, @bk_image.h
    SDL::Surface.blit(@bk_image, 0, 0, @bk_image.w, @bk_image.h,
                      screen, 0, 0)
  end
  
  private
  def load_bk_image
    @png = SDL::Surface.load('./img/background.png')
    f = @png.format
    @bk_image = SDL::Surface.new(SDL::HWSURFACE,
                                 @game.screen.w, @game.screen.h,
                                 32, f.Rmask, f.Gmask, f.Bmask, 0)
    
    xscale = @game.screen.w.to_f / @png.w
    yscale = @game.screen.h.to_f / @png.h
    SDL::Surface.transform_draw(@png, @bk_image, 0, xscale, yscale,
                                0, 0, 0, 0, SDL::Surface::TRANSFORM_AA)
    @bk_image.display_format
  end
end
