#add image paths to autoload
def extend_image_paths
  Gosu::Image.autoload_dirs << File.join(ROOT,"media","maps","parallax")
  Gosu::Image.autoload_dirs << File.join(ROOT,"media","maps")
  Gosu::Image.autoload_dirs << File.join(ROOT,"media","roomobjects")
end