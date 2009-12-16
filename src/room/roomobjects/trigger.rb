#trigger - does something when player collides with it, when a char collides with it
#or a time delay

class Trigger < Chingu::GameObject
  @@debug = true
  has_traits :collision_detection, :bounding_box, :debug=>true
  
  def initialize options
    super
    @text = Chingu::Text.new(:text=> self.class,:x=>@x,:y=>@y)
    
  end
  
  def draw
    super
    @text.draw if @@debug
  end
  
end
