--Sorry for the mess
--enemys= Main shooting enemies
--Redenemys = Blue falling bullets on bottom half
--Nextenemy = Red Bullets falling on top half

-- To do
-- Main Enemys Scale up and down in size down the x axis
--Enemy shoots a patterns of multiple bullets
--Turrets/ other enemy types
--Boss

debug = true
require("AnAL")
--Player Table
Player = { x = 20, y = 120, speed = 3, sprite = nil, HP = 10}
isAlive =  false
score = 0
--
Player.state = 'Red'
Player.state = 'Blue'
--For Player Aiming Shoots
local dir = { x = 0, y = 0 }





------
if Player.HP <= 0 then
	isAlive = false
end


	
--MOUSE STUFF
function Player.move_to(_x, _y)
   dx = _x - Player.x
   dy = _y - Player.y
   length = math.sqrt(dx*dx+dy*dy);

   dx = (dx/length)
   dy = (dy/length)

   Player.x = (Player.x + dx * Player.speed)
   Player.y = (Player.y + dy * Player.speed)
   end
------
----Bullet Stuff
-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.1
canShootTimer = canShootTimerMax
---- Image Storage
bulletSprite = nil


-- Entity Storage
bullets = {}

 
----Enemy Stuff--------
--More timers
createEnemyTimerMax = .5
createEnemyTimer = createEnemyTimerMax
--Red Enemy timer
createRedEnemyTimerMax = .2
createRedEnemyTimer = createRedEnemyTimerMax
--Next enemy timer
--
createNextEnemyTimerMax = .1
createNextEnemyTimer = createNextEnemyTimerMax
--Nexter enemy timer
--
createNexterEnemyTimerMax = .3
createNexterEnemyTimer = createNextEnemyTimerMax
-- More storage
enemies = {}-- array of current enemies on screen
--Red Enemies
Redenemies = {} 
--3rd Enemy
Nextenemies = {}
--4thd Enemy
Nexterenemies = {}
-- More images
enemySprite = nil
--2nd enemy!!
RedenemySprite =nil 
--3rd enemy
NextenemySprite =nil 
--4th enemy
NexterenemySprite =nil 
---Regular enemy shot
enemyBulletSprite = nil
enemyBullets = {}

canShootEnemy = true
canShootEnemyTimerMax = 0.8
canShootEnemyTimer = canShootEnemyTimerMax
--2nd enemy shot
RedenemyBulletSprite = nil
RedenemyBullets = {}
--RedcanShoot
RedcanShootEnemy = true
RedcanShootEnemyTimerMax = 0.3
RedcanShootEnemyTimer = RedcanShootEnemyTimerMax

--BG Scrolling
--posX = 0 -- initializing posX
--imageWidth = 1024 -- this is our image width
function love.load(arg)
--Player Melee
 local img  = love.graphics.newImage("PlayerAni.png")
 
   -- Create animation.
   anim = newAnimation(img, 40, 40, 0.1, 0)

--Lets draw to the Top Screen
love.graphics.setScreen('top')
--
RedPlayer = love.graphics.newImage('RedPlayer.png')
BluePlayer = love.graphics.newImage('Plane.png')
Player.sprite = love.graphics.newImage('Plane.png')
enemyBulletSprite = love.graphics.newImage('EnemyBullet.png')
bulletSprite = love.graphics.newImage('Bullet.png')
enemySprite = love.graphics.newImage('Enemy.png')
Background = love.graphics.newImage('Background.png')
BottomBG = love.graphics.newImage('bottombg.png')
WonTop = love.graphics.newImage('WonTop.png')
WonBottom = love.graphics.newImage('WonBottom2.png')

--2nd enemy 
RedenemySprite =  love.graphics.newImage('BulletDown.png')
RedenemyBulletSprite = love.graphics.newImage('BulletDown.png')
NextenemySprite = love.graphics.newImage('EnemyBulletDown.png')
NexterenemySprite = love.graphics.newImage('BulletDown.png')

--Scrolling BG
background_Image = love.graphics.newImage("back1.png")


end

--
function love.mousepressed(x, y, button)
	if Player.state == 'Blue'  then -- the primary button
		Player.state = 'Red'
	elseif 
Player.state == 'Red' then
Player.state = 'Blue'
end
end






function love.draw(dt)----------------------------
--

love.graphics.setScreen('bottom')
love.graphics.draw(BottomBG, 0, 0)
love.graphics.setScreen('top')
love.graphics.draw(Background, 0, 0)
--printBackground()
----
-----------Switch PLayer State
		if love.keyboard.isDown('y') then
		Player.state = 'Red'
		end
		if love.keyboard.isDown('y')  then
		Player.state = 'Blue'
		end
		

if  Player.state == 'Blue' then
Player.sprite = BluePlayer
end

--Starting Menu	
	
if Player.HP <= 0 then
	isAlive = false
end



	
	
   if isAlive then
	for i, enemyBullet in ipairs(enemyBullets) do
		love.graphics.draw(enemyBullet.sprite, enemyBullet.x, enemyBullet.y)
	end
	--
	--
	love.graphics.draw(Player.sprite, Player.x, Player.y)
	--
	for i, bullet in ipairs(bullets) do
		love.graphics.draw(bullet.sprite, bullet.x, bullet.y)
	end
	--
	for i, enemy in ipairs(enemies) do
		love.graphics.draw(enemy.sprite, enemy.x, enemy.y)
	end
	
	-- 2nd Enemy
	for i, RedenemyBullet in ipairs(RedenemyBullets) do
		love.graphics.draw(RedenemyBullet.sprite, RedenemyBullet.x, RedenemyBullet.y)
	end
	
	for i, Redenemy in ipairs(Redenemies) do
		love.graphics.draw(Redenemy.sprite, Redenemy.x, Redenemy.y)
	end
	--3rd enemy
	for i, Nextenemy in ipairs(Nextenemies) do
		love.graphics.draw(Nextenemy.sprite, Nextenemy.x, Nextenemy.y)
	end
	--4th enemy
	for i, Nexterenemy in ipairs(Nexterenemies) do
		love.graphics.draw(Nexterenemy.sprite, Nexterenemy.x, Nexterenemy.y)
	end
	--
	love.graphics.print("Score: " .. score, love.graphics:getWidth()-80, 15)
	love.graphics.print("Lives: " .. Player.HP, 10, 15)
else
	--love.graphics.print("You Have Lost", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
	love.graphics.print(": " .. score, love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-30)
	love.graphics.draw(WonTop, 0, 0)
	love.graphics.setScreen('bottom')
love.graphics.draw(WonBottom, 0, 0)
end
----Still Updating MOuse MOvement
if love.mouse.isDown('l') then --Check every frame if left mouse button is down
   local mousex, mousey = love.mouse.getPosition() --Get mousex and mousey because it's not given to us
   Player.move_to(mousex, mousey)
end

 --PLayer Melee
		if love.keyboard.isDown('cpadright') then
		 anim:draw(Player.x, Player.y - 3 )
end

 



end


--

function love.update(dt)
--PlayerMelee
 anim:update(dt)



if Player.state == 'Red' then
Player.sprite = RedPlayer
end
--BG Scrolling
--function printBackground()
   -- love.graphics.draw(background_Image, posX, 0) -- this is the original image
    --love.graphics.draw(background_Image, posX + imageWidth, 0) -- this is the copy that we draw to the original's right
   
   -- posX = posX - 50 * dt -- scrolling the posX to the left

    --if posX <= imageWidth then posX = 0 end
--end

	
-- Time out enemy creation
	createEnemyTimer = createEnemyTimer - (1*dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax
			-- Create an enemy
		rand = math.random(10, love.graphics.getHeight() - 10 )
		newEnemy = { x = 410, y = rand, sprite = enemySprite }
    newEnemy.canShoot = true
    newEnemy.timer = 0
		table.insert(enemies, newEnemy)
	end
		-- 2nd enemy timer
		createRedEnemyTimer = createRedEnemyTimer - (1*dt)
	if createRedEnemyTimer < 0 then
		createRedEnemyTimer = createRedEnemyTimerMax

--2nd enemy creation
-- Create an enemy
		rand = math.random(0, love.graphics.getHeight() - 20 )
		newRedEnemy = { x = rand, y = -10, sprite = RedenemySprite }
    newRedEnemy.canShoot = true
    newRedEnemy.timer = 0
		table.insert(Redenemies, newRedEnemy)
	end
	--3rd enemy creation
-- Create an enemy
createNextEnemyTimer = createNextEnemyTimer - (1*dt)
	if createNextEnemyTimer < 0 then
		createNextEnemyTimer = createNextEnemyTimerMax
		
		rand = math.random(190, love.graphics.getHeight() + 190 )
		newNextEnemy = { x = rand, y = -10, sprite = NextenemySprite }
    --newNextEnemy.canShoot = true
    newNextEnemy.timer = 0
		table.insert(Nextenemies, newNextEnemy)
	end
		--4th enemy creation
-- Create an enemy
createNexterEnemyTimer = createNexterEnemyTimer - (1*dt)
	if createNexterEnemyTimer < 0 then
		createNexterEnemyTimer = createNexterEnemyTimerMax
		
		rand = math.random(190, love.graphics.getHeight() + 190 )
		newNexterEnemy = { x = rand, y = -10, sprite = NexterenemySprite }
    --newNextEnemy.canShoot = true
    newNexterEnemy.timer = 0
		table.insert(Nexterenemies, newNexterEnemy)
	end
	
	
	
if Player.HP <= 0 then
	isAlive = false
end
if isAlive == true then

--Check Shooting Enemys
	for i, enemy in ipairs(enemies) do
    
   -- Update Shooting interval timer ---
    enemy.timer = enemy.timer - (1*dt)
    if enemy.timer < 0 then
      enemy.canShoot = true
    end
	
	-- Spawn Bullet -- For i enemies 
	for i, enemy in ipairs(enemies) do
		if enemy.canShoot then
			newEnemyBullet = { x = enemy.x + enemy.sprite:getWidth()/2 - enemyBulletSprite:getWidth()/2, y = enemy.y + enemy.sprite:getHeight() - enemyBulletSprite:getHeight(), sprite = enemyBulletSprite}
			table.insert(enemyBullets, newEnemyBullet)
			enemy.canShoot = false
      enemy.timer = canShootEnemyTimerMax
		end
	 -- Check for Collisions ---- run our collision detection enemy and player bullet
		for j, bullet in ipairs(bullets) do
			if enemy.HP == nil then
				enemy.HP = 2
			end
			if CheckCollision(enemy.x, enemy.y, enemy.sprite:getWidth(), enemy.sprite:getHeight(), bullet.x, bullet.y, bullet.sprite:getWidth(), bullet.sprite:getHeight()) then
				enemy.HP = enemy.HP - 1
				table.remove(bullets, j)
				if enemy.HP == 0 then
					table.remove(enemies, i)
					score = score + 10
					enemy.HP = 2
				end
			end
		end
		
	--Shooting enemies-- run our collision detection enemybullet and player
		for k, enemyBullet in ipairs(enemyBullets) do
			if CheckCollision(enemyBullet.x, enemyBullet.y, enemyBullet.sprite:getWidth(), enemyBullet.sprite:getHeight(), Player.x + 15, Player.y + 15, Player.sprite:getWidth()-30, Player.sprite:getHeight()-30)
				and isAlive and Player.state == 'Blue' then
					Player.HP = Player.HP - 1
					table.remove(enemyBullets, k)
			end
		end
		if CheckCollision(enemy.x, enemy.y, enemy.sprite:getWidth(), enemy.sprite:getHeight(), Player.x + 15, Player.y + 15, Player.sprite:getWidth()-30, Player.sprite:getHeight()-30)
			and isAlive then
				Player.HP = Player.HP - 1
				table.remove(enemies, i)
		end
		if CheckCollision(enemy.x, enemy.y, enemy.sprite:getWidth(), enemy.sprite:getHeight(), Player.x + 15, Player.y + 15, Player.sprite:getWidth()-30, Player.sprite:getHeight()-30)
			and love.keyboard.isDown('cpadright') then
				Player.HP = Player.HP + 1
				table.remove(enemies, i)
		end
		
	end
	end
	--------------
	
	
	
	
	--Check 2nd Shooting Enemys!------------------
	for i, Redenemy in ipairs(Redenemies) do
	
	Redenemy.timer = Redenemy.timer - (1*dt)
    if Redenemy.timer < 0 then
      Redenemy.canShoot = true
    end
	
	
	--2nd enemy Spawn Bullet
	for i, Redenemy in ipairs(Redenemies) do
	if Redenemy.canShoot then
			newRedEnemyBullet = { x = Redenemy.x + Redenemy.sprite:getWidth()/2 - RedenemyBulletSprite:getWidth()/2, y = Redenemy.y + Redenemy.sprite:getHeight() - RedenemyBulletSprite:getHeight(), sprite = RedenemyBulletSprite}
			table.insert(RedenemyBullets, RednewEnemyBullet)
			Redenemy.canShoot = false
      Redenemy.timer = canShootEnemyTimerMax
		end
		----
		if CheckCollision(Redenemy.x, Redenemy.y, Redenemy.sprite:getWidth(), Redenemy.sprite:getHeight(), Player.x + 15, Player.y + 15, Player.sprite:getWidth()-30, Player.sprite:getHeight()-30)
			and isAlive and Player.state == 'Red' then
				Player.HP = Player.HP - 1
				table.remove(Redenemies, i)
		end
		end
		--3rd enemy Collision
	for i, Nextenemy in ipairs(Nextenemies) do
	if CheckCollision(Nextenemy.x, Nextenemy.y, Nextenemy.sprite:getWidth(), Nextenemy.sprite:getHeight(), Player.x + 15, Player.y + 15, Player.sprite:getWidth()-30, Player.sprite:getHeight()-30)
			and isAlive and Player.state == 'Blue' then
				Player.HP = Player.HP - 1
				table.remove(Nextenemies, i)
		end
		end
		--4th enemy Collision
		for i, Nexterenemy in ipairs(Nexterenemies) do
	if CheckCollision(Nexterenemy.x, Nexterenemy.y, Nexterenemy.sprite:getWidth(), Nexterenemy.sprite:getHeight(), Player.x + 15, Player.y + 15, Player.sprite:getWidth()-30, Player.sprite:getHeight()-30)
			and isAlive and Player.state == 'Red' then
				Player.HP = Player.HP - 1
				table.remove(Nexterenemies, i)
		end
		end
		end
		
	
   
    

	
--Shooting-- Player Shots Time out how far apart our shots can be. PLayer Shots?
	canShootTimer = canShootTimer - (1*dt)
	if canShootTimer < 0 then
		canShoot = true
	end
	
	-- PLayer Shooting
	if  love.keyboard.isDown('cpadleft') and canShoot then
	-- Create some bullets
		newBullet = { x = Player.x + (Player.sprite:getWidth()/2) - (bulletSprite:getWidth()/2), y = Player.y, sprite = bulletSprite}
		table.insert(bullets, newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end
--Bullets move-- update the positions of bullets
	for i, bullet in ipairs(bullets) do
	
		bullet.x = bullet.x - (350 * dir.x * dt)
		bullet.y = bullet.y - (350 * dir.y * dt) 
		if bullet.x < 0 then -- remove bullets when they pass off the screen
			table.remove(bullets, i)
		end
	end
--Enemy bullets move
	for i, enemyBullet in ipairs(enemyBullets) do
		enemyBullet.x = enemyBullet.x - (200 * dt)
		if enemyBullet.x < 0 then
			table.remove(enemyBullets, i)
		end
	end
	--2nd enemy bullets move
	for i, RedenemyBullet in ipairs(RedenemyBullets) do
		RedenemyBullet.y = RedenemyBullet.y + (300 * dt)
		if RedenemyBullet.y > 260 then
			table.remove(RedenemyBullets, i)
		end
	end
--Enemies move-- update the positions of enemies
	for i, enemy in ipairs(enemies) do
		enemy.x = enemy.x - (85*dt)

		if enemy.x < 0  then
			table.remove(enemies, i)
			--if score > 0 then
				--score = score - 50
				
			
			--end
		end
	end
	--2nd enemies move
	for i, Redenemy in ipairs(Redenemies) do
		Redenemy.y = Redenemy.y + (150*dt)

		if Redenemy.y > 260  then
			table.remove(Redenemies, i)
			--if score > 0 then
				--score = score - 50
				
			
			--end
		end
	end
	---3rd enemies move 
		for i, Nextenemy in ipairs(Nextenemies) do
		Nextenemy.y = Nextenemy.y + (200*dt)

		if Nextenemy.y > 260  then
			table.remove(Nextenemies, i)
			--if score > 0 then
				--score = score - 50
				
			
			--end
		end
	end
	---4th enemies move 
		for i, Nexterenemy in ipairs(Nexterenemies) do
		Nexterenemy.y = Nexterenemy.y + (200*dt)

		if Nexterenemy.y > 260  then
			table.remove(Nexterenemies, i)
			--if score > 0 then
				--score = score - 50
				
			
			--end
		end
	end
--Moving bullets
if love.keyboard.isDown('cpaddown') then
   dir.y = -1
elseif love.keyboard.isDown('cpadup') then
   dir.y = 1
end
if love.keyboard.isDown('cpadright') then
   dir.x = 0
elseif love.keyboard.isDown('cpadleft') then
   dir.x =  1
end

--When u dead
else
--Restarting after death
	if love.keyboard.isDown('up') then
		bullets = {}
		enemyBullets = {}
		RedenemyBullets = {}
		enemies = {}
		Redenemies = {}
		canShootTimer = canShootTimerMax
		RedcanShootTimer = RedShootTimerMax
		createEnemyTimer = createEnemyTimerMax
		createRedEnemyTimer = createRedEnemyTimerMax
		score = 0
		isAlive = true
		Player.HP = 5
		Player.x = 40
		Player.y = 120
	end
end
--
if love.keyboard.isDown('x') then love.event.quit() end
end
-- Escape


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



