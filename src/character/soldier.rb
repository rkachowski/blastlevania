class Soldier < TileCharacter
  def initialize options
    options[:scale]=4
    super
    @animations = Animation.new(:file=>"#{self.class.to_s}.png", :width=>16,:height=>16)
    animations = {}
    animations[:walking] = @animations[0..5]
    @animation = animations[:walking]
    @image = @animation.next
    
  end
  
  def on_move position
    @image = @animation.next
    super
  end
  
  def update
    super
    
  end
  
end
