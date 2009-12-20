require 'chingu'
require 'opengl'
require 'nokogiri'
include Chingu
require_all(File.join(ROOT, 'src')) 

class TestRoomLoad < Chingu::Window
  def initialize 
    super(640,480,false)
    extend_image_paths
    self.input = {:esc =>:exit}
    @r = Room["test two.bsm"]
  end
  
  def draw
    super
    @r.draw
  end
  
end

 TestRoomLoad.new.show

