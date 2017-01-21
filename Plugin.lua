-- Made By Fastcar48
local Plugin = plugin or PluginManager():CreatePlugin()
local Toolbar = Plugin:CreateToolbar('Fastcar48')
local Button = Toolbar:CreateButton(
	'Part to Terrain',
	'Allows users to convert parts into terrain.',
	'rbxassetid://297321964'
)

local Version = '2.4.1.1'

local PluginEnabled = false
local MaterialSelect = 1
local Mouse = Plugin:GetMouse()

local ChangeHistoryService = game:GetService('ChangeHistoryService')
local ContentProviderService = game:GetService('ContentProvider')
local MarketplaceService = game:GetService('MarketplaceService')
local SelectionService = game:GetService('Selection')
local UserInputService = game:GetService('UserInputService')

--UI
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
Title.BackgroundTransparency = 0
Title.Position = UDim2.new(0,0,0,0)
Title.Size = UDim2.new(1,0,0,20)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = '14'
Title.Text = 'Part to Terrain V'..Version
Title.TextColor3 = Color3.new(1,1,1)
Title.TextStrokeColor3 = Color3.new()
Title.TextStrokeTransparency = .25
Title.TextXAlignment = Enum.TextXAlignment.Left

--Material Selection
local MaterialFrame = Instance.new('Frame',MainFrame)
MaterialFrame.BorderSizePixel = 0
MaterialFrame.BackgroundColor3 = Color3.new()
MaterialFrame.BackgroundTransparency = .5
MaterialFrame.Position = UDim2.new(0,5,0,25)
MaterialFrame.Size = UDim2.new(0,165,0,245)

local MaterialHover = Instance.new('TextLabel',MainFrame)
MaterialHover.BorderSizePixel = 0
MaterialHover.BackgroundColor3 = Color3.new()
MaterialHover.BackgroundTransparency = .5
MaterialHover.Position = UDim2.new(0,0,0,275)
MaterialHover.Size = UDim2.new(0,175,0,20)
MaterialHover.Font = Enum.Font.SourceSans
MaterialHover.TextSize = '14'
MaterialHover.Text = ''
MaterialHover.TextColor3 = Color3.new(1,1,1)
MaterialHover.TextStrokeColor3 = Color3.new()
MaterialHover.TextStrokeTransparency = .55

local function CreateImageButton(MaterialName,ID,Position)
	local ImageButton = Instance.new('ImageButton',MaterialFrame)
	ImageButton.BorderColor3 = Color3.fromRGB(33,150,243)
	ImageButton.BorderSizePixel = 0
	ImageButton.Position = Position
	ImageButton.Size = UDim2.new(0,35,0,35)
	ContentProviderService:Preload('rbxassetid://'..ID)
	ImageButton.Image = 'rbxassetid://'..ID
	ImageButton.MouseEnter:connect(function() MaterialHover.Text = MaterialName end)
	ImageButton.MouseLeave:connect(function() MaterialHover.Text = '' end)
	return ImageButton
end

local AsphaltButton = CreateImageButton('Asphalt',397352644,UDim2.new(0,5,0,5))
local BasaltButton = CreateImageButton('Basalt',254542066,UDim2.new(0,45,0,5))
local BrickButton = CreateImageButton('Brick',225315419,UDim2.new(0,85,0,5))
local CobblestoneButton = CreateImageButton('Cobblestone',397352378,UDim2.new(0,125,0,5))
local ConcreteButton = CreateImageButton('Concrete',225314983,UDim2.new(0,5,0,45))
local CrackedLavaButton = CreateImageButton('Cracked Lava',254541726,UDim2.new(0,45,0,45))
local GlacierButton = CreateImageButton('Glacier',254541572,UDim2.new(0,85,0,45))
local GrassButton = CreateImageButton('Grass',225314676,UDim2.new(0,125,0,45))
local GroundButton = CreateImageButton('Ground',254542189,UDim2.new(0,5,0,85))
local IceButton = CreateImageButton('Ice',397352205,UDim2.new(0,45,0,85))
local LeafyGrassButton = CreateImageButton('Leafy Grass',397720681,UDim2.new(0,85,0,85))
local LimestoneButton = CreateImageButton('Limestone',397352474,UDim2.new(0,125,0,85))
local MudButton = CreateImageButton('Mud',254541862,UDim2.new(0,5,0,125))
local PavementButton = CreateImageButton('Pavement',397727024,UDim2.new(0,45,0,125))
local RockButton = CreateImageButton('Rock',225315178,UDim2.new(0,85,0,125))
local SaltButton = CreateImageButton('Salt',397352299,UDim2.new(0,125,0,125))
local SandButton = CreateImageButton('Sand',225315607,UDim2.new(0,5,0,165))
local SandstoneButton = CreateImageButton('Sandstone',254541350,UDim2.new(0,45,0,165))
local SlateButton = CreateImageButton('Slate',225315290,UDim2.new(0,85,0,165))
local SnowButton = CreateImageButton('Snow',254541898,UDim2.new(0,125,0,165))
local WaterButton = CreateImageButton('Water',225315529,UDim2.new(0,5,0,205))
local WoodPlanksButton = CreateImageButton('Wood Planks',225315705,UDim2.new(0,45,0,205))

--API not enabled
local NotEnabledFrame = Instance.new('Frame',UI)
NotEnabledFrame.BorderSizePixel = 0
NotEnabledFrame.BackgroundColor3 = Color3.new()
NotEnabledFrame.BackgroundTransparency = .5
NotEnabledFrame.Position = UDim2.new(0.5,-235,0.5,-87)
NotEnabledFrame.Size = UDim2.new(0,470,0,175)
NotEnabledFrame.Visible = false

local Title2 = Instance.new('TextLabel',NotEnabledFrame)
Title2.BorderSizePixel = 0
Title2.BackgroundColor3 = Color3.fromRGB(33,33,33)
Title2.BackgroundTransparency = 0
Title2.Position = UDim2.new(0,0,0,0)
Title2.Size = UDim2.new(1,0,0,20)
Title2.Font = Enum.Font.SourceSansBold
Title2.TextSize = '18'
Title2.Text = 'Part to Terrain'
Title2.TextColor3 = Color3.new(1,1,1)
Title2.TextStrokeColor3 = Color3.new()
Title2.TextStrokeTransparency = .25

local BoldTextNote = Instance.new('TextLabel',NotEnabledFrame)
BoldTextNote.BackgroundTransparency = 1
BoldTextNote.Position = UDim2.new(0,0,0,35)
BoldTextNote.Size = UDim2.new(1,0,0,30)
BoldTextNote.Font = Enum.Font.ArialBold
BoldTextNote.TextSize = '24'
BoldTextNote.Text = 'Smooth Terrain API is not enabled'
BoldTextNote.TextColor3 = Color3.new(1,1,1)
BoldTextNote.TextStrokeColor3 = Color3.new()
BoldTextNote.TextStrokeTransparency = .65

local SmallTextNote = Instance.new('TextLabel',NotEnabledFrame)
SmallTextNote.BackgroundTransparency = 1
SmallTextNote.Position = UDim2.new(0,0,0,60)
SmallTextNote.Size = UDim2.new(1,0,0,30)
SmallTextNote.Font = Enum.Font.SourceSansItalic
SmallTextNote.TextSize = '18'
SmallTextNote.Text = 'NOTE: Some materials from the Voxel Terrain will not be converted'
SmallTextNote.TextColor3 = Color3.new(1,1,1)
SmallTextNote.TextStrokeColor3 = Color3.new()
SmallTextNote.TextStrokeTransparency = .65

local ConvertButton = Instance.new('TextButton',NotEnabledFrame)
ConvertButton.BackgroundColor3 = Color3.new()
ConvertButton.BackgroundTransparency = .65
ConvertButton.BorderColor3 = Color3.new(1,1,1)
ConvertButton.BorderSizePixel = 2
ConvertButton.Position = UDim2.new(0,15,0,115)
ConvertButton.Size = UDim2.new(0,200,0,50)
ConvertButton.Font = Enum.Font.SourceSansBold
ConvertButton.TextSize = '24'
ConvertButton.Text = 'Convert'
ConvertButton.TextColor3 = Color3.new(1,1,1)
ConvertButton.TextStrokeColor3 = Color3.new()
ConvertButton.TextStrokeTransparency = .5

local CancelButton = Instance.new('TextButton',NotEnabledFrame)
CancelButton.BackgroundColor3 = Color3.new()
CancelButton.BackgroundTransparency = .65
CancelButton.BorderColor3 = Color3.new(1,1,1)
CancelButton.BorderSizePixel = 2
CancelButton.Position = UDim2.new(0,255,0,115)
CancelButton.Size = UDim2.new(0,200,0,50)
CancelButton.Font = Enum.Font.SourceSans
CancelButton.TextSize = '24'
CancelButton.Text = 'Cancel'
CancelButton.TextColor3 = Color3.new(1,1,1)
CancelButton.TextStrokeColor3 = Color3.new()
CancelButton.TextStrokeTransparency = .5

--PLUGIN EVENT
Button.Click:connect(function()
	if workspace.Terrain.IsSmooth then
		if not PluginEnabled then
			PluginEnabled = true
			MainFrame.Visible = true
			Plugin:Activate(true)
		else
			PluginEnabled = false
			MainFrame.Visible = false
		end
	else
		NotEnabledFrame.Visible = true
	end
end)

local UIButtons = {AsphaltButton,BasaltButton,BrickButton,CobblestoneButton,ConcreteButton,CrackedLavaButton,GlacierButton,GrassButton,GroundButton,IceButton,LeafyGrassButton,LimestoneButton,MudButton,PavementButton,RockButton,SaltButton,SandButton,SandstoneButton,SlateButton,SnowButton,WaterButton,WoodPlanksButton}
local Materials = {'Asphalt','Basalt','Brick','Cobblestone','Concrete','CrackedLava','Glacier','Grass','Ground','Ice','LeafyGrass','Limestone','Mud','Pavement','Rock','Salt','Sand','Sandstone','Slate','Snow','Water','WoodPlanks'}

local function UISelect(Value)
	Plugin:SetSetting('LastMaterialUsed', Value)
	MaterialSelect = Value
	for _,v in pairs(MaterialFrame:GetChildren()) do
		if (v:IsA('ImageButton')) then
			v.BorderSizePixel = 0
		end
	end
	UIButtons[Value].BorderSizePixel = 2
end

local function AddTerrain(Part)
	if Part then
		if Part.ClassName == 'Part' then
			if Part.Shape == Enum.PartType.Block then
				workspace.Terrain:FillBlock(Part.CFrame,Part.Size,Enum.Material[Materials[MaterialSelect]])
				Part:remove()
				ChangeHistoryService:SetWaypoint('Part to Terrain')
			end
		end
	end
end

--MOUSE/UI EVENTS
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

ConvertButton.MouseButton1Click:connect(function()workspace.Terrain:ConvertToSmooth() NotEnabledFrame.Visible = false end)
CancelButton.MouseButton1Click:connect(function()NotEnabledFrame.Visible = false end)

--SETTINGS
local SettingsMaterial = Plugin:GetSetting('LastMaterialUsed')
if SettingsMaterial == nil or 1 or SettingsMaterial > 22 then UISelect(1)else UISelect(SettingsMaterial)end

--CHECK FOR UPDATES
if MarketplaceService:GetProductInfo(302568422).Description ~= Version then 
	warn("Part to Terrain is outdated. Please update it for improvements.")
end
