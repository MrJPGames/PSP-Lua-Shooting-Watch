img = {}
simg = {}
img[0]=Image.load("0.png")
img[1]=Image.load("1.png")
img[2]=Image.load("2.png")
img[3]=Image.load("3.png")
img[4]=Image.load("4.png")
img[5]=Image.load("5.png")
img[6]=Image.load("6.png")
img[7]=Image.load("7.png")
img[8]=Image.load("8.png")
img[9]=Image.load("9.png")
simg[0]=Image.load("s0.png")
simg[1]=Image.load("s1.png")
simg[2]=Image.load("s2.png")
simg[3]=Image.load("s3.png")
simg[4]=Image.load("s4.png")
simg[5]=Image.load("s5.png")
simg[6]=Image.load("s6.png")
simg[7]=Image.load("s7.png")
simg[8]=Image.load("s8.png")
simg[9]=Image.load("s9.png")
bg = Image.load("background.png")
new = Image.load("new.png")
highimg = Image.load("high.png")
lastimg = Image.load("last.png")

w = Color.new(255,255,255)
done=0
l=0

function saveHighscore()
	file = io.open("high.txt", "w")
	if file then
		file:write(high)
		file:close()
	end
end

function loadHighscore()
	file = io.open("high.txt", "r")
	if file then
		high = file:read()
		rhigh = tonumber(high)
		high=rhigh
		file:close()
	else
		high=0
		saveHighscore()
	end
end

function renderScore()
	h=0
	t=0
	screen:blit(274,67,img[0])
	for i=0,9,1 do
		if (mscore/100 >= i) then
			screen:blit(274,67,img[i])
			h=i
		end
	end
	screen:blit(297,67,img[0])
	for i=0,9,1 do
		tscore=mscore-h*100
		if (tscore/10 >= i) then
			screen:blit(297,67,img[i])
			t=i
		end
	end
	for i=0,9,1 do
		tempscore=tscore-10*t
		if tempscore == i then
			screen:blit(319,67,img[i])
		end
	end
end

function renderSec()
	if sec == 10 then
		screen:blit(345,68,simg[1])
		screen:blit(357,68,simg[0])
	else
		screen:blit(345,68,simg[0])
		screen:blit(357,68,simg[sec])
	end
end
high=-1
loadHighscore()
--0 = menu, 1=time, 2=game, 3 = aftergame
mode=0
oldpad=Controls.read()
timer=0
score=0
jh=0
--main loop
while true do
	--render
	--background
	screen:blit(0,0,bg)
	--Button input
	pad = Controls.read()
	if mode == 1 then
		--render time
		if pad:select() and not oldpad:select() then
			oldpad=pad
			mode=0
		end
		screen:blit(249,84,lastimg)
		mscore=score
		renderScore()
	end
	if mode == 0 then
		--render menu
		screen:blit(250,70,highimg)
		if high == -1 then
			loadHighscore()
		end
		mscore=high
		renderScore()
		if pad:cross() and pad:start() then
			timer=0
			sec=10
			score=-1
			mode=2
		end
		if pad:select() and not oldpad:select() then
			mode=1
		end
		if jh == 1 then
			screen:blit(341,86,new)
		end
	end
	
	if mode == 2 then
		--game
		if pad:cross() and not oldpad:cross() then
			score=score+1
		end
		timer=timer+1
		if timer == 60 then
			timer=0
			sec=sec-1
		end
		if sec == 0 then
			mode=3
		end
		mscore=score
		renderScore()
		renderSec()
	end
	if mode == 3 then
		--aftergame
		mode=0
		if score > high then
			high=score
			saveHighscore()
			jh=1
		else
			jh=0
		end
	end
	oldpad=pad
	screen.flip()
	screen.waitVblankStart()
end