# Background

class Background < Processing::App

  def setup
    size 1500, 800
    background 44, 55, 66
    no_stroke
    smooth
    
    @back_colors = [
      [44, 115, 156],
      [50, 61, 113]
    ]

    @colors = [
      [58, 99, 110],
      [52, 75, 121],
      [44, 111, 128]
    ]
    
    create_background
    create_circles
    save "background.png"
  end
  
  def create_background
    4.times do
      img = create_graphics width, height, P2D
      img.begin_draw
      img.no_stroke
      3.times do
        img.fill *@back_colors[rand @back_colors.length]
        img.ellipse rand(width), rand(height), 300, 300
      end
      img.end_draw
      tint 255, 255, 255, 150
      image img, 0, 0
    end
    tint 255, 255, 255, 255
  2.times {filter(BLUR, 8)}
  end

  def create_circles
    30.times do
      clr = @colors[rand @colors.length]
      sz = rand(200) + 50
      x = rand(width)
      y = rand(height)
      fill *clr
      ellipse x, y, sz, sz
    end 
    
    255.times do |i|
      fill 44, 55, 66, 255 - i
      rect i, 0, 1, height
    end
    
    255.times do |i|
      fill 44, 55, 66, 255 - i
      rect width - i, 0, 1, height
    end

    255.times do |i|
      fill 44, 55, 66, 255 - i
      rect 0, height - i, width, 1
    end
    3.times {filter(BLUR, 3)}
  end

  def draw
    
  end
  
end

Background.new :title => "Background"
