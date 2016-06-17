function love.load()
  -- WINDOW SETUP
  height = 500--love.graphics.getHeight()
  width = 500--love.graphics.getWidth()
  love.window.setTitle("Break Out")
  love.window.setMode(width, height)

    --love.graphics.setNewFont(12)
  blockfont = love.graphics.setNewFont("yellow.otf",20)
  infofont = love.graphics.setNewFont("yellow.otf",18)
  titlefont = love.graphics.setNewFont("sunrise.otf",60)
  startTime = os.time()
  

  -- PADDLE SETUP
  paddle = {}
  function paddle.load()
    paddle.width = 70
    paddle.height = 20
    paddle.x = width/2 - paddle.width/2
    paddle.y = height - paddle.height
    paddle.speed = 400
    paddle.lives = 5
    paddle.points = 0
  end
  paddle.load()

  -- BLOCKS
  blocks = {}
  blocks.draw = {}

  -- LOAD BLOCKS
  function blocks.load()
    column = 0; row = 1
    while 5 >= row do
      block = {}
      block.width = width/10 - 5
      block.height = 20
      block.x = column * (block.width + 5)
      block.y = row * (block.height + 5)
      block.lighterblue = (5-row) * 255/2
      block.blue = (row-1) * 255/4
      table.insert(blocks.draw, block)
      column = column + 1
      if column == 10 then column = 0; row = row + 1 end
    end
  end
  blocks.load()

  -- BALL
  ball = {}
  function ball.load()
    ball.radius = 5
    ball.x = width/2
    ball.y = paddle.y - 200
    ball.speed = 200
    ball.direction = "d"
    ball.cooldown = 200
  end
  ball.load()

  -- CHECK TOP FOR BOUNCE
  function topbounce()
    if ball.direction == "ull" then ball.direction = "dll"
    elseif ball.direction == "ul" then ball.direction = "dl"
    elseif ball.direction == "uul" then ball.direction = "ddl"
    elseif ball.direction == "u" then ball.direction = "d"
    elseif ball.direction == "uur" then ball.direction = "ddr"
    elseif ball.direction == "ur" then ball.direction = "dr"
    elseif ball.direction == "urr" then ball.direction = "drr"
    end
  end

    --title
    --love.graphics.setFont(titlefont)
    --title = "Break Out"
    --love.graphics.print(title, 100, 200)

    --text display instructions
  
end


------ UPDATE ------

function love.update(dt)
  time = "time: ".. math.floor(os.time() - startTime)

  if ball.cooldown > 0 then ball.cooldown = ball.cooldown - 1 end

  -- Player movement
  if love.keyboard.isDown("right") and paddle.x <= (width - paddle.width) then
    paddle.x = paddle.x + (dt * paddle.speed)
  elseif love.keyboard.isDown("left") and paddle.x >= 0 then
    paddle.x = paddle.x - (dt * paddle.speed)
  elseif love.keyboard.isDown("r") then
    ball.load()
  end

  --title going away
  if key == 'q' then
        love.event.push('quit')
    elseif state == "ready" then
        state = "playing"
        text = ""
        titletext = ""
    end

  -- Hitbox for paddle
  if ball.y >= paddle.y and ball.y <= height and ball.x >= paddle.x and
    ball.x <= (paddle.x + paddle.width) then
    if ball.x >= paddle.x and ball.x < (paddle.x + 10) then
      ball.direction = "ull"
    elseif ball.x >= (paddle.x + 10) and ball.x < (paddle.x + 20) then
      ball.direction = "ul"
    elseif ball.x >= (paddle.x + 20) and ball.x < (paddle.x + 30) then
      ball.direction = "uul"
    elseif ball.x >= (paddle.x + 30) and ball.x < (paddle.x + 40) then
      ball.direction = "u"
    elseif ball.x >= (paddle.x + 40) and ball.x < (paddle.x + 50) then
      ball.direction = "uur"
    elseif ball.x >= (paddle.x + 50) and ball.x < (paddle.x + 60) then
      ball.direction = "ur"
    elseif ball.x >= (paddle.x + 60) and ball.x < (paddle.x + 70) then
      ball.direction = "urr"
    end
  end


  -- Hitbox for blocks
  for i,v in ipairs(blocks.draw) do
    if ball.y <= (v.y + v.height) and ball.y >= v.y then
      if ball.x <= (v.x + v.width) and ball.x >= v.x then
        topbounce()
        table.remove(blocks.draw, i)
        paddle.points = paddle.points + 1
      end
    end
  end

  -- Bounces ball off walls
  if (ball.x <= 0) or (ball.x >= width) then
    if ball.direction == "uur" then ball.direction = "uul"
    elseif ball.direction == "ur" then ball.direction = "ul"
    elseif ball.direction == "urr" then ball.direction = "ull"
    elseif ball.direction == "drr" then ball.direction = "dll"
    elseif ball.direction == "dr" then ball.direction = "dl"
    elseif ball.direction == "ddr" then ball.direction = "ddl"
    elseif ball.direction == "ddl" then ball.direction = "ddr"
    elseif ball.direction == "dl" then ball.direction = "dr"
    elseif ball.direction == "dll" then ball.direction = "drr"
    elseif ball.direction == "ull" then ball.direction = "urr"
    elseif ball.direction == "ul" then ball.direction = "ur"
    elseif ball.direction == "uul" then ball.direction = "uur"
    end
  end

  -- Bounce ball off ceiling
  if ball.y <= 0 then topbounce() end

  -- Move ball
  if ball.cooldown == 0 then
    if ball.direction == "u" then
      ball.y = ball.y - 2 * (dt * ball.speed)
    elseif ball.direction == "uur" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x + 1 * (dt * ball.speed)
    elseif ball.direction == "ur" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "urr" then
      ball.y = ball.y - 1 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "drr" then
      ball.y = ball.y + 1 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "dr" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x + 2 * (dt * ball.speed)
    elseif ball.direction == "ddr" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x + 1 * (dt * ball.speed)
    elseif ball.direction == "d" then
      ball.y = ball.y + 2 * (dt * ball.speed)
    elseif ball.direction == "ddl" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x - 1 * (dt * ball.speed)
    elseif ball.direction == "dl" then
      ball.y = ball.y + 2 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "dll" then
      ball.y = ball.y + 1 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "ull" then
      ball.y = ball.y - 1 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "ul" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x - 2 * (dt * ball.speed)
    elseif ball.direction == "uul" then
      ball.y = ball.y - 2 * (dt * ball.speed)
      ball.x = ball.x - 1 * (dt * ball.speed)
    end
  end

  if ball.y >= height then
    paddle.lives = paddle.lives - 1; ball.load()
  end

  if paddle.lives < 0 then
    love.graphics.print("GAME OVER", width/2, height/2)
    love.load()
  end

end



------ DRAW ------

function love.draw()
  -- draq text!!
  if ball.cooldown > 0 then
  --draw text!!
    love.graphics.setFont(titlefont)
    love.graphics.setColor(255,255,255)
    titletext = "Break Out"
    love.graphics.print(titletext,138,252)
    love.graphics.setFont(infofont)
    text = "Get Ready! \n \n 1. Use arrow keys to move. \n \n 2. To restart, press 'r' "
    love.graphics.print(text,148,330)

    --love.graphics.print("Get ready!", width/2, height/2)
  end

  -- Points/Lives/Time
  love.graphics.setFont(blockfont)
  love.graphics.print(time,width*8/9,10)
  love.graphics.print("Lives: " .. paddle.lives, width*8/20, 10)
  love.graphics.print("Points: " .. paddle.points, width*8/12, 10)
  
  -- Draw paddle
  love.graphics.setColor(238,162,173)
  love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height - 10)

  -- Draw blocks
  love.graphics.setColor(255, 0, 0)
  iter = 0
  for _,v in pairs(blocks.draw) do
    love.graphics.setColor(255,v.blue,v.lighterblue,255)
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end

  -- Draw ball
  love.graphics.setColor(255, 255, 255)
  love.graphics.circle("fill", ball.x, ball.y, ball.radius)
end