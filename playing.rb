require './game_state.rb'


class Playing < GameState
  @@DEFAULT_KEY_REPEAT_MS = 120
  @@colors = {
    'I'=>0x00FFFF, 'T'=>0x8000FF, 'O'=>0xFFFF00, 'S'=>0x00FF00,
    'Z'=>0xFF0000, 'J'=>0x0000FF, 'L'=>0xFF8000
  }
  
  def initialize *args
    super
    @model = Model.new
    @block = Size(16, 16)
    @field = Rect(Pos(200, 80), Size(@block.w*10, @block.h*20))
    load_bk_image

    @model.on_redraw << lambda { @game.redraw }
  end
  def process_key key, state
    key_repeat_ms = nil
    
    case key
    when SDL::Key::ESCAPE
      # @game.shift_state(PauseMenu)
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

    draw_field(screen)
    draw_coming_blocks(screen)
    # draw_current_block
    block = @model.current_block
    draw_block(screen,
               @field.left   + block.x*@block.w,
               @field.bottom - block.y*@block.h, block)
    
    # y = 0
    # @model.next_blocks(4).each do |b|
    #   p b.name
    #   pos = Pos(0, 0)
    #   x = 0
    #   5.times do |i|
    #     screen.draw_rect(x, y, @block.w, @block.h, 0xff0000, true)
      
    #     draw_block(screen, x + pos.x*@block.w, y + pos.y*@block.h, b)
        
    #     b.rotate_cw
    #     pos += b.deltas[i%4]

    #     x += 100
    #   end
    #   y += 68
    # end
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
  def draw_field screen
    w, h = @block.w*10, @block.h*20
    screen.draw_rect(@field.x, @field.y, w, h, [0,0,0], true, 150)

    line_alpha = 70
    
    x = @field.left
    9.times do
      x += @block.w
      screen.draw_line(x, @field.top, x, @field.bottom, 0xFFFFFF, false, line_alpha)
    end

    y = @field.top
    19.times do
      y += @block.h
      screen.draw_line(@field.left, y, @field.right, y, 0xFFFFFF, false, line_alpha)
    end
  end
  def draw_coming_blocks screen
    x = @field.right + 20
    y = @field.top
    @model.coming_blocks(4).each do |block|
      draw_block(screen, x, y, block)
      y += @block.h * 4
    end
  end
  def draw_block screen, _x, y, block
    block.map.rows.each do |row|
      x = _x
      row.each do |sq|
          screen.draw_rect(x, y, @block.w, @block.h,
                           @@colors[block.name], true, 200) if sq == 1
        x += @block.w
      end
      y += @block.h
    end
  end
end
