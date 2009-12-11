      require 'chingu'
      require 'gosu'
      require 'opengl'
      require 'nokogiri'
      
       require_all(File.join(ROOT, 'src')) 
      
      class Game < Chingu::Window
        def initialize
          super(640,480,false)
          self.input = {:esc =>:exit}
        end
      end
      
      
      Game.new.show 
