-- Made By Fasty48
local Button = plugin:CreateToolbar('Fastcar48'):CreateButton('Part to Terrain','','rbxassetid://297321964')
local Mouse = plugin:GetMouse()
local Version = '3.0.2'

local Color={
	Black = Color3.fromRGB(33,33,33),
	Blue = Color3.fromRGB(33,150,243),
	Green = Color3.fromRGB(76,175,80),
	Red = Color3.fromRGB(244,67,54),
	White = Color3.new(1,1,1),
	Yellow = Color3.fromRGB(255,235,59)
}

local Services={
	ChangeHistory = game:GetService('ChangeHistoryService'),
	Marketplace = game:GetService('MarketplaceService'),
	Run = game:GetService('RunService')
}

local Settings={
	PluginEnabled = false,
	MaterialSelected = 1
}

local UIButtons={}
local Materials={}

--------------------
--UI
--------------------
local UI = Instance.new('ScreenGui',game.CoreGui)

--Selection
local SelectionBox = Instance.new('SelectionBox',UI)
SelectionBox.Color3 = Color.Blue

local SelectionSphere = Instance.new('SelectionSphere',UI)
SelectionSphere.Color3 = Color.Blue

--Material selector
local MainFrame = Instance.new('Frame',UI)
MainFrame.Active = true
MainFrame.BackgroundColor3 = Color.Black
MainFrame.BackgroundTransparency = .5
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0,5,0,5)
MainFrame.Size = UDim2.new(0,185,0,270)
MainFrame.Visible = false

local header = Instance.new('Frame',MainFrame)
header.BackgroundColor3 = Color.Green
header.BorderSizePixel = 0
header.Size = UDim2.new(1,0,0,5)

local Title = Instance.new('TextLabel',MainFrame)
Title.BackgroundColor3 = Color.Black
Title.BackgroundTransparency = .5
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0,5,0,10)
Title.Size = UDim2.new(1,-10,0,20)
Title.Font = Enum.Font.SourceSansBold
Title.Text = 'Part to Terrain V'..Version
Title.TextColor3 = Color.White
Title.TextSize = 15

local HoverMaterial = Instance.new('TextLabel',MainFrame)
HoverMaterial.BackgroundColor3 = Color.Black
HoverMaterial.BackgroundTransparency = .5
HoverMaterial.BorderSizePixel = 0
HoverMaterial.Position = UDim2.new(0,5,0,245)
HoverMaterial.Size = UDim2.new(1,-10,0,20)
HoverMaterial.Font = Enum.Font.SourceSans
HoverMaterial.Text = ''
HoverMaterial.TextColor3 = Color.White
HoverMaterial.TextSize = 15

local PaddingFrame = Instance.new('Frame',MainFrame)
PaddingFrame.BackgroundColor3 = Color.Black
PaddingFrame.BackgroundTransparency = .5
PaddingFrame.BorderSizePixel = 0
PaddingFrame.Position = UDim2.new(0,5,0,35)
PaddingFrame.Size = UDim2.new(0,175,0,205)

local SelectionFrame = Instance.new('ScrollingFrame',PaddingFrame)
SelectionFrame.Active = true
SelectionFrame.BackgroundTransparency = 1
SelectionFrame.BorderSizePixel = 0
SelectionFrame.Position = UDim2.new(0,5,0,5)
SelectionFrame.Size = UDim2.new(0,165,0,195)
SelectionFrame.BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
SelectionFrame.CanvasSize = UDim2.new(0,0,1.15,0)
SelectionFrame.MidImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
SelectionFrame.ScrollBarThickness = 5
SelectionFrame.TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'

local GridLayout = Instance.new('UIGridLayout',SelectionFrame)
GridLayout.CellPadding = UDim2.new(0,5,0,5)
GridLayout.CellSize = UDim2.new(0,35,0,35)

local SelectedImg = Instance.new('ImageLabel')
SelectedImg.BackgroundTransparency = 1
SelectedImg.Size = UDim2.new(1,0,1,0)
SelectedImg.Image = 'rbxassetid://94907744'
SelectedImg.ImageColor3 = Color.Blue

--------------------
--Functions
--------------------
function Activate(bool)
	Settings.PluginEnabled = bool
	plugin:Activate(bool)
	Button:SetActive(bool)
	MainFrame.Visible = bool
	if not bool then
		SelectionBox.Adornee = nil
		SelectionSphere.Adornee = nil
	end
end

function AddTerrain(Part)
	local Material = Enum.Material[Materials[Settings.MaterialSelected]]
	if Part and Part:IsA('Part') then
		if Part.Shape == Enum.PartType.Block then
			workspace.Terrain:FillBlock(Part.CFrame,Part.Size,Material)
			Part:Remove()
			Services.ChangeHistory:SetWaypoint('PTT')
		elseif Part.Shape == Enum.PartType.Ball then
			workspace.Terrain:FillBall(Part.Position,Part.Size.X/2,Material)
			Part:Remove()
			Services.ChangeHistory:SetWaypoint('PTT')
		else
			CreateErrorMsg('Shape is not supported.')
		end
	else
		CreateErrorMsg('Part Type is not supported.')
	end
end

function CreateErrorMsg(reason)
	local Error_MainFrame = Instance.new('Frame',UI)
	Error_MainFrame.BackgroundColor3 = Color.Black
	Error_MainFrame.BackgroundTransparency = .5
	Error_MainFrame.BorderSizePixel = 0
	Error_MainFrame.Position = UDim2.new(.5,-150,.9,-100)
	Error_MainFrame.Size = UDim2.new(0,300,0,90)

	local header_b = header:Clone()
	header_b.Parent = Error_MainFrame
	header_b.BackgroundColor3 = Color.Red

	local Error_Title = Instance.new('TextLabel',Error_MainFrame)
	Error_Title.BackgroundTransparency = 1
	Error_Title.Position = UDim2.new(0,0,0,10)
	Error_Title.Size = UDim2.new(1,0,0,20)
	Error_Title.Font = Enum.Font.SourceSansBold
	Error_Title.Text = 'Part to Terrain Error'
	Error_Title.TextColor3 = Color.White
	Error_Title.TextSize = 15

	local Reason = Instance.new('TextLabel',Error_MainFrame)
	Reason.BackgroundTransparency = 1
	Reason.Position = UDim2.new(0,0,0,40)
	Reason.Size = UDim2.new(1,0,0,40)
	Reason.Font = Enum.Font.SourceSans
	Reason.Text = reason
	Reason.TextColor3 = Color.White
	Reason.TextSize = 15
	Reason.TextWrapped = true

	game.Debris:AddItem(Error_MainFrame,5)
end

function CreateImgBtn(Name,ID,Enum)
	local Btn = Instance.new('ImageButton',SelectionFrame)
	Btn.BorderSizePixel = 0
	Btn.Image = 'rbxassetid://'..ID
	Btn.Name = Name
	table.insert(UIButtons,Btn)
	if not Enum then
		table.insert(Materials,Name)
	else
		table.insert(Materials,Enum)
	end
	Btn.LayoutOrder = #UIButtons
	Btn.MouseButton1Click:connect(function()
		Settings.MaterialSelected = Btn.LayoutOrder
		SelectedImg.Parent = UIButtons[Btn.LayoutOrder]
	end)
	Btn.MouseEnter:connect(function() HoverMaterial.Text = Name end)
	Btn.MouseLeave:connect(function() HoverMaterial.Text = '' end)
	return Btn
end

function CreateUpdateMsg()
	local Update_MainFrame = Instance.new('Frame',UI)
	Update_MainFrame.BackgroundColor3 = Color.Black
	Update_MainFrame.BackgroundTransparency = .5
	Update_MainFrame.BorderSizePixel = 0
	Update_MainFrame.Position = UDim2.new(1,-200,0.8,0)
	Update_MainFrame.Size = UDim2.new(0,200,0,75)

	local header_c = header:Clone()
	header_c.Parent = Update_MainFrame
	header_c.BackgroundColor3 = Color.Yellow

	local Update_Title = Instance.new('TextLabel',Update_MainFrame)
	Update_Title.BackgroundTransparency = 1
	Update_Title.Position = UDim2.new(0,0,0,10)
	Update_Title.Size = UDim2.new(1,0,0,20)
	Update_Title.Font = Enum.Font.SourceSansBold
	Update_Title.Text = 'Part to Terrain Update'
	Update_Title.TextColor3 = Color.White
	Update_Title.TextSize = 15

	local Update_Desc = Instance.new('TextLabel',Update_MainFrame)
	Update_Desc.BackgroundTransparency = 1
	Update_Desc.Position = UDim2.new(0,0,0,35)
	Update_Desc.Size = UDim2.new(1,0,0,35)
	Update_Desc.Font = Enum.Font.SourceSans
	Update_Desc.Text = 'The current Part to Terrain version you are running is outdated.'
	Update_Desc.TextColor3 = Color.White
	Update_Desc.TextSize = 15
	Update_Desc.TextWrapped = true

	local Update_Btn = Instance.new('TextButton',Update_MainFrame)
	Update_Btn.BackgroundColor3 = Color.Black
	Update_Btn.BackgroundTransparency = .5
	Update_Btn.BorderSizePixel = 0
	Update_Btn.Position = UDim2.new(0,-30,0,0)
	Update_Btn.Size = UDim2.new(0,30,0,30)
	Update_Btn.Font = Enum.Font.SourceSansBold
	Update_Btn.Text = 'X'
	Update_Btn.TextColor3 = Color.White
	Update_Btn.TextSize = 20
	Update_Btn.MouseButton1Click:connect(function() Update_MainFrame:Remove() end)
end

--------------------
--Material List
--------------------
CreateImgBtn('Air',765103830)
CreateImgBtn('Asphalt',397352644)
CreateImgBtn('Basalt',254542066)
CreateImgBtn('Brick',225315419)
CreateImgBtn('Cobblestone',397352378)
CreateImgBtn('Concrete',225314983)
CreateImgBtn('Cracked Lava',254541726,'CrackedLava')
CreateImgBtn('Glacier',254541572)
CreateImgBtn('Grass',225314676)
CreateImgBtn('Ground',254542189)
CreateImgBtn('Ice',397352205)
CreateImgBtn('Leafy Grass',397720681,'LeafyGrass')
CreateImgBtn('Limestone',397352474)
CreateImgBtn('Mud',254541862)
CreateImgBtn('Pavement',397727024)
CreateImgBtn('Rock',225315178)
CreateImgBtn('Salt',397352299)
CreateImgBtn('Sand',225315607)
CreateImgBtn('Sandstone',254541350)
CreateImgBtn('Slate',225315290)
CreateImgBtn('Snow',254541898)
CreateImgBtn('Water',225315529)
CreateImgBtn('Wooden Planks',225315705,'WoodPlanks')

--------------------
--Mouse Events
--------------------
Mouse.Move:connect(function()
	local Part = Mouse.Target
	if Settings.PluginEnabled then
		if Part and Part:IsA('Part') then
			if Part.Shape == Enum.PartType.Block then
				SelectionBox.Adornee = Part
				SelectionSphere.Adornee = nil
			elseif Part.Shape == Enum.PartType.Ball then
				SelectionBox.Adornee = nil
				SelectionSphere.Adornee = Part
			end
		else
			SelectionBox.Adornee = nil
			SelectionSphere.Adornee = nil
		end
	end
end)

Mouse.Button1Down:connect(function()
	if Settings.PluginEnabled then
		AddTerrain(Mouse.Target)
	end
end)

--------------------
--Plugin Events
--------------------
Button.Click:connect(function()
	if not Services.Run:IsRunning() then
		Activate(not Settings.PluginEnabled)
	else
		CreateErrorMsg("Part to Terrain will not work while on 'Play Solo' or 'Play'.")
	end
end)

plugin.Deactivation:connect(function()
	if Settings.PluginEnabled and MainFrame.Visible then
		Activate(false)
	end
end)

--------------------
--Services Events
--------------------
Services.ChangeHistory.OnUndo:connect(function(change)
	if change == 'PTT' then
		game.Selection:Set({})
	end
end)

--------------------
--Update Checker
--------------------
local UpdatedVersion = Services.Marketplace:GetProductInfo(302568422).Description
if UpdatedVersion ~= Version and not Services.Run:IsRunning() then
	CreateUpdateMsg()
end