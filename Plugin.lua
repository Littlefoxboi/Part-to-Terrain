-- Made By Fastcar48
local Plugin = plugin or PluginManager():CreatePlugin()
local Toolbar = Plugin:CreateToolbar('Fastcar48')
local Button = Toolbar:CreateButton('Part to Terrain','Allows users to convert parts into terrain.','rbxassetid://297321964')
local Mouse = Plugin:GetMouse()
local Version = '2.5'

local Settings = {
	PluginEnabled = false;
	MaterialSelected = 1;
	SettingsMaterial = Plugin:GetSetting('LastMaterialUsed')
}

local Services = {
	ChangeHistory = game:GetService('ChangeHistoryService');
	ContentProvider = game:GetService('ContentProvider');
	Marketplace = game:GetService('MarketplaceService')
}

local SelectionBox = Instance.new('SelectionBox',game.CoreGui)
SelectionBox.Color3 = Color3.fromRGB(33, 150, 243)
SelectionBox.LineThickness = 0.2

--local SelectionSphere = Instance.new('SelectionSphere',game.CoreGui)
--SelectionSphere.Color3 = Color3.fromRGB(33, 150, 243)

-- UI
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
Title.TextStrokeTransparency = .25

local MaterialFrame = Instance.new('Frame',MainFrame)
MaterialFrame.BorderSizePixel = 0
MaterialFrame.BackgroundColor3 = Color3.new()
MaterialFrame.BackgroundTransparency = .5
MaterialFrame.Position = UDim2.new(0,5,0,25)
MaterialFrame.Size = UDim2.new(0,165,0,245)

--Waiting for Roblox to fix align
local tempMaterial = Instance.new('Frame',MaterialFrame)
tempMaterial.BackgroundColor3 = Color3.new()
tempMaterial.BackgroundTransparency = 1
tempMaterial.Position = UDim2.new(0,5,0,5)
tempMaterial.Size = UDim2.new(0,165,0,1)
--

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
MaterialHover.TextStrokeTransparency = .55

function CreateImageButton(MaterialName,ID)
	Services.ContentProvider:Preload('rbxassetid://'..ID)
	local ImageButton = Instance.new('ImageButton',tempMaterial)
	ImageButton.BorderColor3 = Color3.fromRGB(33,150,243)
	ImageButton.BorderSizePixel = 0
	ImageButton.Size = UDim2.new(0,35,0,35)
	ImageButton.Image = 'rbxassetid://'..ID
	ImageButton.MouseEnter:connect(function() MaterialHover.Text = MaterialName end)
	ImageButton.MouseLeave:connect(function() MaterialHover.Text = '' end)
	return ImageButton
end

local AsphaltButton = CreateImageButton('Asphalt',397352644)
local BasaltButton = CreateImageButton('Basalt',254542066)
local BrickButton = CreateImageButton('Brick',225315419)
local CobblestoneButton = CreateImageButton('Cobblestone',397352378)
local ConcreteButton = CreateImageButton('Concrete',225314983)
local CrackedLavaButton = CreateImageButton('Cracked Lava',254541726)
local GlacierButton = CreateImageButton('Glacier',254541572)
local GrassButton = CreateImageButton('Grass',225314676)
local GroundButton = CreateImageButton('Ground',254542189)
local IceButton = CreateImageButton('Ice',397352205)
local LeafyGrassButton = CreateImageButton('Leafy Grass',397720681)
local LimestoneButton = CreateImageButton('Limestone',397352474)
local MudButton = CreateImageButton('Mud',254541862)
local PavementButton = CreateImageButton('Pavement',397727024)
local RockButton = CreateImageButton('Rock',225315178)
local SaltButton = CreateImageButton('Salt',397352299)
local SandButton = CreateImageButton('Sand',225315607)
local SandstoneButton = CreateImageButton('Sandstone',254541350)
local SlateButton = CreateImageButton('Slate',225315290)
local SnowButton = CreateImageButton('Snow',254541898)
local WaterButton = CreateImageButton('Water',225315529)
local WoodPlanksButton = CreateImageButton('Wood Planks',225315705)

local UIButtons = {AsphaltButton,BasaltButton,BrickButton,CobblestoneButton,ConcreteButton,CrackedLavaButton,GlacierButton,GrassButton,GroundButton,IceButton,LeafyGrassButton,LimestoneButton,MudButton,PavementButton,RockButton,SaltButton,SandButton,SandstoneButton,SlateButton,SnowButton,WaterButton,WoodPlanksButton}
local Materials = {'Asphalt','Basalt','Brick','Cobblestone','Concrete','CrackedLava','Glacier','Grass','Ground','Ice','LeafyGrass','Limestone','Mud','Pavement','Rock','Salt','Sand','Sandstone','Slate','Snow','Water','WoodPlanks'}

function UISelect(Value)
	Plugin:SetSetting('LastMaterialUsed',Value)
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
		if Part.ClassName == 'Part' then
			if Part.Shape == Enum.PartType.Block then
				workspace.Terrain:FillBlock(Part.CFrame,Part.Size,Enum.Material[Materials[Settings.MaterialSelected]])
				Part:remove()
				ChangeHistory:SetWaypoint('Part to Terrain')
			--elseif Part.Shape == Enum.PartType.Ball then
				--Looking into a fix.
				
				--game.Workspace.Terrain:FillBall(Part.CFrame, **Vector3.new(Part.Size.Y)**, Enum.Material[Materials[MaterialSelect]])
				--Part:remove()
				--ChangeHistoryService:SetWaypoint('Part to Terrain')
				--print(Part.Size.Y)
			end
		end
	end
end

-- Mouse/UI Events
Button.Click:connect(function()
	if not PluginEnabled then
		PluginEnabled = true
		MainFrame.Visible = true
		Plugin:Activate(true)
	else
		PluginEnabled = false
		MainFrame.Visible = false
		SelectionBox.Adornee = nil
		--SelectionSphere.Adornee = nil
	end
end)

Mouse.Move:connect(function()
	local Part = Mouse.Target
	if PluginEnabled then
		if Part then
			if Part.ClassName == 'Part' and Part.Shape == Enum.PartType.Block then
				SelectionBox.Adornee = Part
				-- SelectionSphere.Adornee = nil
			-- elseif Part.ClassName == 'Part' and Part.Shape == Enum.PartType.Ball then
				-- SelectionSphere.Adornee = Part
				-- SelectionBox.Adornee = nil
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
WoodPlanksButton.MouseButton1Click:connect(function()UISelect(22)end)

-- Settings and Update Checker
local SettingsMaterial = Settings.SettingsMaterial
if SettingsMaterial == nil or 1 or SettingsMaterial > 22 then UISelect(1)else UISelect(SettingsMaterial)end

local UpdateChecker = Services.Marketplace:GetProductInfo(302568422).Description
if UpdateChecker ~= Version then 
	warn("The current Part to Terrain version you are running is outdated. Please update for V"..UpdateChecker)
end