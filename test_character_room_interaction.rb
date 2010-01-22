require 'chingu'
#require 'gosu'
require 'opengl'
require 'nokogiri'
include Chingu
require_all(File.join(ROOT, 'src')) 

class TestWindow < Chingu::Window
  MOVE_SPEED = 5
  def initialize 
    super(640,480,false)
    self.input = {:esc=>:exit,:holding_up=> :move_up,:holding_down=> :move_down,:holding_left=> :move_left,:holding_right=> :move_right}
    extend_image_paths
    @room = Room["test two.bsm"]
    @char = Soldier.create(:x=>200,:y=>200, :tilemap=>@room.map)
  end
  
  def move_up; @char.move [0,-MOVE_SPEED];end
  def move_down; @char.move [0,MOVE_SPEED];end
  def move_left; @char.move [-MOVE_SPEED,0];end
  def move_right; @char.move [MOVE_SPEED,0];end
  
  def draw
    super
    @room.draw
    #@char.draw
  end
  
  def update
    super
    @room.update
    self.caption = "character / room interaction test - fps = #{self.fps}"
  end
  
end

TestWindow.new.show