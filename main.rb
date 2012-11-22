require 'sdl'
require './model.rb'
require './playing.rb'


class BlockPuzzle
  attr_reader :screen
  
  def initialize
    SDL.init(SDL::INIT_VIDEO)
    @screen = SDL.set_video_mode(640, 480, 32, SDL::HWSURFACE)
    @state = Playing.new(self)
    redraw
  end
  def run
    loop do
      while event = SDL::Event.poll
        process_event(event)
      end
    end
  end
  def redraw
    @state.redraw(@screen)
  end
  def process_event event
    case event
    when SDL::Event::Quit
      exit
    end
  end
end


BlockPuzzle.new.run
