require 'chingu'
require 'opengl'
require 'nokogiri'
include Chingu
require_all(File.join(ROOT, 'src')) 

class TestRoomLoad < Chingu::Window
  def initialize 
    super(640,480,false)
    extend_image_paths
     self.input = {:esc =>:exit, :holding_left => :scr }
    @r = Room["test two.bsm"]
  end
  
  def scr 
    @r.scroll [4,0]
  end
  
  def draw
    super
    @r.draw
  end
  
  def update
    super
    @r.update
  end
  
end

 TestRoomLoad.new.show

