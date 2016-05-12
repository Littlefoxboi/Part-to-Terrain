-- Made By Fastcar48
local Plugin = plugin or PluginManager():CreatePlugin()
local Toolbar = Plugin:CreateToolbar('Fastcar48')
local Button = Toolbar:CreateButton(
	'Part to Terrain',
	'Allows users to convert parts into terrain.',
	'rbxassetid://158526175'
)

local CurrentVersion = '2.3.4'
local Mouse = Plugin:GetMouse()
local PluginEnabled = false
local MaterialSelected = 1

-- Services
local ChangeHistoryService = game:GetService('ChangeHistoryService')
local ContentProviderService = game:GetService('ContentProvider')
local MarketplaceService = game:GetService('MarketplaceService')
local Selection = game:GetService('Selection')

-- UI
local GUI = Instance.new('ScreenGui',game.CoreGui)

-- Main Frame
local MainFrame = Instance.new('Frame',GUI)
MainFrame.BackgroundColor3 = Color3.new(1,1,1)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0,10,0,25)
MainFrame.Size = UDim2.new(0,170,0,250)
MainFrame.Visible = false

local Title = Instance.new('TextLabel',MainFrame)
Title.BackgroundColor3 = Color3.new(33/255,150/255,243/255)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0,0,0,-15)
Title.Size = UDim2.new(1,-1,0,15)
Title.Font = Enum.Font.SourceSansBold
Title.FontSize = Enum.FontSize.Size14
Title.Text = 'Part to Terrain [V:' ..CurrentVersion..']'
Title.TextColor3 = Color3.new(1,1,1)
Title.TextStrokeTransparency = 0.9
Title.TextXAlignment = Enum.TextXAlignment.Left

local HoverMaterial = Instance.new('TextLabel',MainFrame)
HoverMaterial.BackgroundColor3 = Color3.new(0,0,0)
HoverMaterial.BackgroundTransparency = 0.5
HoverMaterial.BorderSizePixel = 0 
HoverMaterial.Position = UDim2.new(0,0,1,0)
HoverMaterial.Size = UDim2.new(1,0,0,15)
HoverMaterial.Font = Enum.Font.SourceSans
HoverMaterial.FontSize = Enum.FontSize.Size14
HoverMaterial.TextColor3 = Color3.new(1,1,1)
HoverMaterial.Text = ''
HoverMaterial.TextYAlignment = Enum.TextYAlignment.Top

local function CreateImageButton(MaterialName,Position,AssetID)
	local Button = Instance.new('ImageButton',MainFrame)
	Button.BorderColor3 = Color3.new(33/255,150/255,243/255)
	Button.BorderSizePixel = 0
	Button.Position = Position
	Button.Size = UDim2.new(0,30,0,30)
	Button.Image = 'rbxassetid://'..AssetID
	ContentProviderService:Preload('rbxassetid://'..AssetID)
	Button.MouseEnter:connect(function()HoverMaterial.Text = MaterialName end)
	Button.MouseLeave:connect(function()HoverMaterial.Text = ''end)
	return Button
end

--Row 1
local GrassButton = CreateImageButton('Grass',UDim2.new(0,10,0,10),225314676)
local SandButton = CreateImageButton('Sand',UDim2.new(0,50,0,10),225315607)
local RockButton = CreateImageButton('Rock',UDim2.new(0,90,0,10),225315178)
local SlateButton = CreateImageButton('Slate',UDim2.new(0,130,0,10),225315290)

--Row 2
local WaterButton = CreateImageButton('Water',UDim2.new(0,10,0,50),225315529)
local WoodPlanksButton = CreateImageButton('Wood Planks',UDim2.new(0,50,0,50),225315705)
local BrickButton = CreateImageButton('Brick',UDim2.new(0,90,0,50),225315419)
local ConcreteButton = CreateImageButton('Concrete',UDim2.new(0,130,0,50),225314983)

--Row 3
local GlacierButton = CreateImageButton('Glacier',UDim2.new(0,10,0,90),254541572)
local SnowButton = CreateImageButton('Snow',UDim2.new(0,50,0,90),254541898)
local SandstoneButton = CreateImageButton('Sandstone',UDim2.new(0,90,0,90),254541350)
local MudButton = CreateImageButton('Mud',UDim2.new(0,130,0,90),254541862)

--Row 4
local BasaltButton = CreateImageButton('Basalt',UDim2.new(0,10,0,130),254542066)
local GroundButton = CreateImageButton('Ground',UDim2.new(0,50,0,130),254542189)
local CrackedLavaButton = CreateImageButton('Cracked Lava',UDim2.new(0,90,0,130),254541726)
local PavementButton = CreateImageButton('Pavement',UDim2.new(0,130,0,130),397727024)

--Row 5
local SaltButton = CreateImageButton('Salt',UDim2.new(0,10,0,170),397352299)
local LeafyGrassButton = CreateImageButton('Leafy Grass',UDim2.new(0,50,0,170),397720681)
local LimestoneButton = CreateImageButton('Limestone',UDim2.new(0,90,0,170),397352474)
local AsphaltButton = CreateImageButton('Asphalt',UDim2.new(0,130,0,170),397352644)

--Row 6
local IceButton = CreateImageButton('Ice',UDim2.new(0,10,0,210),397352205)
local CobblestoneButton = CreateImageButton('Cobblestone',UDim2.new(0,50,0,210),397352378)

local OutdatedText = Instance.new('TextLabel',MainFrame)
OutdatedText.BackgroundTransparency = 1
OutdatedText.Position = UDim2.new(0,0,1,15)
OutdatedText.Size = UDim2.new(1,0,0,47)
OutdatedText.Visible = false
OutdatedText.Font = Enum.Font.SourceSansBold
OutdatedText.FontSize = Enum.FontSize.Size14
OutdatedText.Text = 'New update available!\n This version you are using is outdated.'
OutdatedText.TextColor3 = Color3.new(1,1,1)
OutdatedText.TextStrokeColor3 = Color3.new(244/255,67/255,54/255)
OutdatedText.TextStrokeTransparency = 0.25
OutdatedText.TextWrapped = true

-- Convert to Smooth Terrain Frame
local ConvertTerrainFrame = Instance.new('Frame',GUI)
ConvertTerrainFrame.BackgroundColor3 = Color3.new(0,0,0)
ConvertTerrainFrame.BackgroundTransparency = 0.2
ConvertTerrainFrame.BorderSizePixel = 0
ConvertTerrainFrame.Position = UDim2.new(0.5,-250,0.5,-100)
ConvertTerrainFrame.Size = UDim2.new(0,500,0,200)
ConvertTerrainFrame.Visible = false

local TitleB = Instance.new('TextLabel',ConvertTerrainFrame)
TitleB.BackgroundColor3 = Color3.new(33/255,150/255,243/255)
TitleB.BackgroundTransparency = 0
TitleB.BorderSizePixel = 0
TitleB.Position = UDim2.new(0,0,0,0)
TitleB.Size = UDim2.new(0,500,0,20)
TitleB.Font = Enum.Font.SourceSans
TitleB.FontSize = Enum.FontSize.Size18
TitleB.Text = 'Part to Terrain'
TitleB.TextColor3 = Color3.new(1,1,1)
TitleB.TextStrokeColor3 = Color3.new(0,0,0)
TitleB.TextStrokeTransparency = 0.85

local DisabledNote = Instance.new('TextLabel',ConvertTerrainFrame)
DisabledNote.BackgroundTransparency = 1
DisabledNote.Position = UDim2.new(0,0,0,20)
DisabledNote.Size = UDim2.new(0,500,0,50)
DisabledNote.Font = Enum.Font.SourceSansBold
DisabledNote.FontSize = Enum.FontSize.Size32
DisabledNote.Text = 'Smooth Terrain API is not enabled.'
DisabledNote.TextColor3 = Color3.new(1,1,1)
DisabledNote.TextStrokeColor3 = Color3.new(0,0,0)
DisabledNote.TextStrokeTransparency = 0.75

local DisabledExtra = Instance.new('TextLabel',ConvertTerrainFrame)
DisabledExtra.BackgroundTransparency = 1
DisabledExtra.Position = UDim2.new(0,0,0,60)
DisabledExtra.Size = UDim2.new(1,0,0,70)
DisabledExtra.Font = Enum.Font.SourceSansLight
DisabledExtra.FontSize = Enum.FontSize.Size24
DisabledExtra.Text = "NOTE: Some of the voxel materials won't work when its coverted into smooth terrain."
DisabledExtra.TextColor3 = Color3.new(1,1,1)
DisabledExtra.TextStrokeColor3 = Color3.new(0,0,0)
DisabledExtra.TextStrokeTransparency = 0.75
DisabledExtra.TextWrapped = true

local ConvertButton = Instance.new('TextButton',ConvertTerrainFrame)
ConvertButton.Position = UDim2.new(0,10,0,140)
ConvertButton.Size = UDim2.new(0,225,0,50)
ConvertButton.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
ConvertButton.Font = Enum.Font.SourceSans
ConvertButton.FontSize = Enum.FontSize.Size24
ConvertButton.Text = 'Convert'
ConvertButton.TextColor3 = Color3.new(1,1,1)
ConvertButton.TextStrokeColor3 = Color3.new(0,0,0)
ConvertButton.TextStrokeTransparency = 0.8

local CancelConvertButton = Instance.new('TextButton',ConvertTerrainFrame)
CancelConvertButton.Position = UDim2.new(0,265,0,140)
CancelConvertButton.Size = UDim2.new(0,225,0,50)
CancelConvertButton.Style = Enum.ButtonStyle.RobloxRoundDropdownButton
CancelConvertButton.Font = Enum.Font.SourceSans
CancelConvertButton.FontSize = Enum.FontSize.Size24
CancelConvertButton.Text = 'Cancel'
CancelConvertButton.TextColor3 = Color3.new(27/255,42/255,53/255)
CancelConvertButton.TextStrokeTransparency = 1

-- Plugin Events
Button.Click:connect(function()
	if workspace.Terrain.IsSmooth == true then
		if PluginEnabled == false then
			PluginEnabled = true
			MainFrame.Visible = true
			Plugin:Activate(true)
		elseif PluginEnabled == true then
			PluginEnabled = false
			MainFrame.Visible = false
		end
	elseif workspace.Terrain.IsSmooth == false then
		ConvertTerrainFrame.Visible = true
		wait()
		ConvertTerrainFrame:TweenPosition(UDim2.new(0.5,-250,0.5,-100),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,.2)
	end
end)

ChangeHistoryService.OnUndo:connect(function(NameOfUndo)if NameOfUndo == 'Part to Terrain' then Selection:Set({})end end)

-- Select
local UIButtons = {GrassButton,SandButton,RockButton,SlateButton,WaterButton,WoodPlanksButton,BrickButton,ConcreteButton,GlacierButton,SnowButton,SandstoneButton,MudButton,BasaltButton,GroundButton,CrackedLavaButton,PavementButton,SaltButton,LeafyGrassButton,LimestoneButton,AsphaltButton,IceButton,CobblestoneButton}

local function Select(MaterialID)
	Plugin:SetSetting('LastMaterialUsed', MaterialID)
	MaterialSelected = MaterialID
	for i,v in pairs(MainFrame:GetChildren()) do
		if (v:IsA('ImageButton')) then
			v.BorderSizePixel = 0
		end
	end
	UIButtons[MaterialID].BorderSizePixel = 2
end

-- Add Terrain
local MaterialMap = {'Grass','Sand','Rock','Slate','Water','WoodPlanks','Brick','Concrete','Glacier','Snow','Sandstone','Mud','Basalt','Ground','CrackedLava','Pavement','Salt','LeafyGrass','Limestone','Asphalt','Ice','Cobblestone'}
local function AddTerrain(Part,TypeOfMaterial)
	local ref = MaterialMap[TypeOfMaterial]
	if Part then
		if Part.ClassName ~= 'Terrain' then
			if Part.ClassName == 'UnionOperation' or Part.ClassName == 'NegateOperation' or Part.ClassName == 'WedgePart' or Part.ClassName == 'TrussPart' or Part.ClassName == 'CornerWedgePart' or Part.Shape == Enum.PartType.Cylinder then else
				workspace.Terrain:FillBlock(Part.CFrame,Part.Size,Enum.Material[ref])
				Part:remove()
				ChangeHistoryService:SetWaypoint('Part to Terrain')
			end
		end
	end	
end

-- UI Events
GrassButton.MouseButton1Down:connect(function()Select(1)end)
SandButton.MouseButton1Down:connect(function()Select(2)end)
RockButton.MouseButton1Down:connect(function()Select(3)end)
SlateButton.MouseButton1Down:connect(function()Select(4)end)
WaterButton.MouseButton1Down:connect(function()Select(5)end)
WoodPlanksButton.MouseButton1Down:connect(function()Select(6)end)
BrickButton.MouseButton1Down:connect(function()Select(7)end)
ConcreteButton.MouseButton1Down:connect(function()Select(8)end)
GlacierButton.MouseButton1Down:connect(function()Select(9)end)
SnowButton.MouseButton1Down:connect(function()Select(10)end)
SandstoneButton.MouseButton1Down:connect(function()Select(11)end)
MudButton.MouseButton1Down:connect(function()Select(12)end)
BasaltButton.MouseButton1Down:connect(function()Select(13)end)
GroundButton.MouseButton1Down:connect(function()Select(14)end)
CrackedLavaButton.MouseButton1Down:connect(function()Select(15)end)
PavementButton.MouseButton1Down:connect(function()Select(16)end)
SaltButton.MouseButton1Down:connect(function()Select(17)end)
LeafyGrassButton.MouseButton1Down:connect(function()Select(18)end)
LimestoneButton.MouseButton1Down:connect(function()Select(19)end)
AsphaltButton.MouseButton1Down:connect(function()Select(20)end)
IceButton.MouseButton1Down:connect(function()Select(21)end)
CobblestoneButton.MouseButton1Down:connect(function()Select(22)end)

CancelConvertButton.MouseButton1Down:connect(function() ConvertTerrainFrame.Visible = false end)
ConvertButton.MouseButton1Down:connect(function() workspace.Terrain:ConvertToSmooth() ConvertTerrainFrame.Visible = false end)

-- Mouse Events
Mouse.Button1Down:connect(function()if PluginEnabled == true then AddTerrain(Mouse.Target,MaterialSelected)end end)

-- Settings
local LastMaterialUsed = Plugin:GetSetting('LastMaterialUsed')
if LastMaterialUsed == nil or LastMaterialUsed == 1 or LastMaterialUsed >= 22 then Select(1) else Select(LastMaterialUsed) end

-- Check for updates
local UpdatedVersion = MarketplaceService:GetProductInfo(302568422)
if UpdatedVersion.Description ~= CurrentVersion then OutdatedText.Visible = true end
