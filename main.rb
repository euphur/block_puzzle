require 'sdl'
require './model.rb'


class BlockPuzzle
  def initialize
    SDL.init(SDL::INIT_VIDEO)
    @screen = SDL.set_video_mode(640, 480, 32, SDL::HWSURFACE)
    @model = Model.new
  end
  def run
    loop do
      while event = SDL::Event.poll
        process_event(event)
      end
    end
  end
  def process_event event
    case event
    when SDL::Event::Quit
      exit
    end
  end
end


BlockPuzzle.new.run
