require 'chingu'
#require 'gosu'
require 'opengl'
require 'nokogiri'

require_all(File.join(ROOT, 'src')) 

 j= RoomEditor.new
#j.add_list :x=>200,:y=>20,:entries =>['one','2','3','4','one','2','3','4','one','2','3','4','one','2','3','4','one','2','3','4','one','2','3','4']

j.list_maps
j.list_p_layers
j.list_objects
j.show
