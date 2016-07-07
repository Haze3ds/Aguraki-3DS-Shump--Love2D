--playerImg = nil -- this is just for storage used to be this { x = 10, y = 120, speed = 100, img = nil }
player = {}
player.x = 10
player.y = 120
player.speed = 10 


--Scrolling
	windowx = love.graphics.getWidth()
	
	bg1 = {}
	bg1.img = love.graphics.newImage("back1.png")
	bg1.x = 700
	bg1.width = bg1.img:getWidth()

	bg2 = {}
	bg2.img = love.graphics.newImage("back2.png")
	bg2.x = -windowx
	bg2.width = bg2.img:getWidth()
	
	speed = 75

--Bullet Stuff
-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2 
canShootTimer = canShootTimerMax

-- Image Storage
bulletImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated


--Enemy Stuff--------
--More timers
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
  
-- More images
enemyImg = nil -- Like other images we'll pull this in during out love.load function
  
-- More storage
enemies = {} -- array of current enemies on screen




-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
isAlive = true
score = 0

--MOUSE STUFF
function player.move_to(_x, _y)
   dx = _x - player.x
   dy = _y - player.y
   length = math.sqrt(dx*dx+dy*dy);

   dx = (dx/length)
   dy = (dy/length)

   player.x = (player.x + dx * player.speed)
   player.y = (player.y + dy * player.speed)
   end


function love.load(arg)
love.graphics.setScreen('top')
player.img = love.graphics.newImage('plane.png')
redplayer = love.graphics.newImage('redplayer.png')
leftred = love.graphics.newImage('redleft.png')
blueplayer = love.graphics.newImage('plane.png')
leftblue = love.graphics.newImage('leftblue.png')
rightblue = love.graphics.newImage('rightblue.png')
background = love.graphics.newImage('background.png')
bottombg = love.graphics.newImage('bottombg.png')
won = love.graphics.newImage('won.png')
    
	
	bulletImg = love.graphics.newImage('bullet.png')
	enemyImg = love.graphics.newImage('enemy.png')
end




-- Updating
function love.update(dt)

--BG SCROLLINg
bg1.x = bg1.x - speed * dt
	bg2.x = bg2.x - speed * dt

	if bg1.x < windowx then
		bg1.x = bg2.x + bg1.width
	end
	if bg2.x < windowx then
		bg2.x = bg1.x - bg2.width
	end

	
-- Player Shots Time out how far apart our shots can be. PLayer Shots
canShootTimer = canShootTimer - (1 * dt)
if canShootTimer < 0 then
  canShoot = true
end
	
	
	-- PLayer Shooting
	if love.keyboard.isDown('cpaddown') and canShoot then
	-- Create some bullets
	nnewBullet = { x = Player.x + (Player.sprite:getWidth()/2) - (bulletSprite:getWidth()/2), y = Player.y, img = bulletImg }
	table.insert(bullets, newBullet)
	canShoot = false
	canShootTimer = canShootTimerMax
end


-- update the positions of bullets
for i, bullet in ipairs(bullets) do
	bullet.x = bullet.x - (350 * dt)

  	if bullet.y < 0 then -- remove bullets when they pass off the screen
		table.remove(bullets, i)
	end
end

-- Time out enemy creation
createEnemyTimer = createEnemyTimer - (1 * dt)
if createEnemyTimer < 0 then
	createEnemyTimer = createEnemyTimerMax

	-- Create an enemy
	randomNumber = math.random(10, love.graphics.getWidth() - 10)
	newEnemy = { x = 410, y = randomNumber, img = enemyImg }
	table.insert(enemies, newEnemy)
end
-- update the positions of enemies
for i, enemy in ipairs(enemies) do
	enemy.x = enemy.x - (200 * dt)

	if enemy.x > 850 then -- remove enemies when they pass off the screen
		table.remove(enemies, i)
	end
end

-- run our collision detection
-- Since there will be fewer enemies on screen than bullets we'll loop them first
-- Also, we need to see if the enemies hit our player
for i, enemy in ipairs(enemies) do
	for j, bullet in ipairs(bullets) do
		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
			table.remove(bullets, j)
			table.remove(enemies, i)
			score = score + 1
		end
	end

	if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
	and isAlive then
		table.remove(enemies, i)
		isAlive = false
	end
end

--Restarting after death
if not isAlive and love.keyboard.isDown('up') then
	-- remove all our bullets and enemies from screen
	bullets = {}
	enemies = {}

	-- reset timers
	canShootTimer = canShootTimerMax
	createEnemyTimer = createEnemyTimerMax

	-- move player back to default position
	player.x = 10
	player.y = 120

	-- reset our game state
	score = 0
	isAlive = true
end

--Input
if love.keyboard.isDown('left') then
	if player.y > 0 then -- binds us to the map
		player.y = player.y - (player.speed*dt)
		player.img = leftblue
	end
elseif love.keyboard.isDown('right') then
	if player.y < 140  then
		player.y = player.y + (player.speed*dt)
		player.img = rightblue
	end
end
-- Vertical movement
if love.keyboard.isDown('up') then
	if player.x > 0 then
		player.x = player.x - (player.speed*dt)
	end
elseif love.keyboard.isDown('down') then
	if player.x < 410 then
		player.x = player.x + (player.speed*dt)
		player.img = blueplayer
	end
end

--Colors Swicth of player RED BLUE
if love.keyboard.isDown('cpadright') then
player.img = redplayer
elseif love.keyboard.isDown('cpadleft') then
player.img = blueplayer
end







end





function love.draw(dt)
love.graphics.setScreen('bottom')
love.graphics.draw(bottombg, 0, 0)
love.graphics.setScreen('top')
love.graphics.draw(background, 0, 0)
love.graphics.draw(bg1.img, bg1.x, 0)
	love.graphics.draw(bg2.img, bg2.x, 0)

if isAlive then
love.graphics.draw(player.img, player.x, player.y)
else
	love.graphics.print("Press 'Dpad Up' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
end



--Player Bullets
for i, bullet in ipairs(bullets) do
  love.graphics.draw(bullet.img, bullet.x, bullet.y)
end
--Enemies Draw
for i, enemy in ipairs(enemies) do
	love.graphics.draw(enemy.img, enemy.x, enemy.y)
end
--Score Display
love.graphics.setColor(255, 255, 255)
love.graphics.print("SCORE: " .. tostring(score), 250, 5)

--Still Updating MOuse MOvement
if love.mouse.isDown('l') then --Check every frame if left mouse button is down
   local mousex, mousey = love.mouse.getPosition() --Get mousex and mousey because it's not given to us
   player.move_to(mousex, mousey)
end

--You won
if score > 10 then
--love.graphics.set3D(true)
--love.graphics.setDepth(1)
love.graphics.draw(won, 0, 0)
--love.graphics.setDepth(3)
love.graphics.draw(blueplayer, 200, 120)
--love.graphics.set3D(false)
isAlive = false
end





end
