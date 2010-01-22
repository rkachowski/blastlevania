class Character < Chingu::GameObject
  has_trait :collision_detection
  has_trait :bounding_box, :scale => 1, :debug =>true
  attr_reader :map, :speed, :weight
  def initialize options
    super
    
    @behaviours = [] #sequential behaviours
    @std_behaviours =[] #parallel behaviours that are always run
    @speed = 1
    @facing_right = true
  end
  
  def move position
    @x += position[0]*@speed
    @y += position[1]*@speed
    on_move position
  end
  
  def flip
    @facing_right = !@facing_right
    @factor_x = -@factor_x
  end
  
  def on_move position
    if position[0] > 0 and !@facing_right
      flip
    elsif position[0] < 0 and @facing_right
      flip
    end
  end
  
  def update
    super
    update_behaviours
  end
   
 def draw
   @image.draw_rot(@x, @y, @zorder, @angle, @center_x, @center_y, @factor_x, @factor_y, @color, @mode) if @visible
 end
   


  protected
  #
  # update the behaviours -
  def update_behaviours
    @std_behaviours.each{|sb| sb.update}
    return unless @behaviours.first #dont update if there are no behaviours
    
    if @behaviours.first.update #if the behaviour returns true then it's finished - delete it
      @behaviours.delete @behaviours.first
    end
    
  end
  
  #
  # add a standard behaviour - one that is never complete e.g. falling via force of gravity
  def add_std_behaviour behaviour_class, options
    options[:character ]=self
    b = behaviour_class.new(options)
    @std_behaviours << b if b.kind_of? Behaviour
  end
  
  #
  # add a behaviour - takes the class and options
  def add_behaviour behaviour_class, options
    options[:character ]=self
    b = behaviour_class.new(options)
    @behaviours << b if b.kind_of? Behaviour
  end
end

class TileCharacter < Character
  def initialize options
    super
    @map = options[:tilemap]
    fail("no map parameter given to #{self.class.to_s} construction") unless @map
    @weight = options[:weight] || 10
    
    add_std_behaviour FallByGravity, {}
    add_std_behaviour TileCollisionResponse, {}
  end
  
end
