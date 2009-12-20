#add image paths to autoload
def extend_image_paths
  Gosu::Image.autoload_dirs << File.join(ROOT,"media","maps","parallax")
  Gosu::Image.autoload_dirs << File.join(ROOT,"media","maps")
  Gosu::Image.autoload_dirs << File.join(ROOT,"media","roomobjects")
end

#
# add the ability to check which key is down
class Chingu::GameState
  def button_down(id)
      dispatch_button_down(id, self)
      @input_clients.each { |object| dispatch_button_down(id, object) } if @input_clients
      @downbutton = id
    end
    
  def button_up(id)
    dispatch_button_up(id, self)
    @input_clients.each { |object| dispatch_button_up(id, object) }   if @input_clients
    @downbutton = nil
  end
end

class Chingu::Window
  def button_down(id)
    @downbutton = id
      dispatch_button_down(id, self)
      @input_clients.each { |object| dispatch_button_down(id, object) }
      @game_state_manager.button_down(id)
      
  end
  def button_up(id)
    @downbutton = nil
      dispatch_button_up(id, self)
      @input_clients.each { |object| dispatch_button_up(id, object) }
      @game_state_manager.button_up(id)
      
  end  
end
  