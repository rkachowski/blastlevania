#
# A room of blastlevania. 
# A room contains a tilemap, triggers, objects and a parallax 
class Room < Chingu::BasicGameObject
  def initialize options
    super 
    #background and foreground
    @parallax
    #tile map
    @map
    @triggers
    @objects
    
    #@camera ? 
  end
  
  def draw
    super
    #draw map
    #draw parallax
  end
  
  def update
    super
    #check all trigger collisions
    #check all object collisions
  end
  
  def load_from_file; end
  
end

class RoomEditor < Chingu::Window
  def initialize
    super(640,480,false)
    self.input = {:esc =>:exit}
    self.caption = "blastlevania room editor v0.0007"
  end
  
  def write_to_file;end
end
