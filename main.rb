require 'sdl'
require './model.rb'
require './playing.rb'


class Proc
  def bind *args
    @binded_args = args
    self
  end
  
  alias _call call
  
  def call *args
    @binded_args ? _call(*@binded_args) : _call(*args)
  end
end


KEY_DOWN = 0
KEY_REPEAT = 1


class TimersManager
  Timer = Struct.new(:id, :time, :ms, :handler)
  
  def initialize
    @timers = []
  end
  def add id, ms, handler
    delete(id)
    @timers << Timer.new(id, SDL::get_ticks+ms, ms, handler)
  end
  def delete id
    @timers.delete_if { |timer| timer.id == id }
  end
  def process    
    now = SDL::get_ticks

    call_timers = [] # prevent timers deleted in iteration
    @timers.each do |timer|
      call_timers << timer if now >= timer.time
    end

    call_timers.each do |timer|
      case new_ms = timer.handler.call
      when Integer then timer.time += new_ms
      when true    then delete(timer.id)
      when false   then timer.time += timer.ms
      else raise
      end
    end
  end
end


class BlockPuzzle
  attr_reader :screen, :timers
  
  def initialize
    SDL.init(SDL::INIT_VIDEO)
    @screen = SDL.set_video_mode(640, 480, 32, SDL::HWSURFACE)
    SDL::WM.set_caption('Block Puzzle', '')
    @timers = TimersManager.new
    
    @state = Playing.new(self)
    redraw
  end
  def run
    loop do
      while event = SDL::Event.poll
        process_event(event)
      end
      @timers.process
      sleep 0.01
    end
  end
  def redraw
    @state.redraw(@screen)
  end
  def process_event event
    case event
    when SDL::Event::Quit
      exit
    when SDL::Event::KeyDown
      rep_ms = @state.process_key(event.sym, KEY_DOWN)
      if rep_ms
        handler = @state.method(:process_key).to_proc.bind(event.sym, KEY_REPEAT)
        @timers.add(event.sym, rep_ms, handler)
      end
    when SDL::Event::KeyUp
      @timers.delete(event.sym)
    end
  end
end


BlockPuzzle.new.run
