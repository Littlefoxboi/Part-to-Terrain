-- Made By Fasty48
local Plugin = plugin or PluginManager():CreatePlugin()
local Toolbar = Plugin:CreateToolbar('Fastcar48')
local Button = Toolbar:CreateButton('Part to Terrain','Allows users to convert parts into terrain.','rbxassetid://297321964')
local Mouse = Plugin:GetMouse()
local Version = '2.6.2'

local Settings = {
	PluginEnabled = false,
	MaterialSelected = 1
}

local Services = {
	ChangeHistory = game:GetService('ChangeHistoryService'),
	ContentProvider = game:GetService('ContentProvider'),
	Marketplace = game:GetService('MarketplaceService'),
	Localization = game:GetService('LocalizationService')
}

---------------------
-- Selection Hover
---------------------
local SelectionBox = Instance.new('SelectionBox',game.CoreGui)
SelectionBox.Color3 = Color3.fromRGB(179,230,255)
SelectionBox.LineThickness = 0.2

local SelectionSphere = Instance.new('SelectionSphere',game.CoreGui)
SelectionSphere.Color3 = Color3.fromRGB(179,230,255)

---------------------
-- UI
---------------------
local UI = Instance.new('ScreenGui',game.CoreGui)

local MainFrame = Instance.new('Frame',UI)
MainFrame.Active = true
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundColor3 = Color3.new()
MainFrame.BackgroundTransparency = .5
MainFrame.Position = UDim2.new(0,0,0,0)
MainFrame.Size = UDim2.new(0,175,0,300)
MainFrame.Visible = false

local Title = Instance.new('TextLabel',MainFrame)
Title.BorderSizePixel = 0
Title.BackgroundColor3 = Color3.fromRGB(33,33,33)
Title.Position = UDim2.new(0,0,0,0)
Title.Size = UDim2.new(1,0,0,20)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Text = 'Part to Terrain V'..Version
Title.TextColor3 = Color3.new(1,1,1)
Title.TextStrokeColor3 = Color3.new()
Title.TextStrokeTransparency = .7

local MaterialFrame = Instance.new('Frame',MainFrame)
MaterialFrame.BorderSizePixel = 0
MaterialFrame.BackgroundColor3 = Color3.new()
MaterialFrame.BackgroundTransparency = .5
MaterialFrame.Position = UDim2.new(0,5,0,25)
MaterialFrame.Size = UDim2.new(0,165,0,245)

local tempMaterial = Instance.new('Frame',MaterialFrame)
tempMaterial.BackgroundTransparency = 1
tempMaterial.Position = UDim2.new(0,5,0,5)
tempMaterial.Size = UDim2.new(0,165,0,1)

local Grid = Instance.new('UIGridLayout',tempMaterial)
Grid.CellSize = UDim2.new(0,35,0,35)

local MaterialHover = Instance.new('TextLabel',MainFrame)
MaterialHover.BorderSizePixel = 0
MaterialHover.BackgroundColor3 = Color3.new()
MaterialHover.BackgroundTransparency = .5
MaterialHover.Position = UDim2.new(0,0,0,275)
MaterialHover.Size = UDim2.new(0,175,0,20)
MaterialHover.Font = Enum.Font.SourceSans
MaterialHover.TextSize = 14
MaterialHover.Text = ''
MaterialHover.TextColor3 = Color3.new(1,1,1)
MaterialHover.TextStrokeColor3 = Color3.new()
MaterialHover.TextStrokeTransparency = .7

function CreateImgBtn(MaterialName,ID)
	Services.ContentProvider:Preload('rbxassetid://'..ID)
	local ImgBtn = Instance.new('ImageButton',tempMaterial)
	ImgBtn.BorderColor3 = Color3.fromRGB(33,150,243)
	ImgBtn.BorderSizePixel = 0
	ImgBtn.Size = UDim2.new(0,35,0,35)
	ImgBtn.Image = 'rbxassetid://'..ID
	ImgBtn.MouseEnter:connect(function() MaterialHover.Text = MaterialName end)
	ImgBtn.MouseLeave:connect(function() MaterialHover.Text = '' end)
	return ImgBtn
end

local AsphaltButton = CreateImgBtn('Asphalt',397352644)
local BasaltButton = CreateImgBtn('Basalt',254542066)
local BrickButton = CreateImgBtn('Brick',225315419)
local CobblestoneButton = CreateImgBtn('Cobblestone',397352378)
local ConcreteButton = CreateImgBtn('Concrete',225314983)
local CrackedLavaButton = CreateImgBtn('Cracked Lava',254541726)
local GlacierButton = CreateImgBtn('Glacier',254541572)
local GrassButton = CreateImgBtn('Grass',225314676)
local GroundButton = CreateImgBtn('Ground',254542189)
local IceButton = CreateImgBtn('Ice',397352205)
local LeafyGrassButton = CreateImgBtn('Leafy Grass',397720681)
local LimestoneButton = CreateImgBtn('Limestone',397352474)
local MudButton = CreateImgBtn('Mud',254541862)
local PavementButton = CreateImgBtn('Pavement',397727024)
local RockButton = CreateImgBtn('Rock',225315178)
local SaltButton = CreateImgBtn('Salt',397352299)
local SandButton = CreateImgBtn('Sand',225315607)
local SandstoneButton = CreateImgBtn('Sandstone',254541350)
local SlateButton = CreateImgBtn('Slate',225315290)
local SnowButton = CreateImgBtn('Snow',254541898)
local WaterButton = CreateImgBtn('Water',225315529)
local WoodenPlanksButton = CreateImgBtn('Wooden Planks',225315705)

local UIButtons = {AsphaltButton,BasaltButton,BrickButton,CobblestoneButton,ConcreteButton,CrackedLavaButton,GlacierButton,GrassButton,GroundButton,IceButton,LeafyGrassButton,LimestoneButton,MudButton,PavementButton,RockButton,SaltButton,SandButton,SandstoneButton,SlateButton,SnowButton,WaterButton,WoodenPlanksButton}
local Materials = {'Asphalt','Basalt','Brick','Cobblestone','Concrete','CrackedLava','Glacier','Grass','Ground','Ice','LeafyGrass','Limestone','Mud','Pavement','Rock','Salt','Sand','Sandstone','Slate','Snow','Water','WoodPlanks'}

function UISelect(Value)
	Settings.MaterialSelected = Value
	for _,v in pairs(tempMaterial:GetChildren()) do
		if (v:IsA('ImageButton')) then
			v.BorderSizePixel = 0
		end
	end
	UIButtons[Value].BorderSizePixel = 2
end

function AddTerrain(Part)
	if Part then
		if Part:IsA('Part') then
			if Part.Shape == Enum.PartType.Block then
				workspace.Terrain:FillBlock(Part.CFrame, Part.Size, Enum.Material[Materials[Settings.MaterialSelected]])
				Part:Remove()
			elseif Part.Shape == Enum.PartType.Ball then			
				workspace.Terrain:FillBall(Part.Position, Part.Size.X/2, Enum.Material[Materials[Settings.MaterialSelected]])
				Part:Remove()
			end
			Services.ChangeHistory:SetWaypoint('Part to Terrain')
		end
	end
end

---------------------
-- Mouse/UI Events
---------------------
Button.Click:connect(function()
	if not PluginEnabled then
		PluginEnabled = true
		MainFrame.Visible = true
		Plugin:Activate(true)
	else
		PluginEnabled = false
		MainFrame.Visible = false
		SelectionBox.Adornee = nil
		SelectionSphere.Adornee = nil
	end
end)

Mouse.Move:connect(function()
	local Part = Mouse.Target
	if PluginEnabled then
		if Part then
			if Part.ClassName == 'Part' and Part.Shape == Enum.PartType.Block then
				SelectionBox.Adornee = Part
				SelectionSphere.Adornee = nil
			elseif Part.ClassName == 'Part' and Part.Shape == Enum.PartType.Ball then
				SelectionSphere.Adornee = Part
				SelectionBox.Adornee = nil
			end
		end
	end
end)

Mouse.Button1Down:connect(function()if PluginEnabled then AddTerrain(Mouse.Target)end end)
AsphaltButton.MouseButton1Click:connect(function()UISelect(1)end)
BasaltButton.MouseButton1Click:connect(function()UISelect(2)end)
BrickButton.MouseButton1Click:connect(function()UISelect(3)end)
CobblestoneButton.MouseButton1Click:connect(function()UISelect(4)end)
ConcreteButton.MouseButton1Click:connect(function()UISelect(5)end)
CrackedLavaButton.MouseButton1Click:connect(function()UISelect(6)end)
GlacierButton.MouseButton1Click:connect(function()UISelect(7)end)
GrassButton.MouseButton1Click:connect(function()UISelect(8)end)
GroundButton.MouseButton1Click:connect(function()UISelect(9)end)
IceButton.MouseButton1Click:connect(function()UISelect(10)end)
LeafyGrassButton.MouseButton1Click:connect(function()UISelect(11)end)
LimestoneButton.MouseButton1Click:connect(function()UISelect(12)end)
MudButton.MouseButton1Click:connect(function()UISelect(13)end)
PavementButton.MouseButton1Click:connect(function()UISelect(14)end)
RockButton.MouseButton1Click:connect(function()UISelect(15)end)
SaltButton.MouseButton1Click:connect(function()UISelect(16)end)
SandButton.MouseButton1Click:connect(function()UISelect(17)end)
SandstoneButton.MouseButton1Click:connect(function()UISelect(18)end)
SlateButton.MouseButton1Click:connect(function()UISelect(19)end)
SnowButton.MouseButton1Click:connect(function()UISelect(20)end)
WaterButton.MouseButton1Click:connect(function()UISelect(21)end)
WoodenPlanksButton.MouseButton1Click:connect(function()UISelect(22)end)

---------------------
-- Update Checker
---------------------
local UpdateChecker = Services.Marketplace:GetProductInfo(302568422).Description
if UpdateChecker ~= Version then 
	warn("The current Part to Terrain version you are running is outdated. Please update for V"..UpdateChecker.."\nPlugins -> Manage Plguins -> Part to Terrain -> Click Update -> Restart Studio")
end