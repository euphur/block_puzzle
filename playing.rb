require './game_state.rb'


class Playing < GameState
  @@DEFAULT_KEY_REPEAT_MS = 500
  @@colors = {
    'I'=>0x00FFFF, 'T'=>0x8000FF, 'O'=>0xFFFF00, 'S'=>0x00FF00,
    'Z'=>0xFF0000, 'J'=>0x0000FF, 'L'=>0xFF8000
  }
  
  def initialize *args
    super
    @model = Model.new
    @block = Size.new(16, 16)
    
    load_bk_image
  end
  def process_key key, state
    key_repeat_ms = nil
    
    case key
    when SDL::Key::ESCAPE
      @game.shift_state(PauseMenu)
    when SDL::Key::LSHIFT
      @model.stack
    when SDL::Key::SPACE
      @model.hard_drop
    when SDL::Key::LEFT
      @model.move_left
      key_repeat_ms = @@DEFAULT_KEY_REPEAT_MS
    when SDL::Key::RIGHT
      @model.move_right
      key_repeat_ms = @@DEFAULT_KEY_REPEAT_MS
    when SDL::Key::DOWN
      @model.move_down
    when SDL::Key::UP
      @model.rotate_cw
    when SDL::Key::LCTRL
      @model.rotate_ccw
    end

    key_repeat_ms
  end
  def draw screen
    SDL::Surface.blit(@bk_image, 0, 0, @bk_image.w, @bk_image.h,
                      screen, 0, 0)

    y = 5
    @model.next_blocks.each do |b|
      p b.name
      x = 20
      4.times do
        ly = y
        b.map.rows.each do |row|
          lx = x
          row.each do |sq|
            if sq == 1
              screen.draw_rect(lx, ly, @block.w, @block.h, @@colors[b.name], true, 200)
            end
            screen.draw_rect(lx, ly, @block.w, @block.h, 0xFFFFFF, false, 150)
            lx += @block.w
          end
          ly += @block.h
        end
        b.rotate_cw
        x += 100
      end
      y += 68
    end
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
