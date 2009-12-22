#
# A room of blastlevania. 
# A room contains a tilemap, objects and a parallax 
class Room < Chingu::BasicGameObject
  include NamedResource
  attr_reader :map
  Room.autoload_dirs = [ File.join("media","rooms"),File.join(ROOT,"media","rooms")]
  
  def self.autoload(name)
    (path = find_file(name)) ? load(path) : nil
  end
    
  def self.load file
    file = File.new file
    doc = Nokogiri::XML file
      
    #get map
    m = doc.xpath('room/map')
    m = m.attribute('file').to_s
    m = TmxTileMap[m]
    
    #load parallax
    layers = []
    p = doc.xpath('room/parallax/*')
    p.to_a.each{|n| layers << n.attributes()}#get hash of attributes from parallax children and add to layers
    layers.each{|l| l.each{|k,v|  k == "image" ? l[k] = v.value : l[k] = v.value.to_i}} #clean each hash value into the format we want
    layers.map!{|l| j = {}; l.each{|k,v| j[k.to_sym] = v};j}#change keys to symbols
    p = Parallax.new(:rotation_center => :top_left,:z=>0)#create the parallax object
    layers.each{|l| p<< l}#add the layers    
     
    #load objects
    o = []
    obs = doc.xpath('room/objects/*')
    obs.to_a.each{|n| o << n.attributes()}
    o.each{|l| l.each{|k,v|  k == "type" ? l[k] = v.value : l[k] = v.value.to_i}}
    o.map!do |i| 
      #check that 
      fail("#{i['type']} is not a valid roomobject") unless RoomObjects.constants.include? i['type'].split('::').last.to_sym
      k = eval(i['type'])
      k.new(:x=>i['x'],:y=>i['y'])
    end
    
    Room.new(:parallax=>p,:map=>m,:objects=>o)
  end
  
  def initialize options
    super 
    @parallax = options[:parallax]
    @map = options[:map]
    @objects = options[:objects]
  end
  
  def scroll position
    #TODO check for map ends
    if @map
        @map.move [-position[0],0] 
        @parallax.camera_x+=position[0]
        @parallax.camera_y+=position[1]
        @objects.each{|o| o.move [-position[0],0]  }
    end
      
  end
  
  def draw
    super
    @parallax.draw
    @map.draw 
    @objects.each{|e| e.draw if e}
  end
  
  def update
    super
    @objects.each{|o| o.update}
    @parallax.update
  end
end
