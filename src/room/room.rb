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
    self.input = {:esc =>:exit, :down => :sd,:up =>:su,:left_mouse_button => :lmb}
    self.caption = "blastlevania room editor v0.0789"
    
    @parallax = Chingu::Parallax.create(:x=>0,:y=>0)
    @parallaxlayers = []
    #tile map
    
    @triggers
    @objects
    
    @lists = []
  end
  
  def sd; @lists.first.scroll_down;end
  def su; @lists.first.scroll_up;end
  def lmb; set_map @lists.first.get_entry_at [mouse_x,mouse_y];end
  #
  #add a layer to the parallax
  def add_parallax_layer options
    @parallax << {:image => options[:image],:damping => options[:damping],:z => options[:z]}
    @parallaxlayers << options
  end
  
  #
  # add a tile map to the room
  def set_map mapname
    return unless mapname
    #puts File.join(map_path,mapname)
    @map = TmxTileMap[mapname]
    puts @map
    @mapname = mapname
  end
  
  def draw
    super
    @map.draw if @map
    @lists.each{|l| l.draw}  
    fill_rect(Chingu::Rect.new(mouse_x-1,mouse_y-1,3,3),0xffff0000,500)
  end
  
  def list_maps
    path = map_path
    maps = Dir.entries(path).delete_if{|e| e.split('.').last != "tmx"}    
    add_list :entries => maps, :x =>510, :y=>40
  end
  
  def map_path
    File.join(ROOT,"media","maps") 
  end
  
  def add_list options
    l = List.new(:x => options[:x],:y => options[:y])#, :entries =>options[:entries])
    l.entries=options[:entries]
    @lists << l
  end
  
  def write_to_file filename
    f = File.new(filename)
  end
  
  #
  # A list of items to be displayed on screen
  #
  class List
    SPACING = 15
    MAX_ONSCREEN_ITEMS =20
    WIDTH = 100
    HEIGHT = 300
    def initialize options
      @entries= options[:entries] || []
      @visible_range = Range.new(0,MAX_ONSCREEN_ITEMS,true)
      @x,@y = options[:x],options[:y]
      @rect = Chingu::Rect.new(@x,@y,WIDTH,HEIGHT)
      @backg = options[:backg] || false
      
    end
    
    def entries= entries
      @entries.clear
      entries.each_with_index{|e,i| @entries << Chingu::Text.new(:x=>@x+5,:y=>@y+(i*SPACING), :text => e) }
    end
    
    def scroll_down
      if @visible_range.end < @entries.size
        @visible_range = Range.new(@visible_range.begin+1,@visible_range.end+1,true)       
        @entries.each_with_index{|e,i| e.y -= SPACING; @visible_range.member? i ? e.show! : e.hide!}
      end
    end
    
    def scroll_up
      if @visible_range.begin > 0
        @visible_range = Range.new(@visible_range.begin-1,@visible_range.end-1,true)       
        @entries.each_with_index{|e,i| e.y += SPACING; @visible_range.member? i ? e.show! : e.hide!}
      end
    end
    
    def get_entry_at position
      return unless (@x..@x+WIDTH).member? position[0] and (@y..@y+HEIGHT).member? position[1]
      index = ((position[1] - @y.to_f)/SPACING).floor + @visible_range.begin
      index < @visible_range.end and @entries[index] ? @entries[index].text  : nil
    end
    
    def draw
      $window.draw_rect(@rect,0xffff0000,100)
      $window.fill_rect(@rect,0xddff0000,50) if @backg
      
      @entries[@visible_range].each{|e| e.draw}
    end
    
  end
  
end
