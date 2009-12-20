module RoomObjects
  
  
  def create_objects
    #get list of files
    list = Dir.entries(File.join(ROOT,"media","roomobjects"))
  end
  
  class RoomObject < Chingu::GameObject
    @@debug = false
    
    def self.debug
      @@debug = true
    end
    
    def initialize options
      super
      @name = self.class.to_s.split('::').last
      @label = Chingu::Text.new(:text => @name,:x => @x,:y=>@y)
      @label.x = @x-@label.width/2
      
      @image = Gosu::Image["#{self.class.to_s.split('::').last}.png"].retrofy
      
    end
         
    def move direction
      @x += direction[0]
      @y += direction[1]
      update_labels
    end
    
    def draw
      super
      @label.draw if @@debug
    end
    
    def update_labels
      if @@debug
        @label.x = @x-@label.width/2
        @label.y = @y
      end
    end
    
    def update
      super
      update_labels
    end
  end
end
