#candlesticks and the like
#breaks on hit, releases a pickup 
module RoomObjects
  class Breakable < RoomObject    
    attr_reader :name
    has_traits :collision_detection, :bounding_box
    def initialize options
      super
      @hp = 1
      
    end
    
    def on_death command
      @on_death = Proc.new{eval(command)} # this sucks - improve it
    end
    
    def get_hit
      return if @hp < 1
      @hp-=1 
      
      if @hp == 0
        @on_death.call if @on_death
        die
      end
    end
    
    def die
      #play sfx, do explosion - w/e
      puts "#{self.class} died at #{@x} x, #{@y} y"
      self.destroy
    end
    
  end
  
  class Lamp1 < Breakable
  end
  
end

