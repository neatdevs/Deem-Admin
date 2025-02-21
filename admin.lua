-- Game Loaded Check
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local writefile = type(writefile) == "function" and function(file, data, safe)
	if safe == true then return pcall(writefile, file, data) end
	writefile(file, data)
end

local readfile = type(readfile) == "function" and function(file, safe)
	if safe == true then return pcall(readfile, file) end
	return readfile(file)
end

function writefileExploit()
	if writefile then
		return true
	end
end

function readfileExploit()
	if readfile then
		return true
	end
end

-- Locals
coregui = game:GetService("CoreGui")
Players = game:GetService("Players")

MarketplaceService = game:GetService("MarketplaceService")
PlaceId, JobId = game.PlaceId, game.JobId

UserInputService = game:GetService("UserInputService")

local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

queueteleport = queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

local plr = Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Character = plr.Character or plr.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local CommandsDirectory = "Deem_commands"
local ChatPrefix = ";"
local Commands = {}

local selected = false

function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end

function toTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end

function onlyIncludeInTable(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function removeTableMatches(tab,matches)
	local matchTable = {}
	local resultTable = {}
	for i,v in pairs(matches) do matchTable[v.Name] = true end
	for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
	return resultTable
end

function getPlayersByName(Name)
	local Name,Len,Found = string.lower(Name),#Name,{}
	for _,v in pairs(Players:GetPlayers()) do
		if Name:sub(0,1) == '@' then
			if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
				table.insert(Found,v)
			end
		else
			if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
				table.insert(Found,v)
			end
		end
	end
	return Found
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

SpecialPlayerCases = {}

local function getPlayer(list,plr)
	if list == nil then return {plr.Name} end
	local nameList = splitString(list,",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers,case(plr,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
end

--// GUI Creation \\--

local ScreenGui = Instance.new("ScreenGui")
local Output = Instance.new("Frame")
local Background = Instance.new("Frame")
local Chat = Instance.new("Frame")
local Scroll = Instance.new("ScrollingFrame")
local Input = Instance.new("TextBox")
local UIPadding = Instance.new("UIPadding")
local Shadow = Instance.new("Frame")
local Close = Instance.new("TextButton")
local ImageLabel = Instance.new("ImageLabel")
local PopupText = Instance.new("TextLabel")
local UIPadding_2 = Instance.new("UIPadding")
local Hide = Instance.new("TextButton")
local ImageLabel_2 = Instance.new("ImageLabel")
local Goto = Instance.new("Frame")
local Close_2 = Instance.new("TextButton")
local ImageLabel_3 = Instance.new("ImageLabel")
local Hide_2 = Instance.new("TextButton")
local ImageLabel_4 = Instance.new("ImageLabel")
local PopupText_2 = Instance.new("TextLabel")
local UIPadding = Instance.new("UIPadding")
local Background_2 = Instance.new("Frame")
local Scroll_2 = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding_3 = Instance.new("UIPadding")
local TP = Instance.new("TextButton")
local toTPto = Instance.new("StringValue")

TweenService = game:GetService("TweenService")

ScreenGui.Parent = gethui() or coregui

Output.Name = "Output"
Output.Parent = ScreenGui
Output.AnchorPoint = Vector2.new(0.5, 0.5)
Output.BackgroundColor3 = Color3.fromRGB(35, 35, 36)
Output.BorderColor3 = Color3.fromRGB(0, 0, 0)
Output.BorderSizePixel = 0
Output.Position = UDim2.new(0.5, 0, 0.5, 0)
Output.Size = UDim2.new(0, 338, 0, 20)
Output.ZIndex = 10
Output.Active = true

Background.Name = "Background"
Background.Parent = Output
Background.BackgroundColor3 = Color3.fromRGB(35, 35, 36)
Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
Background.BorderSizePixel = 0
Background.ClipsDescendants = true
Background.Position = UDim2.new(0, 0, 1, 0)
Background.Size = UDim2.new(0, 338, 0, 245)

Chat.Name = "Chat"
Chat.Parent = Background
Chat.BackgroundColor3 = Color3.fromRGB(35, 35, 36)
Chat.BorderColor3 = Color3.fromRGB(0, 0, 0)
Chat.ClipsDescendants = true
Chat.Size = UDim2.new(0, 338, 0, 245)
Chat.ZIndex = 10

Scroll.Name = "Scroll"
Scroll.Parent = Chat
Scroll.Active = true
Scroll.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Scroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
Scroll.BorderSizePixel = 0
Scroll.Position = UDim2.new(0, 5, 0, 5)
Scroll.Size = UDim2.new(0, 328, 0, 210)
Scroll.ZIndex = 10
Scroll.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 8
Scroll.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

Input.Name = "Input"
Input.Parent = Chat
Input.AnchorPoint = Vector2.new(0.5, 0)
Input.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
Input.BorderSizePixel = 0
Input.Position = UDim2.new(0.5, 0, 0, 220)
Input.Size = UDim2.new(0, 328, 0, 20)
Input.ZIndex = 10
Input.Font = Enum.Font.SourceSans
Input.PlaceholderText = "Command Bar (;)"
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.TextSize = 14.000
Input.TextWrapped = true
Input.TextXAlignment = Enum.TextXAlignment.Left

UIPadding.Parent = Input
UIPadding.PaddingLeft = UDim.new(0, 1)

Shadow.Name = "Shadow"
Shadow.Parent = Output
Shadow.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Shadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
Shadow.Position = UDim2.new(0, 0, 0.00999999978, 0)
Shadow.Size = UDim2.new(0, 338, 0, 20)
Shadow.ZIndex = 10
Shadow.Active = false

Close.Name = "Close"
Close.Parent = Shadow
Close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Close.BackgroundTransparency = 1.000
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1, -20, 0, 0)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.ZIndex = 10
Close.Font = Enum.Font.SourceSans
Close.Text = ""
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.TextSize = 14.000
Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

ImageLabel.Parent = Close
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.Size = UDim2.new(0, 10, 0, 10)
ImageLabel.ZIndex = 10
ImageLabel.Image = "rbxassetid://5054663650"

PopupText.Name = "PopupText"
PopupText.Parent = Shadow
PopupText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PopupText.BackgroundTransparency = 1.000
PopupText.BorderColor3 = Color3.fromRGB(0, 0, 0)
PopupText.BorderSizePixel = 0
PopupText.Size = UDim2.new(1, 0, 0.949999988, 0)
PopupText.ZIndex = 11
PopupText.Font = Enum.Font.SourceSansBold
PopupText.Text = "Deem Admin"
PopupText.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupText.TextSize = 14.000
PopupText.TextXAlignment = Enum.TextXAlignment.Left

UIPadding_2.Parent = PopupText
UIPadding_2.PaddingLeft = UDim.new(0, 5)

Hide.Name = "Hide"
Hide.Parent = Shadow
Hide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Hide.BackgroundTransparency = 1.000
Hide.BorderColor3 = Color3.fromRGB(0, 0, 0)
Hide.BorderSizePixel = 0
Hide.Position = UDim2.new(1, -40, 0, 0)
Hide.Size = UDim2.new(0, 20, 0, 20)
Hide.ZIndex = 10
Hide.Font = Enum.Font.SourceSans
Hide.Text = ""
Hide.TextColor3 = Color3.fromRGB(0, 0, 0)
Hide.TextSize = 14.000
Hide.MouseButton1Click:Connect(function()
	if Background.Size ~= UDim2.new(1,0,0,0) then
		Background:TweenSize(UDim2.new(1,0,0,0), "In", "Quart", 0.3, true, nil)
	else
		Background:TweenSize(UDim2.new(0, 338, 0, 245), "Out", "Quart", 0.3, true, nil)
	end
end)

ImageLabel_2.Parent = Hide
ImageLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_2.BackgroundTransparency = 1.000
ImageLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel_2.BorderSizePixel = 0
ImageLabel_2.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel_2.Size = UDim2.new(0, 14, 0, 14)
ImageLabel_2.ZIndex = 10
ImageLabel_2.Image = "rbxassetid://2406617031"

Goto.Name = "Goto"
Goto.Parent = Output
Goto.AnchorPoint = Vector2.new(1, 0)
Goto.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Goto.BorderColor3 = Color3.fromRGB(0, 0, 0)
Goto.Position = UDim2.new(1, -1, 0, 0)
Goto.Size = UDim2.new(0, 169, 1, 0)
Goto.Visible = false

PopupText_2.Name = "PopupText"
PopupText_2.Parent = Goto
PopupText_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PopupText_2.BackgroundTransparency = 1.000
PopupText_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
PopupText_2.BorderSizePixel = 0
PopupText_2.Size = UDim2.new(1, 0, 0.949999988, 0)
PopupText_2.ZIndex = 1
PopupText_2.Font = Enum.Font.SourceSansBold
PopupText_2.Text = "Teleport Gui"
PopupText_2.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupText_2.TextSize = 14.000
PopupText_2.TextXAlignment = Enum.TextXAlignment.Left

UIPadding.Parent = PopupText_2
UIPadding.PaddingLeft = UDim.new(0, 2)

Close_2.Name = "Close"
Close_2.Parent = PopupText_2
Close_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Close_2.BackgroundTransparency = 1.000
Close_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close_2.BorderSizePixel = 0
Close_2.Position = UDim2.new(1, -20, 0, 0)
Close_2.Size = UDim2.new(0, 20, 0, 20)
Close_2.ZIndex = 10
Close_2.Font = Enum.Font.SourceSans
Close_2.Text = ""
Close_2.TextColor3 = Color3.fromRGB(0, 0, 0)
Close_2.TextSize = 14.000
Close_2.Active = false
Close_2.MouseButton1Click:Connect(function()
	Goto:TweenPosition(UDim2.new(1,-1,0,0), "In", "Sine", 0.3, true, nil)
	wait(.3)
	Goto.Visible = false
end)

ImageLabel_3.Parent = Close_2
ImageLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel_3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel_3.BackgroundTransparency = 1.000
ImageLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel_3.BorderSizePixel = 0
ImageLabel_3.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel_3.Size = UDim2.new(0, 10, 0, 10)
ImageLabel_3.ZIndex = 10
ImageLabel_3.Image = "rbxassetid://5054663650"

Hide_2.Name = "Hide"
Hide_2.Parent = PopupText_2
Hide_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Hide_2.BackgroundTransparency = 1.000
Hide_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Hide_2.BorderSizePixel = 0
Hide_2.Position = UDim2.new(1, -40, 0, 0)
Hide_2.Size = UDim2.new(0, 20, 0, 20)
Hide_2.ZIndex = 10
Hide_2.Font = Enum.Font.SourceSans
Hide_2.Text = ""
Hide_2.TextColor3 = Color3.fromRGB(0, 0, 0)
Hide_2.TextSize = 14.000
Hide_2.Active = false
Hide_2.MouseButton1Click:Connect(function()
	if Background_2.Size ~= UDim2.new(1,0,0,0) then
		Background_2:TweenSize(UDim2.new(1,0,0,0), "In", "Sine", 0.3, true, nil)
	else
		Background_2:TweenSize(UDim2.new(0, 169, 0, 245), "Out", "Sine", 0.3, true, nil)
	end
end)

ImageLabel_4.Parent = Hide_2
ImageLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_4.BackgroundTransparency = 1.000
ImageLabel_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel_4.BorderSizePixel = 0
ImageLabel_4.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel_4.Size = UDim2.new(0, 14, 0, 14)
ImageLabel_4.ZIndex = 10
ImageLabel_4.Image = "rbxassetid://2406617031"

Background_2.Name = "Background_2"
Background_2.Parent = Goto
Background_2.BackgroundColor3 = Color3.fromRGB(35, 35, 36)
Background_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Background_2.Position = UDim2.new(0, 0, 1, 0)
Background_2.Size = UDim2.new(0, 169, 0, 245)
Background_2.ClipsDescendants = true

Scroll_2.Name = "Scroll_2"
Scroll_2.Parent = Background_2
Scroll_2.Active = true
Scroll_2.AnchorPoint = Vector2.new(0.5, 0)
Scroll_2.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
Scroll_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Scroll_2.BorderSizePixel = 0
Scroll_2.Position = UDim2.new(0.5, 0, 0, 5)
Scroll_2.Size = UDim2.new(1, -10, 1, -40)
Scroll_2.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Scroll_2.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll_2.ScrollBarThickness = 4
Scroll_2.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Scroll_2.AutomaticCanvasSize = Enum.AutomaticSize.Y

UIListLayout.Parent = Scroll_2
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5)

UIPadding_3.Parent = Scroll_2
UIPadding_3.PaddingRight = UDim.new(0, 5)
UIPadding_3.PaddingTop = UDim.new(0, 5)

TP.Name = "TP"
TP.Parent = Background_2
TP.AnchorPoint = Vector2.new(0.5, 0.5)
TP.BackgroundColor3 = Color3.fromRGB(45, 45, 47)
TP.BorderColor3 = Color3.fromRGB(0, 0, 0)
TP.BorderSizePixel = 0
TP.Position = UDim2.new(0.5, 0, 0, 228)
TP.Size = UDim2.new(1, -10, 0, 25)
TP.Font = Enum.Font.SourceSans
TP.Text = "Teleport to selected player."
TP.TextColor3 = Color3.fromRGB(255, 255, 255)
TP.TextSize = 14.000
TP.MouseButton1Click:Connect(function()
	if toTPto.Value ~= "" then
		local player = toTPto.Value
		local char = player.Character

		local players = getPlayer(player, plr)

		for i,v in pairs(players) do
			if Players[v].Character ~= nil then
				if plr.Character:FindFirstChildOfClass('Humanoid') and plr.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					plr.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end

				getRoot(plr.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)
			end
		end
	elseif toTPto.Value == "" or nil then 
		return _G.CreateLabel("A player hasn't been selected yet!")
	end
end)

toTPto.Parent = Background_2
toTPto.Value = ""

function removeplr(plrName)
	local playertab = Scroll_2
	local frame = playertab:FindFirstChild(plrName) -- Find Frame
	if frame ~= nil then -- If Frame
		frame:Destroy() -- Destroy Frame
	end
end

game.Players.PlayerRemoving:Connect(function(plr) -- Player leaves
	removeplr(plr.Name)
end)

plr.OnTeleport:Connect(function()
    queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/neatdevs/Deem-Admin/refs/heads/main/admin.lua'))()")
end)

--// Drag Function \\--

function dragGUI(gui)
	task.spawn(function()
		local dragging
		local dragInput
		local dragStart = Vector3.new(0,0,0)
		local startPos
		local function update(input)
			local delta = input.Position - dragStart
			local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			TweenService:Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
		end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = gui.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		gui.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end)
end

dragGUI(Output)

--// Functions \\--

CleanFileName = function(name)
	return tostring(name):gsub("[*\\?:<>|]+", ""):sub(1, 175)
end

local cooldown = false
function writefileCooldown(name,data)
	task.spawn(function()
		if not cooldown then
			cooldown = true
			writefile(name, data, true)
		else
			repeat wait() until cooldown == false
			writefileCooldown(name,data)
		end
		wait(3)
		cooldown = false
	end)
end

function Time()
	local HOUR = math.floor((tick() % 86400) / 3600)
	local MINUTE = math.floor((tick() % 3600) / 60)
	local SECOND = math.floor(tick() % 60)
	local AP = HOUR > 11 and 'PM' or 'AM'
	HOUR = (HOUR % 12 == 0 and 12 or HOUR % 12)
	HOUR = HOUR < 10 and '0' .. HOUR or HOUR
	MINUTE = MINUTE < 10 and '0' .. MINUTE or MINUTE
	SECOND = SECOND < 10 and '0' .. SECOND or SECOND
	return HOUR .. ':' .. MINUTE .. ':' .. SECOND .. ' ' .. AP
end

local lastMessage = nil
local lastLabel = nil
local dupeCount = 1

_G.CreateLabel = function(Output)
	if lastMessage == Output then
		dupeCount = dupeCount+1
		lastLabel.Text = Time()..' - '..Output..' (x'..dupeCount..')'
	else
		if dupeCount > 1 then dupeCount = 1 end
		if #Scroll:GetChildren() >= 2546 then
			Scroll:ClearAllChildren()
		end
		local alls = 0
		for i,v in pairs(Scroll:GetChildren()) do
			if v then
				alls = v.Size.Y.Offset + alls
			end
			if not v then
				alls = 0
			end
		end
		local tl = Instance.new('TextLabel')
		lastMessage = Output
		lastLabel = tl
		tl.Name = Output
		tl.Parent = Scroll
		tl.ZIndex = 10
		tl.Text = Time().." - "..Output
		tl.Size = UDim2.new(0,322,0,84)
		tl.BackgroundTransparency = 1
		tl.BorderSizePixel = 0
		tl.Font = "SourceSans"
		tl.Position = UDim2.new(-1,0,0,alls)
		tl.TextTransparency = 1
		tl.TextScaled = false
		tl.TextSize = 14
		tl.TextWrapped = true
		tl.TextXAlignment = "Left"
		tl.TextYAlignment = "Top"
		tl.TextColor3 = Color3.fromRGB(255,255,255)
		tl.Size = UDim2.new(0,322,0,tl.TextBounds.Y)
		Scroll.CanvasSize = UDim2.new(0,0,0,alls+tl.TextBounds.Y)
		Scroll.CanvasPosition = Vector2.new(0,Scroll.CanvasPosition.Y+tl.TextBounds.Y)
		tl:TweenPosition(UDim2.new(0,3,0,alls), 'Out', 'Quint', 0.5)
		TweenService:Create(tl, TweenInfo.new(1.25, Enum.EasingStyle.Linear), { TextTransparency = 0 }):Play()
	end
end

local function getroot(char)
	return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

-- Message

local function sendChatFeedback(message)
	StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = "[Deem Admin]: " .. message,
		Color = Color3.new(1, 1, 1),
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size18,
	})
end

local function sendOutputFeedback(message)
	_G.CreateLabel("[Deem Admin]: " .. message)
end

sendChatFeedback("Welcome to Deem Admin (Beta)!\nType ';help' in the chat for a list of commands")

sendOutputFeedback("Welcome to Deem Admin (Beta)!\nType 'help' in the command bar for a list of commands")

if IsOnMobile then
	sendOutputFeedback("You are currently on mobile. If Deem Admin doesn't work for you please send your executor and platform to the discord.\nPlease join here to get help: discord.gg/su7ycRRJyz")
end

local function split(str, sep)
	if str == nil then
		return {}
	end
	if #sep > 1 then
		return {}
	end
	local tokens = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		table.insert(tokens, v)
	end
	return tokens
end

local function loadCommands()
	if not isfolder(CommandsDirectory) then
		makefolder(CommandsDirectory)
	end

	local files = listfiles(CommandsDirectory)

	for _, filePath in ipairs(files) do
		local fileName = filePath:match("[^\\^/]+%.lua$") or filePath:match("[^\\^/]+%.txt$")

		if fileName then
			local commandName = fileName:sub(1, #fileName - 4)
			local fileContent = readfile(filePath)

			local call, err = loadstring(fileContent)
			if not call then
				warn("Failed to load command:", filePath, "Error:", err)
			else
				local success, commandFunction = pcall(call)
				if success and type(commandFunction) == "function" then
					Commands[commandName] = commandFunction
				else
					warn("Command script must return a function:", filePath)
				end
			end
		end
	end
end


Commands = {
	help = function()
		local helpMessage = "Available Commands:"
		local i = 1

		_G.CreateLabel(helpMessage)

		for commandName in pairs(Commands) do
			_G.CreateLabel(i .. ") " .. commandName)
			i += 1
		end

		sendOutputFeedback(helpMessage)
	end,

	getremotes = function(...)
		for i, v in pairs(game:GetDescendants()) do
			if string.match(v.ClassName, "RemoteEvent") then
				sendOutputFeedback("\nRemoteEvent found!  \nLocation: " .. v:GetFullName() .. "  \nMethod  FireServer\n")
			elseif string.match(v.ClassName, "RemoteFunction") then
				sendOutputFeedback("\nRemoteFunction found! \nLocation: " .. v:GetFullName() .. "  \nMethod | InvokeServer\n")
			else

			end
		end
	end,

	getremoteevents = function(...)
		for i, v in pairs(game:GetDescendants()) do
			if string.match(v.ClassName, "RemoteEvent") then
				sendOutputFeedback("\nRemoteEvent found!  \nLocation: " .. v:GetFullName() .. "  \nMethod  FireServer\n")
			else

			end
		end
	end,

	getremotefunctions = function(...)
		for i, v in pairs(game:GetDescendants()) do
			if string.match(v.ClassName, "RemoteFunction") then
				sendOutputFeedback("\nRemoteFunction found! \nLocation: " .. v:GetFullName() .. "  \nMethod | InvokeServer\n")
			else

			end
		end
	end,

	noclip = function(...)
		for i, v in pairs(plr.Character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end,

	clip = function(...)
		for i, v in pairs(plr.Character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end,

	fireclickdetectors = function(...)
		for i, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ClickDetector") then
				fireclickdetector(v)
			end
		end
	end,

	supportserver = function(...)
		sendOutputFeedback("discord.gg/su7ycRRJyz\n Server link has been copied to your clipboard.\n")
		setclipboard("discord.gg/su7ycRRJyz")
	end,

	noproximitycooldown = function(...)
		while task.wait() do
			game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(fireproximityprompt)
		end
	end,

	spoofmemory = function(...)
		hookfunction((gcinfo or collectgarbage), function(...)
			return math.random(200, 350)
		end)

		local gamemt = getrawmetatable(game)

		setreadonly(gamemt, false)

		local nc = gamemt.__namecall

		gamemt.__namecall = newcclosure(function(...)
			if getnamecallmethod() == "GetTotalMemoryUsageMb" then
				return math.random(395, 405)
			end

			return nc(...)
		end)

		hookfunction(game.Stats.GetTotalMemoryUsageMb, function()
			return math.random(395, 405)
		end)

		sendOutputFeedback("Memory Spoofed!\n")
	end,

	tpgui = function(...)
		Goto.Visible = true

		local tweenInfo = TweenInfo.new(
			0.3, -- The time the tween takes to complete
			Enum.EasingStyle.Sine, -- The tween style.
			Enum.EasingDirection.Out, -- EasingDirection
			0, -- How many times you want the tween to repeat. If you make it less than 0 it will repeat forever.
			false, -- Reverse?
			0 -- Delay
		)

		local tween = Goto:TweenPosition(
			UDim2.new(1, 179, 0, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine,
			0.3,
			true
		)

		wait(0.3)

		local playerJoined = function(player : Player)
			local test : TextButton = Instance.new("TextButton")

			test.Name = player.Name
			test.Parent = Scroll_2
			test.BackgroundColor3 = Color3.fromRGB(50, 50, 57)
			test.BorderColor3 = Color3.fromRGB(0, 0, 0)
			test.Size = UDim2.new(1, -10, 0, 25)
			test.Font = Enum.Font.SourceSans
			test.Text = player.DisplayName
			test.TextColor3 = Color3.fromRGB(255, 255, 255)
			test.TextScaled = true
			test.TextSize = 11.000
			test.TextWrapped = false
			test.MouseButton1Down:Connect(function(x: number, y: number) -- Detects When Button Is Pressed
				-- Sets The String Value To The Players Name
				local mval : StringValue = toTPto -- String Value To Set
				mval.Value = tostring(test.Name)  -- Setting String Value
				if not selected then
					selected = true
					test.BackgroundColor3 = Color3.fromRGB(87, 87, 99)
				elseif selected then
					selected = false
					test.BackgroundColor3 = Color3.fromRGB(50, 50, 57)
					mval.Value = ""
				end
			end)

			if test.TextFits == false then
				test.TextWrapped = true
			else
				test.TextWrapped = false
			end
		end

		game:GetService("Players").PlayerAdded:Connect(playerJoined)

		for i,player : Player in game:GetService("Players"):GetPlayers() do
			playerJoined(player)
		end
	end,

	antiafk = function(...)
		for i, v in pairs(getconnections(Players.LocalPlayer.Idled)) do
			v:Disable()
		end
	end,

	fullbright = function(...)
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	end,

	clear = function(...)
		for _, child in pairs(Scroll:GetChildren()) do
			child:Destroy()
		end
		Scroll.CanvasSize = UDim2.new(0, 0, 0, 10)
	end,

	saveoutput = function(...)
		if writefileExploit() then
			if #Scroll:GetChildren() > 0 then
				_G.CreateLabel("Loading",'Hold on a sec')
				local placeName = CleanFileName(MarketplaceService:GetProductInfo(PlaceId).Name)
				local writelogs = '-- Deem Admin Output logs for "'..placeName..'"\n'
				for _, child in pairs(Scroll:GetChildren()) do
					writelogs = writelogs..'\n'..child.Text
				end
				local writelogsFile = tostring(writelogs)
				local fileext = 0
				local function nameFile()
					local file
					pcall(function() file = readfile(placeName..' Output Logs ('..fileext..').txt') end)
					if file then
						fileext = fileext+1
						nameFile()
					else
						writefileCooldown(placeName..' Output Logs ('..fileext..').txt', writelogsFile)
					end
				end
				nameFile()
				_G.CreateLabel('Output Logs','Saved Output logs to the workspace folder within your exploit folder.')
			end
		else
			_G.CreateLabel('Output Logs','Your exploit does not support write file. You cannot save chat logs.')
		end
	end,

	serverhop = function(...)
		local x = {}
		local pid = game.PlaceId
		local jid = game.JobId

		for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. pid .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
			if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= jid then
				x[#x + 1] = v.id
			end
		end

		if #x > 0 then
			TeleportService:TeleportToPlaceInstance(pid, x[math.random(1, #x)])
		end
	end, 

	rejoin = function(...)
		TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
	end,

	walkspeed = function(...)
		local args = {...}
		local ws = args[1]

		Humanoid.WalkSpeed = ws
	end,

	jumppower = function(...)
		local args = {...}
		local jp = args[1]

		Humanoid.JumpPower = jp
	end,

	getpos = function(...)
		sendOutputFeedback(tostring(HumanoidRootPart.Position.X .. ", " .. HumanoidRootPart.Position.Y .. ", " .. HumanoidRootPart.Position.Z))
	end, 
}

-- Chat Command Runner
local function processChatMessage(message)
	if message:sub(1, #ChatPrefix) == ChatPrefix then
		local args = split(message:sub(#ChatPrefix + 1), " ")
		local commandName = table.remove(args, 1):lower()

		if Commands[commandName] then
			local success, err = pcall(function()
				Commands[commandName](table.unpack(args))
			end)

			if success then
				sendChatFeedback("Executed '" .. commandName .. "' successfully!")
			else
				sendChatFeedback("Error executing '" .. commandName .. "': " .. tostring(err))
			end
		else
			sendChatFeedback("Unknown command: " .. commandName)
		end
	end
end

-- Input Command Runner
local function processInputCommand(cmd)
	local args = split(cmd, " ")
	local commandName = string.lower(args[1])
	table.remove(args, 1)

	if Commands[commandName] then
		local success, err = pcall(function()
			Commands[commandName](table.unpack(args))
		end)

		if success then
			sendOutputFeedback("Executed '" .. commandName .. "' successfully!")
		else
			sendOutputFeedback("Error executing '" .. commandName .. "': " .. tostring(err))
		end
	else
		sendOutputFeedback("Unknown command: " .. commandName)
	end
end

-- Focus command bar
plr:GetMouse().KeyDown:Connect(function(key)
	if key == ";" then
		Input:CaptureFocus()
		spawn(function()
			Input.Text = ""
		end)
	end
end)

Input.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		processInputCommand(Input.Text)
		Input:ReleaseFocus()
	end
end)

plr.Chatted:Connect(processChatMessage)
RunService.Heartbeat:Connect(loadCommands)
