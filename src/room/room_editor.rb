
class RoomEditor < Chingu::Window
  
  SCROLL_BUFFER = 15
  def initialize
    super(640,480,false)
    self.input = {:esc =>:exit, :down => :sd,:up =>:su,:left_mouse_button => :left_mouse_button ,:q =>:z_up,:a=>:z_down,:w=>:damp_up,
    :s=>:damp_down,:e=>:color_up,:d=>:color_down}
    self.caption = "blastlevania room editor v0.0989"
    
    @parallax = Chingu::Parallax.new(:rotation_center => :top_left,:z=>0)
    @parallaxlayers = []
    @p_options = {:z=>-5,:damping =>1,:color =>0xffffffff}
    
    #tile map
    
    @triggers
    @objects
    
    @lists = {}
    extend_image_paths
    add_buttons
  end
  
  def sd; @lists[:active].scroll_down;end
  def su; @lists[:active].scroll_up;end
  def z_up;@p_options[:z]+=1;end
  def z_down;@p_options[:z]-=1;end
  def damp_up;@p_options[:damping]+=1;end
  def damp_down;@p_options[:damping]-=1;end
  def color_up;@p_options[:color]+=0x00111111 if @p_options[:color] < 0xffffffff;end
  def color_down;@p_options[:color]-=0x00111111 if @p_options[:color] > 0xff000000;end
  
  #
  # add buttons to switch edit modes
  def add_buttons
    @p_button = Chingu::Rect.new(510,5,20,20)
    Chingu::Text.create(:text=>"p",:x=>513,:y=>5,:factor_x =>1.5)
    @m_button = Chingu::Rect.new(540,5,20,20)
    Chingu::Text.create(:text=>"m",:x=>540,:y=>5,:factor_x =>1.5)
  end
  
  def left_mouse_button 
    #check for button click
    @lists[:active] = @lists['maps'] if @m_button.collide_point? mouse_x, mouse_y
    @lists[:active] = @lists['parallax'] if @p_button.collide_point? mouse_x, mouse_y
      
    case @lists[:active]
      when @lists['parallax']
        
        if not @p_selection
          @p_image = @lists[:active].get_entry_at [mouse_x,mouse_y]
          @p_selection = Gosu::Image[@p_image].retrofy if @p_image
          puts @p_selection
        else
          add_parallax_layer :image=>@p_image,:damping=>@p_options[:damping],:z=>@p_options[:z], :color=>@p_options[:color]
          @p_selection = nil
          @p_image = nil
        end
        
      when @lists['maps']
        
        set_map @lists[:active].get_entry_at [mouse_x,mouse_y]
        
    end
  end
  
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
    @map = nil
    @map = TmxTileMap[mapname]
    puts @map
    @mapname = mapname
  end
  
  def scroll_room
    if mouse_x >= $window.width-SCROLL_BUFFER
      if @map and @map.tile_exists_at? [ $window.width+1,0] 
        @map.move [-4,0] 
        @parallax.camera_x -=4
      end
      
    elsif mouse_x <= 0+SCROLL_BUFFER
      if @map and @map.tile_exists_at? [ 0,0] 
        @map.move [4,0] 
        @parallax.camera_x +=4
      end
      
    end
    ##TODO allow scrolling on y if possible   
  end
  
  def update
    super
    scroll_room
    
    case @lists[:active]
      when @lists['maps']
      
      when @lists['parallax']
        
        #update label values
        values = @p_options.values
        values[2] = "0x%x"%values[2]
        @p_options_labels.each_with_index do |l,i|
          if i%2 >0
            l.text = values[((i+1)/2)-1]
          end
        end
    end
    
  end

  
  def draw
    
    super
    @lists[:active].draw
    
    case @lists[:active]
      when @lists['parallax']
      
        #draw a parallax selection if one exists
        @p_selection.draw(mouse_x-@p_selection.width/2,mouse_y-@p_selection.height/2,0,1,1,@p_options[:color]) if @p_selection
        
        #draw z ,color and damping options
        @p_options_labels.each{|t| t.draw}
        
      when @lists['maps']
      
    end
    @parallax.draw
    @map.draw if @map
    
    
    #draw buttons
    draw_rect(@p_button,0xffff0000,500)
    draw_rect(@m_button,0xffff0000,500)
   #draw mouse
    fill_rect(Chingu::Rect.new(mouse_x-1,mouse_y-1,3,3),0xffff0000,500)
    
    
  end
  #
  # create a list for parallax layers
  def list_p_layers
    path = p_path
    paral = Dir.entries(path).delete_if{|e| e.split('_').first != "p"}    
    add_list :entries => paral, :x =>510, :y=>40, :name =>"parallax"
    @p_options_labels = []
    
    #create labels for p_options
    i =0
    spac = 0
    @p_options.each_pair do |k,v| 
      @p_options_labels << Chingu::Text.new(:text=>k,:x=>@lists[:active].x + spac*9,:y=>@lists[:active].y+List.const_get('HEIGHT'))
      unless k ==:color
      @p_options_labels<<Chingu::Text.new(:text=>v,:x=>@lists[:active].x + spac*30,:y=>@lists[:active].y+List.const_get('HEIGHT')+15)
      else
        @p_options_labels<< Chingu::Text.new(:text=>"%x"%v,:x=>@lists[:active].x + i*32,:y=>@lists[:active].y+List.const_get('HEIGHT')+15)
      end
      spac = k.size
      i+=1
    end
  end
  #
  # create a list for the maps
  def list_maps
    path = map_path
    maps = Dir.entries(path).delete_if{|e| e.split('.').last != "tmx"}    
    add_list :entries => maps, :x =>510, :y=>40, :name =>"maps"
  end
  
  def map_path
    File.join(ROOT,"media","maps") 
  end
  
  def p_path
    File.join(ROOT,"media","maps","parallax") 
  end
  
  #
  # create a new list and make it active
  def add_list options
    l = List.new(:x => options[:x],:y => options[:y],:name =>options[:name])
    l.entries=options[:entries]
    @lists[options[:name]] = l
    @lists[:active] = l
  end
  
  #
  # write the room info to a file 'filename'
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
    attr_accessor :x,:y
    def initialize options
      @entries= options[:entries] || []
      @visible_range = Range.new(0,MAX_ONSCREEN_ITEMS,true)
      @x,@y = options[:x],options[:y]
      @rect = Chingu::Rect.new(@x,@y,WIDTH,HEIGHT)
      @backg = options[:backg] || false
      name = options[:name] || "noname!"
      
      @name = Chingu::Text.new(:x=>@x,:y=>@y-13,:text=>name,:factor_x =>1.5)
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
      @name.draw
      @entries[@visible_range].each{|e| e.draw}
    end
    
  end
  
end
