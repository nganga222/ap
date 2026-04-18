local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

local enabled       = false
local showNames     = false
local showHealth    = false
local showSkeleton  = false
local showHitboxes  = false
local hitboxScale   = 1
local walkSpeed     = 16
local FLY_SPEED     = 60
local infiniteJump  = false
local flightArmed   = false
local isFlying      = false
local tracked       = {}
local guiEnabled    = true

local applyTheme

-- =========================
-- THEMES
-- =========================

local THEMES = {
    {
        id = "Default", name = "Default",
        menuBg        = Color3.fromRGB(35,35,35),
        topBarBg      = Color3.fromRGB(22,22,22),
        sidebarBg     = Color3.fromRGB(27,27,27),
        divider       = Color3.fromRGB(50,50,50),
        stroke        = Color3.fromRGB(255,255,255),
        accent        = Color3.fromRGB(215,215,215),
        sideSelected  = Color3.fromRGB(44,44,44),
        sideHover     = Color3.fromRGB(35,35,35),
        sideNormal    = Color3.fromRGB(27,27,27),
        labelSel      = Color3.fromRGB(240,240,240),
        labelNorm     = Color3.fromRGB(125,125,125),
        pageTitle     = Color3.fromRGB(108,108,108),
        toggleOn      = Color3.fromRGB(120,120,120),
        toggleOff     = Color3.fromRGB(55,55,55),
        sliderFill    = Color3.fromRGB(180,180,180),
        sliderTrack   = Color3.fromRGB(55,55,55),
        btnBg         = Color3.fromRGB(50,50,50),
        dropdownBg    = Color3.fromRGB(27,27,27),
        dropdownStroke= Color3.fromRGB(60,60,60),
        gradient      = false,
        font          = Enum.Font.SourceSans,
        fontBold      = Enum.Font.SourceSansBold,
    },
    {
        id = "Amethyst", name = "Amethyst",
        menuBg        = Color3.fromRGB(28,18,42),
        topBarBg      = Color3.fromRGB(18,10,32),
        sidebarBg     = Color3.fromRGB(22,13,36),
        divider       = Color3.fromRGB(70,40,100),
        stroke        = Color3.fromRGB(190,100,255),
        accent        = Color3.fromRGB(190,100,255),
        sideSelected  = Color3.fromRGB(55,30,80),
        sideHover     = Color3.fromRGB(38,20,55),
        sideNormal    = Color3.fromRGB(22,13,36),
        labelSel      = Color3.fromRGB(220,160,255),
        labelNorm     = Color3.fromRGB(140,90,180),
        pageTitle     = Color3.fromRGB(160,80,220),
        toggleOn      = Color3.fromRGB(165,70,230),
        toggleOff     = Color3.fromRGB(55,30,80),
        sliderFill    = Color3.fromRGB(185,95,255),
        sliderTrack   = Color3.fromRGB(55,30,80),
        btnBg         = Color3.fromRGB(70,30,110),
        dropdownBg    = Color3.fromRGB(28,15,44),
        dropdownStroke= Color3.fromRGB(100,50,150),
        gradient      = true,
        gradColor0    = Color3.fromRGB(28,18,42),
        gradColor1    = Color3.fromRGB(52,16,76),
        font          = Enum.Font.SourceSans,
        fontBold      = Enum.Font.SourceSansBold,
    },
    {
        id = "Ocean", name = "Ocean",
        menuBg        = Color3.fromRGB(235,252,255),
        topBarBg      = Color3.fromRGB(29,77,107),
        sidebarBg     = Color3.fromRGB(235,252,255),
        divider       = Color3.fromRGB(217,220,214),
        stroke        = Color3.fromRGB(217,220,214),
        accent        = Color3.fromRGB(217,220,214),
        sideSelected  = Color3.fromRGB(15,55,80),
        sideHover     = Color3.fromRGB(12,42,62),
        sideNormal    = Color3.fromRGB(20,45,69),
        labelSel      = Color3.fromRGB(255,255,255),
        labelNorm     = Color3.fromRGB(255,255,255),
        pageTitle     = Color3.fromRGB(255,255,255),
        toggleOn      = Color3.fromRGB(129,195,215),
        toggleOff     = Color3.fromRGB(20,58,80),
        sliderFill    = Color3.fromRGB(129,195,215),
        sliderTrack   = Color3.fromRGB(20,58,80),
        btnBg         = Color3.fromRGB(15,65,95),
        dropdownBg    = Color3.fromRGB(10,28,45),
        dropdownStroke= Color3.fromRGB(217,220,214),
        gradient      = true,
        gradColor0    = Color3.fromRGB(0,126,167),
        gradColor1    = Color3.fromRGB(13,75,105),
        font          = Enum.Font.SourceSans,
        fontBold      = Enum.Font.SourceSansBold,
    },
    {
        id = "Sapphire", name = "Sapphire",
        menuBg        = Color3.fromRGB(10,18,40),
        topBarBg      = Color3.fromRGB(6,10,28),
        sidebarBg     = Color3.fromRGB(8,14,34),
        divider       = Color3.fromRGB(30,60,130),
        stroke        = Color3.fromRGB(60,130,255),
        accent        = Color3.fromRGB(60,130,255),
        sideSelected  = Color3.fromRGB(20,45,110),
        sideHover     = Color3.fromRGB(15,30,80),
        sideNormal    = Color3.fromRGB(8,14,34),
        labelSel      = Color3.fromRGB(160,200,255),
        labelNorm     = Color3.fromRGB(70,110,190),
        pageTitle     = Color3.fromRGB(80,150,255),
        toggleOn      = Color3.fromRGB(40,100,230),
        toggleOff     = Color3.fromRGB(20,45,110),
        sliderFill    = Color3.fromRGB(70,140,255),
        sliderTrack   = Color3.fromRGB(20,45,110),
        btnBg         = Color3.fromRGB(18,50,130),
        dropdownBg    = Color3.fromRGB(8,14,40),
        dropdownStroke= Color3.fromRGB(40,80,180),
        gradient      = true,
        gradColor0    = Color3.fromRGB(10,18,40),
        gradColor1    = Color3.fromRGB(18,10,60),
        font          = Enum.Font.SourceSans,
        fontBold      = Enum.Font.SourceSansBold,
    },
    {
        id = "Matrix", name = "Matrix",
        menuBg        = Color3.fromRGB(0,12,0),
        topBarBg      = Color3.fromRGB(0,6,0),
        sidebarBg     = Color3.fromRGB(0,10,0),
        divider       = Color3.fromRGB(0,55,0),
        stroke        = Color3.fromRGB(0,200,0),
        accent        = Color3.fromRGB(0,200,0),
        sideSelected  = Color3.fromRGB(0,38,0),
        sideHover     = Color3.fromRGB(0,26,0),
        sideNormal    = Color3.fromRGB(0,10,0),
        labelSel      = Color3.fromRGB(0,255,70),
        labelNorm     = Color3.fromRGB(0,130,30),
        pageTitle     = Color3.fromRGB(0,190,45),
        toggleOn      = Color3.fromRGB(0,160,30),
        toggleOff     = Color3.fromRGB(0,38,0),
        sliderFill    = Color3.fromRGB(0,200,50),
        sliderTrack   = Color3.fromRGB(0,38,0),
        btnBg         = Color3.fromRGB(0,38,10),
        dropdownBg    = Color3.fromRGB(0,8,0),
        dropdownStroke= Color3.fromRGB(0,80,20),
        gradient      = true,
        gradColor0    = Color3.fromRGB(0,12,0),
        gradColor1    = Color3.fromRGB(0,22,5),
        font          = Enum.Font.Code,
        fontBold      = Enum.Font.Code,
    },
}

local currentTheme = THEMES[1]

local themedRefs = {
    toggles      = {},
    sliderFills  = {},
    sliderTracks = {},
    buttons      = {},
    pageTitles   = {},
    pageDividers = {},
    textNormal   = {},
    textBold     = {},
}

local menuGradient    = nil
local sidebarGradient = nil
local topBarBottomFill = nil
local sbarRightFill    = nil
local sbarTopFill      = nil

-- =========================
-- FLIGHT STATE
-- =========================

local flyBV = nil
local flyBG = nil

local function stopFlight()
    isFlying = false
    if flyBV and flyBV.Parent then flyBV:Destroy() end
    if flyBG and flyBG.Parent then flyBG:Destroy() end
    flyBV, flyBG = nil, nil
    local char = localPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

local function startFlight()
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    isFlying = true
    hum.PlatformStand = true
    flyBV = Instance.new("BodyVelocity")
    flyBV.Velocity = Vector3.zero
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
    flyBG.D = 100
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp
end

-- =========================
-- BONE CONNECTIONS
-- =========================

local BONES_R6 = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}
local BONES_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},
    {"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},
    {"RightLowerArm","RightHand"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}

-- =========================
-- SKELETON GUI
-- =========================

local skeletonGui = Instance.new("ScreenGui")
skeletonGui.Name = "SkeletonESP"
skeletonGui.ResetOnSpawn = false
skeletonGui.DisplayOrder = 1
skeletonGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- =========================
-- LOADING SCREEN
-- =========================

local loadGui = Instance.new("ScreenGui")
loadGui.Name = "LoadingScreen"
loadGui.ResetOnSpawn = false
loadGui.DisplayOrder = 100
loadGui.Parent = localPlayer:WaitForChild("PlayerGui")

local loadBg = Instance.new("Frame")
loadBg.AnchorPoint = Vector2.new(0.5,0.5)
loadBg.Position = UDim2.new(0.5,0,0.5,0)
loadBg.Size = UDim2.new(0,320,0,160)
loadBg.BackgroundColor3 = Color3.fromRGB(20,20,20)
loadBg.BorderSizePixel = 0
loadBg.ZIndex = 1
loadBg.Parent = loadGui
Instance.new("UICorner", loadBg).CornerRadius = UDim.new(0,8)
local loadStroke = Instance.new("UIStroke")
loadStroke.Color = Color3.fromRGB(255,255,255)
loadStroke.Thickness = 1
loadStroke.Parent = loadBg

local loadTitle = Instance.new("TextLabel")
loadTitle.AnchorPoint = Vector2.new(0.5,0.5)
loadTitle.Position = UDim2.new(0.5,0,0.35,0)
loadTitle.Size = UDim2.new(1,-20,0,40)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "ADMIN PANEL"
loadTitle.TextColor3 = Color3.fromRGB(255,255,255)
loadTitle.Font = Enum.Font.SourceSansBold
loadTitle.TextSize = 26
loadTitle.ZIndex = 2
loadTitle.Parent = loadBg

local loadSub = Instance.new("TextLabel")
loadSub.AnchorPoint = Vector2.new(0.5,0.5)
loadSub.Position = UDim2.new(0.5,0,0.55,0)
loadSub.Size = UDim2.new(1,-20,0,25)
loadSub.BackgroundTransparency = 1
loadSub.Text = "Loading..."
loadSub.TextColor3 = Color3.fromRGB(160,160,160)
loadSub.Font = Enum.Font.SourceSans
loadSub.TextSize = 16
loadSub.ZIndex = 2
loadSub.Parent = loadBg

local barTrack = Instance.new("Frame")
barTrack.AnchorPoint = Vector2.new(0.5,0.5)
barTrack.Position = UDim2.new(0.5,0,0.75,0)
barTrack.Size = UDim2.new(0,200,0,4)
barTrack.BackgroundColor3 = Color3.fromRGB(50,50,50)
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 2
barTrack.Parent = loadBg
Instance.new("UICorner", barTrack).CornerRadius = UDim.new(1,0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 3
barFill.Parent = barTrack
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

task.spawn(function()
    local dots = {"Loading.","Loading..","Loading..."}
    local i = 1
    while loadGui and loadGui.Parent do
        loadSub.Text = dots[i]
        i = (i % #dots) + 1
        task.wait(0.4)
    end
end)

local barTween = TweenService:Create(barFill,
    TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    {Size = UDim2.new(1,0,1,0)})
barTween:Play()

-- =========================
-- MAIN GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "ESP_MenuUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false
gui.Parent = localPlayer:WaitForChild("PlayerGui")

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0,375,0,340)
menu.AnchorPoint = Vector2.new(0.5,0.5)
menu.Position = UDim2.new(0.5,0,0.5,0)
menu.BackgroundColor3 = currentTheme.menuBg
menu.BorderSizePixel = 0
menu.ClipsDescendants = true
menu.Active = true
menu.ZIndex = 1
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0,6)
menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = currentTheme.stroke
menuStroke.Thickness = 1.2
menuStroke.Parent = menu

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,29)
topBar.Position = UDim2.new(0,0,0,0)
topBar.BackgroundColor3 = currentTheme.topBarBg
topBar.BorderSizePixel = 0
topBar.ZIndex = 2
topBar.Parent = menu
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,6)
topBarBottomFill = Instance.new("Frame")
topBarBottomFill.Size = UDim2.new(1,0,0,6)
topBarBottomFill.Position = UDim2.new(0,0,1,-6)
topBarBottomFill.BackgroundColor3 = currentTheme.topBarBg
topBarBottomFill.BorderSizePixel = 0
topBarBottomFill.ZIndex = topBar.ZIndex
topBarBottomFill.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-60,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ADMIN PANEL"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 3
titleLabel.Parent = topBar
table.insert(themedRefs.textBold, titleLabel)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,28,1,0)
minimizeBtn.Position = UDim2.new(1,-56,0,0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.ZIndex = 3
minimizeBtn.Parent = topBar
table.insert(themedRefs.textBold, minimizeBtn)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,28,1,0)
closeBtn.Position = UDim2.new(1,-28,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.ZIndex = 3
closeBtn.Parent = topBar
table.insert(themedRefs.textBold, closeBtn)

-- SIDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,85,1,-29)
sidebar.Position = UDim2.new(0,0,0,29)
sidebar.BackgroundColor3 = currentTheme.sidebarBg
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = menu
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,6)
sbarRightFill = Instance.new("Frame")
sbarRightFill.Size = UDim2.new(0,6,1,0)
sbarRightFill.Position = UDim2.new(1,-6,0,0)
sbarRightFill.BackgroundColor3 = currentTheme.sidebarBg
sbarRightFill.BorderSizePixel = 0
sbarRightFill.ZIndex = sidebar.ZIndex
sbarRightFill.Parent = sidebar
sbarTopFill = Instance.new("Frame")
sbarTopFill.Size = UDim2.new(1,0,0,6)
sbarTopFill.Position = UDim2.new(0,0,0,0)
sbarTopFill.BackgroundColor3 = currentTheme.sidebarBg
sbarTopFill.BorderSizePixel = 0
sbarTopFill.ZIndex = sidebar.ZIndex
sbarTopFill.Parent = sidebar

local sideDivider = Instance.new("Frame")
sideDivider.Size = UDim2.new(0,1,1,-29)
sideDivider.Position = UDim2.new(0,85,0,29)
sideDivider.BackgroundColor3 = currentTheme.divider
sideDivider.BorderSizePixel = 0
sideDivider.ZIndex = 2
sideDivider.Parent = menu

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1,-86,1,-29)
contentFrame.Position = UDim2.new(0,86,0,29)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.ZIndex = 2
contentFrame.Parent = menu

-- =========================
-- SIDEBAR SECTIONS + PAGE FRAMES
-- =========================

local sidebarSections = {
    {id="Visuals",  label="Visuals"},
    {id="Target",   label="Target"},
    {id="Movement", label="Movement"},
    {id="Settings", label="Settings"},
    {id="Credits",  label="Credits"},
}

local currentPage = "Visuals"
local sidebarBtns = {}
local pageFrames  = {}

local function switchPage(id)
    for sid, btn in pairs(sidebarBtns) do
        local sel = (sid == id)
        TweenService:Create(btn.item, TweenInfo.new(0.12), {
            BackgroundColor3 = sel and currentTheme.sideSelected or currentTheme.sideNormal,
        }):Play()
        btn.accent.Visible = sel
        btn.lbl.TextColor3 = sel and currentTheme.labelSel or currentTheme.labelNorm
    end
    for pid, pframe in pairs(pageFrames) do
        pframe.Visible = (pid == id)
    end
    currentPage = id
end

for i, sec in ipairs(sidebarSections) do
    local isSelected = (sec.id == currentPage)

    local item = Instance.new("Frame")
    item.Size = UDim2.new(1,0,0,44)
    item.Position = UDim2.new(0,0,0,(i-1)*44)
    item.BackgroundColor3 = isSelected and currentTheme.sideSelected or currentTheme.sideNormal
    item.BorderSizePixel = 0
    item.ZIndex = 2
    item.Parent = sidebar

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0,3,1,0)
    accent.BackgroundColor3 = currentTheme.accent
    accent.BorderSizePixel = 0
    accent.Visible = isSelected
    accent.ZIndex = 3
    accent.Parent = item

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-6,1,0)
    lbl.Position = UDim2.new(0,6,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = sec.label
    lbl.TextColor3 = isSelected and currentTheme.labelSel or currentTheme.labelNorm
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 12
    lbl.ZIndex = 3
    lbl.Parent = item
    table.insert(themedRefs.textBold, lbl)

    local hitBtn = Instance.new("TextButton")
    hitBtn.Size = UDim2.new(1,0,1,0)
    hitBtn.BackgroundTransparency = 1
    hitBtn.Text = ""
    hitBtn.ZIndex = 4
    hitBtn.Parent = item

    hitBtn.MouseEnter:Connect(function()
        if currentPage ~= sec.id then
            TweenService:Create(item, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.sideHover}):Play()
        end
    end)
    hitBtn.MouseLeave:Connect(function()
        if currentPage ~= sec.id then
            TweenService:Create(item, TweenInfo.new(0.1), {BackgroundColor3 = currentTheme.sideNormal}):Play()
        end
    end)

    local capturedId = sec.id
    hitBtn.MouseButton1Click:Connect(function() switchPage(capturedId) end)
    sidebarBtns[sec.id] = {item=item, accent=accent, lbl=lbl}

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = isSelected
    page.ZIndex = 2
    page.Parent = contentFrame
    pageFrames[sec.id] = page
end

-- =========================
-- TOGGLE BUILDER
-- =========================

local function makeToggle(parent, labelText, yPos, defaultOn, onChange)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-68,0,26)
    label.Position = UDim2.new(0,10,0,yPos)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = parent
    table.insert(themedRefs.textNormal, label)

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0,44,0,24)
    track.Position = UDim2.new(1,-54,0,yPos+1)
    track.BackgroundColor3 = defaultOn and currentTheme.toggleOn or currentTheme.toggleOff
    track.BorderSizePixel = 0
    track.ZIndex = 3
    track.Parent = parent
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,20,0,20)
    knob.AnchorPoint = Vector2.new(0,0.5)
    knob.Position = defaultOn and UDim2.new(0,22,0.5,0) or UDim2.new(0,2,0.5,0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 4
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local ks = Instance.new("UIStroke")
    ks.Color = Color3.fromRGB(0,0,0)
    ks.Thickness = 1
    ks.Transparency = 0.72
    ks.Parent = knob

    local hitBtn = Instance.new("TextButton")
    hitBtn.Size = UDim2.new(1,0,1,0)
    hitBtn.BackgroundTransparency = 1
    hitBtn.Text = ""
    hitBtn.ZIndex = 5
    hitBtn.Parent = track

    local toggled = defaultOn

    local function setState(state, silent)
        toggled = state
        TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = toggled and UDim2.new(0,22,0.5,0) or UDim2.new(0,2,0.5,0),
        }):Play()
        TweenService:Create(track, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            BackgroundColor3 = toggled and currentTheme.toggleOn or currentTheme.toggleOff,
        }):Play()
        if not silent and onChange then onChange(toggled) end
    end

    hitBtn.MouseButton1Click:Connect(function() setState(not toggled) end)
    table.insert(themedRefs.toggles, {track=track, getState=function() return toggled end})
    return {label=label, track=track, knob=knob, isOn=function() return toggled end, set=setState}
end

-- =========================
-- SLIDER BUILDER
-- =========================

local function makeSlider(parent, labelText, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-14,0,18)
    label.Position = UDim2.new(0,10,0,yPos)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    label.Parent = parent
    table.insert(themedRefs.textNormal, label)

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,-20,0,8)
    track.Position = UDim2.new(0,10,0,yPos+22)
    track.BackgroundColor3 = currentTheme.sliderTrack
    track.BorderSizePixel = 0
    track.ClipsDescendants = false
    track.ZIndex = 3
    track.Parent = parent
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = currentTheme.sliderFill
    fill.BorderSizePixel = 0
    fill.ZIndex = 4
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,16,0,16)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.Position = UDim2.new(0,0,0.5,0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local hitArea = Instance.new("TextButton")
    hitArea.Size = UDim2.new(1,0,0,40)
    hitArea.Position = UDim2.new(0,0,0.5,-20)
    hitArea.BackgroundTransparency = 1
    hitArea.Text = ""
    hitArea.ZIndex = 7
    hitArea.Parent = track

    table.insert(themedRefs.sliderFills,  fill)
    table.insert(themedRefs.sliderTracks, track)
    return {label=label, track=track, fill=fill, knob=knob, hitArea=hitArea}
end

local function connectSlider(s, onAlpha)
    local isDragging = false
    local function apply(x)
        local abs   = s.track.AbsolutePosition
        local sz    = s.track.AbsoluteSize
        local alpha = math.clamp((x - abs.X) / sz.X, 0, 1)
        s.knob.Position = UDim2.new(alpha,0,0.5,0)
        s.fill.Size     = UDim2.new(alpha,0,1,0)
        onAlpha(alpha)
    end
    s.hitArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            apply(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            apply(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
    end)
end

-- =========================
-- BUTTON BUILDER
-- =========================

local function makeButton(parent, labelText, yPos, bgColor)
    local bgRef = {color = bgColor or currentTheme.btnBg}

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,28)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.BackgroundColor3 = bgRef.color
    btn.BorderSizePixel = 0
    btn.Text = labelText
    btn.TextColor3 = Color3.fromRGB(210,210,210)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.ZIndex = 3
    btn.Parent = parent
    table.insert(themedRefs.textBold, btn)

    btn.MouseEnter:Connect(function()
        local col = bgRef.color
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(col.R*255+18, 0, 255),
                math.clamp(col.G*255+18, 0, 255),
                math.clamp(col.B*255+18, 0, 255)),
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = bgRef.color}):Play()
    end)

    table.insert(themedRefs.buttons, {btn=btn, bgRef=bgRef})
    return btn
end

-- =========================
-- PAGE HELPERS
-- =========================

local function makePageTitle(page, text)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-14,0,18)
    title.Position = UDim2.new(0,10,0,9)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = currentTheme.pageTitle
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = page
    table.insert(themedRefs.pageTitles, title)
    table.insert(themedRefs.textBold, title)

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1,-14,0,1)
    line.Position = UDim2.new(0,7,0,28)
    line.BackgroundColor3 = currentTheme.divider
    line.BorderSizePixel = 0
    line.ZIndex = 3
    line.Parent = page
    table.insert(themedRefs.pageDividers, line)
end

local function makeDivider(page, yPos)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1,-14,0,1)
    d.Position = UDim2.new(0,7,0,yPos)
    d.BackgroundColor3 = currentTheme.divider
    d.BorderSizePixel = 0
    d.ZIndex = 3
    d.Parent = page
    table.insert(themedRefs.pageDividers, d)
    return d
end

-- =========================
-- VISUALS PAGE
-- =========================

local vPage = pageFrames["Visuals"]
makePageTitle(vPage, "VISUALS")

makeToggle(vPage, "ESP", 36, false, function(state)
    enabled = state
    for _, data in pairs(tracked) do
        if data.highlight then data.highlight.Enabled = enabled and not showSkeleton end
        if data.billboard then data.billboard.Enabled = enabled end
        if data.hitbox    then data.hitbox.Visible    = enabled and showHitboxes end
    end
end)

makeToggle(vPage, "Show Names", 70, false, function(state)
    showNames = state
    for _, data in pairs(tracked) do
        if data.nameLabel then data.nameLabel.Visible = state end
        if data.sep       then data.sep.Visible       = state and showHealth end
    end
end)

makeToggle(vPage, "Show Health", 104, false, function(state)
    showHealth = state
    for _, data in pairs(tracked) do
        if data.healthLabel then data.healthLabel.Visible = state end
        if data.sep         then data.sep.Visible         = showNames and state end
    end
end)

makeToggle(vPage, "Skeleton ESP", 138, false, function(state)
    showSkeleton = state
    for _, data in pairs(tracked) do
        if data.highlight then data.highlight.Enabled = enabled and not state end
        if not state then
            if data.bones then
                for _, b in ipairs(data.bones) do
                    if b.line then b.line.Visible = false end
                end
            end
        end
    end
end)

local hitboxSlider

makeToggle(vPage, "Hitboxes", 172, false, function(state)
    showHitboxes = state
    if hitboxSlider then
        hitboxSlider.label.Visible = state
        hitboxSlider.track.Visible = state
    end
    for _, data in pairs(tracked) do
        if data.hitbox then data.hitbox.Visible = state and enabled end
    end
end)

makeDivider(vPage, 206)

hitboxSlider = makeSlider(vPage, "Hitbox Size: 1", 213)
hitboxSlider.label.Visible = false
hitboxSlider.track.Visible = false
connectSlider(hitboxSlider, function(alpha)
    hitboxScale = math.floor((1 + alpha*24)*10)/10
    hitboxSlider.label.Text = "Hitbox Size: " .. hitboxScale
end)

-- =========================
-- TARGET PAGE
-- =========================

local tPage = pageFrames["Target"]
makePageTitle(tPage, "TARGET")

local selectedTarget = nil
local isSpectating   = false
local spectateConn   = nil

local function stopSpectate()
    isSpectating = false
    if spectateConn then spectateConn:Disconnect(); spectateConn = nil end
    local myChar = localPlayer.Character
    if myChar then
        local hum = myChar:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject = hum end
    end
end

local function startSpectate(target)
    if not target then return end
    local char = target.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    stopSpectate()
    workspace.CurrentCamera.CameraSubject = hum
    isSpectating = true
    spectateConn = target.CharacterAdded:Connect(function(newChar)
        local newHum = newChar:WaitForChild("Humanoid", 5)
        if newHum and isSpectating then
            workspace.CurrentCamera.CameraSubject = newHum
        end
    end)
end

local tScroll = Instance.new("ScrollingFrame")
tScroll.Size = UDim2.new(1,0,1,-35)
tScroll.Position = UDim2.new(0,0,0,35)
tScroll.BackgroundTransparency = 1
tScroll.BorderSizePixel = 0
tScroll.ScrollBarThickness = 4
tScroll.ScrollBarImageColor3 = Color3.fromRGB(90,90,90)
tScroll.CanvasSize = UDim2.new(0,0,0,200)
tScroll.ClipsDescendants = true
tScroll.ZIndex = 2
tScroll.Parent = tPage

local selectBtn = Instance.new("TextButton")
selectBtn.Size = UDim2.new(1,-20,0,28)
selectBtn.Position = UDim2.new(0,10,0,6)
selectBtn.BackgroundColor3 = currentTheme.btnBg
selectBtn.BorderSizePixel = 0
selectBtn.Text = "Select Target"
selectBtn.TextColor3 = Color3.fromRGB(255,255,255)
selectBtn.Font = Enum.Font.SourceSansBold
selectBtn.TextSize = 13
selectBtn.ZIndex = 3
selectBtn.Parent = tScroll
table.insert(themedRefs.textBold, selectBtn)

local selectBtnBgRef = {color = currentTheme.btnBg}
table.insert(themedRefs.buttons, {btn=selectBtn, bgRef=selectBtnBgRef})

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.new(1,-20,0,18)
selectedLabel.Position = UDim2.new(0,10,0,40)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Text = "Selected target: none"
selectedLabel.TextColor3 = Color3.fromRGB(255,255,255)
selectedLabel.Font = Enum.Font.SourceSans
selectedLabel.TextSize = 12
selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedLabel.ZIndex = 3
selectedLabel.Parent = tScroll
table.insert(themedRefs.textNormal, selectedLabel)

local ROW_H      = 26
local MAX_LIST_H = 104
local LIST_Y     = 64

local playerListScroll = Instance.new("ScrollingFrame")
playerListScroll.Size = UDim2.new(1,-20,0,0)
playerListScroll.Position = UDim2.new(0,10,0,LIST_Y)
playerListScroll.BackgroundColor3 = currentTheme.dropdownBg
playerListScroll.BorderSizePixel = 0
playerListScroll.ScrollBarThickness = 4
playerListScroll.ScrollBarImageColor3 = Color3.fromRGB(90,90,90)
playerListScroll.CanvasSize = UDim2.new(0,0,0,0)
playerListScroll.Visible = false
playerListScroll.ClipsDescendants = true
playerListScroll.ZIndex = 5
playerListScroll.Parent = tScroll

local pls = Instance.new("UIStroke")
pls.Color = currentTheme.dropdownStroke
pls.Thickness = 1
pls.Parent = playerListScroll

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Parent = playerListScroll

local listOpen = false

local actDivider = Instance.new("Frame")
actDivider.Size = UDim2.new(1,-14,0,1)
actDivider.BackgroundColor3 = currentTheme.divider
actDivider.BorderSizePixel = 0
actDivider.ZIndex = 3
actDivider.Parent = tScroll
table.insert(themedRefs.pageDividers, actDivider)

local teleportBtn = makeButton(tScroll, "Teleport to Target", 0, nil)
teleportBtn.ZIndex = 3

local spectateBtn = makeButton(tScroll, "Spectate Target", 0, nil)
spectateBtn.ZIndex = 3

local flingBtn = makeButton(tScroll, "Fling Target", 0, nil)
flingBtn.ZIndex = 3

local function updateActionPositions(listH)
    local actY = LIST_Y + listH + (listH > 0 and 8 or 4)
    actDivider.Position  = UDim2.new(0,7,  0, actY-2)
    teleportBtn.Position = UDim2.new(0,10, 0, actY+2)
    spectateBtn.Position = UDim2.new(0,10, 0, actY+38)
    flingBtn.Position    = UDim2.new(0,10, 0, actY+74)
    tScroll.CanvasSize   = UDim2.new(0,0,0, actY+74+28+8)
end
updateActionPositions(0)

local function playerEntryText(p)
    if p.DisplayName ~= p.Name then return p.Name.." ("..p.DisplayName..")" end
    return p.Name
end

local function refreshPlayerList()
    for _, child in ipairs(playerListScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end

    local others = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then table.insert(others, p) end
    end

    if #others == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1,0,0,ROW_H)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Text = "No other players"
        emptyLbl.TextColor3 = Color3.fromRGB(80,80,80)
        emptyLbl.Font = Enum.Font.SourceSansItalic
        emptyLbl.TextSize = 12
        emptyLbl.ZIndex = 6
        emptyLbl.Parent = playerListScroll
    else
        for _, p in ipairs(others) do
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1,0,0,ROW_H)
            pBtn.BackgroundTransparency = 1
            pBtn.Text = playerEntryText(p)
            pBtn.TextColor3 = Color3.fromRGB(195,195,195)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.TextSize = 13
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            pBtn.ZIndex = 6
            pBtn.Parent = playerListScroll
            local pad = Instance.new("UIPadding")
            pad.PaddingLeft = UDim.new(0,8)
            pad.Parent = pBtn

            pBtn.MouseEnter:Connect(function()
                pBtn.BackgroundTransparency = 0
                pBtn.BackgroundColor3 = currentTheme.sideHover
            end)
            pBtn.MouseLeave:Connect(function() pBtn.BackgroundTransparency = 1 end)

            local captured = p
            pBtn.MouseButton1Click:Connect(function()
                selectedTarget = captured
                selectedLabel.Text = "Selected target: "..playerEntryText(captured)
                listOpen = false
                playerListScroll.Visible = false
                updateActionPositions(0)
                selectBtn.BackgroundColor3 = currentTheme.btnBg
                selectBtnBgRef.color = currentTheme.btnBg
                if isSpectating then
                    stopSpectate()
                    spectateBtn.Text = "Spectate Target"
                end
            end)
        end
    end

    local totalH = math.max(#others,1)*ROW_H
    playerListScroll.CanvasSize = UDim2.new(0,0,0,totalH)
    local listH = math.min(totalH, MAX_LIST_H)
    playerListScroll.Size = UDim2.new(1,-20,0,listH)
    updateActionPositions(listH)
end

selectBtn.MouseEnter:Connect(function()
    if not listOpen then
        TweenService:Create(selectBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(selectBtnBgRef.color.R*255+18,0,255),
                math.clamp(selectBtnBgRef.color.G*255+18,0,255),
                math.clamp(selectBtnBgRef.color.B*255+18,0,255)),
        }):Play()
    end
end)
selectBtn.MouseLeave:Connect(function()
    if not listOpen then
        TweenService:Create(selectBtn, TweenInfo.new(0.1), {BackgroundColor3=selectBtnBgRef.color}):Play()
    end
end)
selectBtn.MouseButton1Click:Connect(function()
    listOpen = not listOpen
    if listOpen then
        refreshPlayerList()
        playerListScroll.Visible = true
        TweenService:Create(selectBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(selectBtnBgRef.color.R*255-12,0,255),
                math.clamp(selectBtnBgRef.color.G*255-12,0,255),
                math.clamp(selectBtnBgRef.color.B*255-12,0,255)),
        }):Play()
    else
        playerListScroll.Visible = false
        updateActionPositions(0)
        TweenService:Create(selectBtn, TweenInfo.new(0.1), {BackgroundColor3=selectBtnBgRef.color}):Play()
    end
end)

teleportBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then return end
    local myChar = localPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local tChar = selectedTarget.Character
    local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
    if not tHRP then return end
    myHRP.CFrame = tHRP.CFrame + Vector3.new(0,3,0)
end)

spectateBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then return end
    if isSpectating then
        stopSpectate()
        spectateBtn.Text = "Spectate Target"
    else
        startSpectate(selectedTarget)
        spectateBtn.Text = "Stop Spectating"
    end
end)

flingBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then return end
    local myChar = localPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local tChar = selectedTarget.Character
    local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
    if not tHRP then return end
    local savedCFrame = myHRP.CFrame
    for _ = 1, 3 do myHRP.CFrame = tHRP.CFrame task.wait() end
    task.wait(0.05)
    myHRP.CFrame = savedCFrame
end)

Players.PlayerRemoving:Connect(function(player)
    if selectedTarget == player then
        selectedTarget = nil
        selectedLabel.Text = "Selected: none"
        if isSpectating then
            stopSpectate()
            spectateBtn.Text = "Spectate Target"
        end
    end
    if listOpen then refreshPlayerList() end
end)

-- =========================
-- MOVEMENT PAGE
-- =========================

local mPage = pageFrames["Movement"]
makePageTitle(mPage, "MOVEMENT")

local wsSlider = makeSlider(mPage, "Walk Speed: 16", 36)
connectSlider(wsSlider, function(alpha)
    walkSpeed = math.floor(16 + alpha*(300-16))
    wsSlider.label.Text = "Walk Speed: "..walkSpeed
end)

local fsSlider = makeSlider(mPage, "Flight Speed: 60", 74)
fsSlider.label.Visible = false
fsSlider.track.Visible = false
connectSlider(fsSlider, function(alpha)
    FLY_SPEED = math.floor(10 + alpha*(500-10))
    fsSlider.label.Text = "Flight Speed: "..FLY_SPEED
end)

local mDivider = makeDivider(mPage, 74)
local ijToggle = makeToggle(mPage, "Infinite Jump", 82, false, function(state)
    infiniteJump = state
end)

local flightToggle

local function updateMovementLayout(armed)
    local o = armed and 38 or 0
    fsSlider.label.Visible = armed
    fsSlider.track.Visible = armed
    mDivider.Position           = UDim2.new(0,7,  0, 74  + o)
    ijToggle.label.Position     = UDim2.new(0,10, 0, 82  + o)
    ijToggle.track.Position     = UDim2.new(1,-54, 0, 83  + o)
    flightToggle.label.Position = UDim2.new(0,10, 0, 116 + o)
    flightToggle.track.Position = UDim2.new(1,-54, 0, 117 + o)
    flightToggle.label.Text = armed and "Flight  (T to toggle)" or "Flight"
end

flightToggle = makeToggle(mPage, "Flight", 116, false, function(state)
    flightArmed = state
    updateMovementLayout(state)
    if state then
        startFlight()
    else
        if isFlying then stopFlight() end
    end
end)

-- =========================
-- T KEY: TOGGLE ACTUAL FLIGHT
-- =========================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T and flightArmed then
        if isFlying then stopFlight() else startFlight() end
    end
end)

-- =========================
-- INFINITE JUMP
-- =========================

UserInputService.JumpRequest:Connect(function()
    if not infiniteJump then return end
    local char = localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- =========================
-- SETTINGS PAGE
-- =========================

local sPage = pageFrames["Settings"]
makePageTitle(sPage, "SETTINGS")

local sScroll = Instance.new("ScrollingFrame")
sScroll.Size = UDim2.new(1,0,1,-35)
sScroll.Position = UDim2.new(0,0,0,35)
sScroll.BackgroundTransparency = 1
sScroll.BorderSizePixel = 0
sScroll.ScrollBarThickness = 4
sScroll.ScrollBarImageColor3 = Color3.fromRGB(90,90,90)
sScroll.CanvasSize = UDim2.new(0,0,0,200)
sScroll.ClipsDescendants = true
sScroll.ZIndex = 2
sScroll.Parent = sPage

local themeSection = Instance.new("TextLabel")
themeSection.Size = UDim2.new(1,-20,0,16)
themeSection.Position = UDim2.new(0,10,0,6)
themeSection.BackgroundTransparency = 1
themeSection.Text = "APPEARANCE"
themeSection.TextColor3 = currentTheme.pageTitle
themeSection.Font = Enum.Font.SourceSansBold
themeSection.TextSize = 10
themeSection.TextXAlignment = Enum.TextXAlignment.Left
themeSection.ZIndex = 3
themeSection.Parent = sScroll
table.insert(themedRefs.pageTitles, themeSection)
table.insert(themedRefs.textBold, themeSection)

local themeBtnBgRef = {color = currentTheme.btnBg}

local themePickerBtn = Instance.new("TextButton")
themePickerBtn.Size = UDim2.new(1,-20,0,28)
themePickerBtn.Position = UDim2.new(0,10,0,26)
themePickerBtn.BackgroundColor3 = themeBtnBgRef.color
themePickerBtn.BorderSizePixel = 0
themePickerBtn.Text = "Change Theme"
themePickerBtn.TextColor3 = Color3.fromRGB(255,255,255)
themePickerBtn.Font = Enum.Font.SourceSansBold
themePickerBtn.TextSize = 13
themePickerBtn.ZIndex = 3
themePickerBtn.Parent = sScroll
table.insert(themedRefs.buttons, {btn=themePickerBtn, bgRef=themeBtnBgRef})
table.insert(themedRefs.textBold, themePickerBtn)

local currentThemeLabel = Instance.new("TextLabel")
currentThemeLabel.Size = UDim2.new(1,-20,0,18)
currentThemeLabel.Position = UDim2.new(0,10,0,58)
currentThemeLabel.BackgroundTransparency = 1
currentThemeLabel.Text = "Active: Default"
currentThemeLabel.TextColor3 = Color3.fromRGB(160,160,160)
currentThemeLabel.Font = Enum.Font.SourceSans
currentThemeLabel.TextSize = 12
currentThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
currentThemeLabel.ZIndex = 3
currentThemeLabel.Parent = sScroll
table.insert(themedRefs.textNormal, currentThemeLabel)

local THEME_LIST_Y = 80
local THEME_ROW_H  = 32
local THEME_LIST_H = #THEMES * THEME_ROW_H

local themeListScroll = Instance.new("ScrollingFrame")
themeListScroll.Size = UDim2.new(1,-20,0,THEME_LIST_H)
themeListScroll.Position = UDim2.new(0,10,0,THEME_LIST_Y)
themeListScroll.BackgroundColor3 = currentTheme.dropdownBg
themeListScroll.BorderSizePixel = 0
themeListScroll.ScrollBarThickness = 0
themeListScroll.CanvasSize = UDim2.new(0,0,0,THEME_LIST_H)
themeListScroll.Visible = false
themeListScroll.ClipsDescendants = true
themeListScroll.ZIndex = 5
themeListScroll.Parent = sScroll

local tls = Instance.new("UIStroke")
tls.Color = currentTheme.dropdownStroke
tls.Thickness = 1
tls.Parent = themeListScroll

local themeListOpen = false

local function populateThemeList()
    for _, child in ipairs(themeListScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
    end
    for idx, theme in ipairs(THEMES) do
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1,0,0,THEME_ROW_H)
        row.Position = UDim2.new(0,0,0,(idx-1)*THEME_ROW_H)
        row.BackgroundTransparency = (theme.id == currentTheme.id) and 0 or 1
        row.BackgroundColor3 = currentTheme.sideSelected
        row.Text = ""
        row.ZIndex = 6
        row.Parent = themeListScroll

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1,-10,1,0)
        nameLbl.Position = UDim2.new(0,10,0,0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = theme.name
        nameLbl.TextColor3 = (theme.id == currentTheme.id) and currentTheme.labelSel or Color3.fromRGB(185,185,185)
        nameLbl.Font = theme.fontBold
        nameLbl.TextSize = 13
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 7
        nameLbl.Parent = row

        row.MouseEnter:Connect(function()
            if theme.id ~= currentTheme.id then
                row.BackgroundTransparency = 0
                row.BackgroundColor3 = currentTheme.sideHover
            end
        end)
        row.MouseLeave:Connect(function()
            if theme.id ~= currentTheme.id then row.BackgroundTransparency = 1 end
        end)

        local capturedTheme = theme
        row.MouseButton1Click:Connect(function()
            themeListOpen = false
            themeListScroll.Visible = false
            themePickerBtn.Text = "Change Theme"
            applyTheme(capturedTheme)
            currentThemeLabel.Text = "Active: "..capturedTheme.name
        end)
    end
end

themePickerBtn.MouseEnter:Connect(function()
    if not themeListOpen then
        TweenService:Create(themePickerBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(themeBtnBgRef.color.R*255+18,0,255),
                math.clamp(themeBtnBgRef.color.G*255+18,0,255),
                math.clamp(themeBtnBgRef.color.B*255+18,0,255)),
        }):Play()
    end
end)
themePickerBtn.MouseLeave:Connect(function()
    if not themeListOpen then
        TweenService:Create(themePickerBtn, TweenInfo.new(0.1), {BackgroundColor3=themeBtnBgRef.color}):Play()
    end
end)
themePickerBtn.MouseButton1Click:Connect(function()
    themeListOpen = not themeListOpen
    if themeListOpen then
        populateThemeList()
        themeListScroll.Visible = true
        sScroll.CanvasSize = UDim2.new(0,0,0,THEME_LIST_Y+THEME_LIST_H+12)
        TweenService:Create(themePickerBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(
                math.clamp(themeBtnBgRef.color.R*255-10,0,255),
                math.clamp(themeBtnBgRef.color.G*255-10,0,255),
                math.clamp(themeBtnBgRef.color.B*255-10,0,255)),
        }):Play()
    else
        themeListScroll.Visible = false
        sScroll.CanvasSize = UDim2.new(0,0,0,200)
        TweenService:Create(themePickerBtn, TweenInfo.new(0.1), {BackgroundColor3=themeBtnBgRef.color}):Play()
    end
end)

-- =========================
-- CREDITS PAGE
-- =========================

local credPage = pageFrames["Credits"]
makePageTitle(credPage, "CREDITS")
local cs = Instance.new("TextLabel")
cs.Size = UDim2.new(1,0,1,-50)
cs.Position = UDim2.new(0,0,0,50)
cs.BackgroundTransparency = 1
cs.Text = "Coming Soon"
cs.TextColor3 = Color3.fromRGB(62,62,62)
cs.Font = Enum.Font.SourceSansItalic
cs.TextSize = 13
cs.ZIndex = 3
cs.Parent = credPage

-- =========================
-- APPLY THEME
-- =========================

applyTheme = function(theme)
    currentTheme = theme

    menu.BackgroundColor3 = theme.menuBg
    if theme.gradient then
        if not menuGradient then
            menuGradient = Instance.new("UIGradient")
            menuGradient.Parent = menu
        end
        menuGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.gradColor0),
            ColorSequenceKeypoint.new(1, theme.gradColor1),
        })
        menuGradient.Rotation = 135
        menuGradient.Enabled = true

        if not sidebarGradient then
            sidebarGradient = Instance.new("UIGradient")
            sidebarGradient.Parent = sidebar
        end
        sidebarGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(
                math.clamp(theme.gradColor0.R*255-8,0,255),
                math.clamp(theme.gradColor0.G*255-8,0,255),
                math.clamp(theme.gradColor0.B*255-8,0,255))),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(
                math.clamp(theme.gradColor1.R*255-8,0,255),
                math.clamp(theme.gradColor1.G*255-8,0,255),
                math.clamp(theme.gradColor1.B*255-8,0,255))),
        })
        sidebarGradient.Rotation = 135
        sidebarGradient.Enabled = true
    else
        if menuGradient    then menuGradient.Enabled    = false end
        if sidebarGradient then sidebarGradient.Enabled = false end
    end

    topBar.BackgroundColor3           = theme.topBarBg
    topBarBottomFill.BackgroundColor3 = theme.topBarBg
    sidebar.BackgroundColor3          = theme.sidebarBg
    sbarRightFill.BackgroundColor3    = theme.sidebarBg
    sbarTopFill.BackgroundColor3      = theme.sidebarBg
    sideDivider.BackgroundColor3      = theme.divider
    menuStroke.Color                  = theme.stroke

    for id, btn in pairs(sidebarBtns) do
        local sel = (id == currentPage)
        btn.item.BackgroundColor3   = sel and theme.sideSelected or theme.sideNormal
        btn.accent.BackgroundColor3 = theme.accent
        btn.lbl.TextColor3          = sel and theme.labelSel or theme.labelNorm
    end

    for _, t in ipairs(themedRefs.toggles) do
        if t.track and t.track.Parent then
            t.track.BackgroundColor3 = t.getState() and theme.toggleOn or theme.toggleOff
        end
    end
    for _, f in ipairs(themedRefs.sliderFills) do
        if f and f.Parent then f.BackgroundColor3 = theme.sliderFill end
    end
    for _, t in ipairs(themedRefs.sliderTracks) do
        if t and t.Parent then t.BackgroundColor3 = theme.sliderTrack end
    end
    for _, b in ipairs(themedRefs.buttons) do
        if b.btn and b.btn.Parent then
            b.bgRef.color = theme.btnBg
            b.btn.BackgroundColor3 = theme.btnBg
        end
    end
    for _, lbl in ipairs(themedRefs.pageTitles) do
        if lbl and lbl.Parent then lbl.TextColor3 = theme.pageTitle end
    end
    for _, div in ipairs(themedRefs.pageDividers) do
        if div and div.Parent then div.BackgroundColor3 = theme.divider end
    end
    for _, obj in ipairs(themedRefs.textNormal) do
        if obj and obj.Parent then obj.Font = theme.font end
    end
    for _, obj in ipairs(themedRefs.textBold) do
        if obj and obj.Parent then obj.Font = theme.fontBold end
    end

    if playerListScroll and playerListScroll.Parent then
        playerListScroll.BackgroundColor3 = theme.dropdownBg
        pls.Color = theme.dropdownStroke
    end
    if themeListScroll and themeListScroll.Parent then
        themeListScroll.BackgroundColor3 = theme.dropdownBg
        tls.Color = theme.dropdownStroke
    end
end

-- =========================
-- HINT UI
-- =========================

local hintGui = Instance.new("ScreenGui")
hintGui.Name = "HintGui"
hintGui.ResetOnSpawn = false
hintGui.Parent = localPlayer:WaitForChild("PlayerGui")

local hintLabel = Instance.new("TextLabel")
hintLabel.AnchorPoint = Vector2.new(0.5,0.5)
hintLabel.Position = UDim2.new(0.5,0,0.85,0)
hintLabel.Size = UDim2.new(0,320,0,44)
hintLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
hintLabel.BackgroundTransparency = 1
hintLabel.Text = "Press K to open menu"
hintLabel.TextColor3 = Color3.fromRGB(255,255,255)
hintLabel.TextTransparency = 1
hintLabel.Font = Enum.Font.SourceSansBold
hintLabel.TextSize = 22
hintLabel.Parent = hintGui
local hintPadding = Instance.new("UIPadding")
hintPadding.PaddingLeft   = UDim.new(0,14)
hintPadding.PaddingRight  = UDim.new(0,14)
hintPadding.PaddingTop    = UDim.new(0,6)
hintPadding.PaddingBottom = UDim.new(0,6)
hintPadding.Parent = hintLabel

local function showHint(text)
    hintLabel.Text = text
    hintLabel.TextTransparency = 1
    hintLabel.BackgroundTransparency = 1
    local fadeIn = TweenService:Create(hintLabel, TweenInfo.new(0.35), {
        TextTransparency=0, BackgroundTransparency=0.35})
    local fadeOut = TweenService:Create(hintLabel, TweenInfo.new(0.6), {
        TextTransparency=1, BackgroundTransparency=1})
    fadeIn:Play()
    fadeIn.Completed:Wait()
    task.wait(1.5)
    fadeOut:Play()
end

-- =========================
-- FADE HELPER
-- =========================

local fadeToken = 0

local function fadeInMenu()
    fadeToken += 1
    local myToken = fadeToken
    local originals = {}
    local objects = menu:GetDescendants()
    table.insert(objects, menu)

    for _, obj in ipairs(objects) do
        if not obj or not obj.Parent then continue end
        local entry = {}
        if obj:IsA("GuiObject") then
            entry.bg = obj.BackgroundTransparency
            obj.BackgroundTransparency = 1
        end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            entry.text = obj.TextTransparency
            obj.TextTransparency = 1
        end
        if obj:IsA("UIStroke") then
            entry.stroke = obj.Transparency
            obj.Transparency = 1
        end
        originals[obj] = entry
    end

    local steps = 30
    local stepTime = 0.45/steps
    for i = 1, steps do
        if fadeToken ~= myToken then return end
        local alpha = i/steps
        for obj, entry in pairs(originals) do
            if not obj or not obj.Parent then continue end
            if obj:IsA("GuiObject") and entry.bg ~= nil then
                obj.BackgroundTransparency = 1-(1-entry.bg)*alpha
            end
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and entry.text ~= nil then
                obj.TextTransparency = 1-(1-entry.text)*alpha
            end
            if obj:IsA("UIStroke") and entry.stroke ~= nil then
                obj.Transparency = 1-(1-entry.stroke)*alpha
            end
        end
        task.wait(stepTime)
    end

    if fadeToken ~= myToken then return end
    for obj, entry in pairs(originals) do
        if not obj or not obj.Parent then continue end
        if obj:IsA("GuiObject") and entry.bg ~= nil then obj.BackgroundTransparency = entry.bg end
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and entry.text ~= nil then obj.TextTransparency = entry.text end
        if obj:IsA("UIStroke") and entry.stroke ~= nil then obj.Transparency = entry.stroke end
    end
end

-- =========================
-- LOADING → MENU
-- =========================

task.spawn(function()
    barTween.Completed:Wait()
    task.wait(0.3)
    local fadeLoad = TweenService:Create(loadBg, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency=1})
    TweenService:Create(loadTitle, TweenInfo.new(0.5), {TextTransparency=1}):Play()
    TweenService:Create(loadSub,   TweenInfo.new(0.5), {TextTransparency=1}):Play()
    TweenService:Create(barTrack,  TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
    TweenService:Create(barFill,   TweenInfo.new(0.5), {BackgroundTransparency=1}):Play()
    fadeLoad:Play()
    fadeLoad.Completed:Wait()
    loadGui:Destroy()
    gui.Enabled = true
    guiEnabled  = true
    task.spawn(fadeInMenu)
    task.defer(function() showHint("Press K to open menu") end)
end)

-- =========================
-- KEYBIND (K)
-- =========================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        guiEnabled = not guiEnabled
        gui.Enabled = guiEnabled
        if guiEnabled then
            task.spawn(fadeInMenu)
            task.defer(function() showHint("Press K to close menu") end)
        end
    end
end)

-- =========================
-- MINIMIZE / CLOSE
-- =========================

minimizeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
    guiEnabled  = false
    task.defer(function() showHint("Press K to open menu") end)
end)

closeBtn.MouseButton1Click:Connect(function()
    enabled = false
    if isFlying then stopFlight() end
    if isSpectating then stopSpectate() end
    for _, data in pairs(tracked) do
        if data.highlight then pcall(function() data.highlight:Destroy() end) end
        if data.billboard then pcall(function() data.billboard:Destroy() end) end
        if data.hitbox    then pcall(function() data.hitbox:Destroy() end) end
        if data.bones then
            for _, b in ipairs(data.bones) do
                if b.line then pcall(function() b.line:Destroy() end) end
            end
        end
    end
    tracked = {}
    gui:Destroy()
    hintGui:Destroy()
    skeletonGui:Destroy()
end)

-- =========================
-- HITBOX HELPERS
-- =========================

local function createHitbox(hrp)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "HitboxCube"
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.Color3 = Color3.fromRGB(0,0,0)
    box.Transparency = 0.6
    box.Size = hrp.Size
    box.Parent = hrp
    return box
end

local function updateHealth(player)
    local data = tracked[player]
    if not data or not data.humanoid or not data.healthLabel then return end
    local humanoid = data.humanoid
    if humanoid.MaxHealth == 0 then return end
    local percent = math.clamp(humanoid.Health/humanoid.MaxHealth, 0, 1)
    data.healthLabel.Text = math.floor(percent*100).."%"
    local r = math.clamp(math.floor(255*(1-percent)+60), 0, 255)
    local g = math.clamp(math.floor(255*percent+60), 0, 255)
    data.healthLabel.TextColor3 = Color3.fromRGB(r,g,0)
end

-- =========================
-- DRAG MENU
-- =========================

local dragging  = false
local dragStart = nil
local startPos  = nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = input.Position
        startPos  = menu.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
    local delta = input.Position - dragStart
    menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X,
        startPos.Y.Scale, startPos.Y.Offset+delta.Y)
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- =========================
-- SKELETON + FLIGHT (RenderStepped)
-- =========================

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    local inset  = game:GetService("GuiService"):GetGuiInset()

    for player, data in pairs(tracked) do
        if not data.bones then continue end
        local char    = player.Character
        local canShow = showSkeleton and enabled and char ~= nil
        for _, b in ipairs(data.bones) do
            if not b.line or not b.line.Parent then continue end
            if not canShow then b.line.Visible = false continue end
            local part1 = char:FindFirstChild(b.from)
            local part2 = char:FindFirstChild(b.to)
            if part1 and part2 then
                local p1v, on1 = camera:WorldToViewportPoint(part1.Position)
                local p2v, on2 = camera:WorldToViewportPoint(part2.Position)
                if on1 and on2 and p1v.Z > 0 and p2v.Z > 0 then
                    local sp1   = Vector2.new(p1v.X, p1v.Y-inset.Y)
                    local sp2   = Vector2.new(p2v.X, p2v.Y-inset.Y)
                    local dist  = (sp2-sp1).Magnitude
                    local mid   = (sp1+sp2)*0.5
                    local angle = math.atan2(sp2.Y-sp1.Y, sp2.X-sp1.X)
                    b.line.Size     = UDim2.new(0,dist,0,1)
                    b.line.Position = UDim2.new(0,mid.X,0,mid.Y)
                    b.line.Rotation = math.deg(angle)
                    b.line.Visible  = true
                else
                    b.line.Visible = false
                end
            else
                b.line.Visible = false
            end
        end
    end

    if isFlying then
        local char = localPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and flyBV and flyBV.Parent then
            local cam = workspace.CurrentCamera
            local cf  = cam.CFrame
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W)         then dir = dir + cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S)         then dir = dir - cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A)         then dir = dir - cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D)         then dir = dir + cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
            flyBV.Velocity = dir.Magnitude > 0 and dir.Unit*FLY_SPEED or Vector3.zero
            if flyBG and flyBG.Parent then
                flyBG.CFrame = CFrame.new(hrp.Position, hrp.Position+cf.LookVector)
            end
        elseif not hrp then
            if flyBV and flyBV.Parent then flyBV:Destroy() end
            if flyBG and flyBG.Parent then flyBG:Destroy() end
            flyBV, flyBG = nil, nil
            isFlying = false
        end
    end
end)

-- =========================
-- PERSISTENT ENFORCEMENT
-- =========================

RunService.Heartbeat:Connect(function()
    for player, data in pairs(tracked) do
        if not player or not player.Parent then continue end
        local char = player.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if showHitboxes then
                hrp.Size = Vector3.new(2,2,2)*hitboxScale
                if data.hitbox then data.hitbox.Size = hrp.Size end
            end
            hrp.CanCollide = false
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if walkSpeed ~= 16 then
            local char = localPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = walkSpeed end
            end
        end
        if isFlying then
            local char = localPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and (not flyBV or not flyBV.Parent) then startFlight() end
            end
        end
        for player, data in pairs(tracked) do
            if not player or not player.Parent then tracked[player] = nil continue end
            local char = player.Character
            if not char then continue end
            if enabled then
                if not data.highlight or not data.highlight.Parent then
                    local highlight = Instance.new("Highlight")
                    highlight.FillTransparency = 1
                    highlight.OutlineColor = Color3.fromRGB(255,0,0)
                    highlight.Enabled = not showSkeleton
                    highlight.Parent = char
                    data.highlight = highlight
                end
            end
        end
    end
end)

-- =========================
-- PLAYER ESP LOGIC
-- =========================

local function isEnemy(player)
    if not localPlayer.Team or not player.Team then return true end
    return player.Team ~= localPlayer.Team
end

local function applyESP(player, character)
    if player == localPlayer then return end
    if not isEnemy(player) then return end

    local head     = character:WaitForChild("Head",             5)
    local hrp      = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid",         5)
    if not head or not hrp or not humanoid then return end

    if tracked[player] then
        if tracked[player].highlight then pcall(function() tracked[player].highlight:Destroy() end) end
        if tracked[player].billboard then pcall(function() tracked[player].billboard:Destroy() end) end
        if tracked[player].hitbox    then pcall(function() tracked[player].hitbox:Destroy() end) end
        if tracked[player].bones then
            for _, b in ipairs(tracked[player].bones) do
                if b.line then pcall(function() b.line:Destroy() end) end
            end
        end
    end

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255,0,0)
    highlight.Enabled = enabled and not showSkeleton
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,220,0,25)
    billboard.StudsOffset = Vector3.new(0,2.8,0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = enabled
    billboard.Parent = head

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,1,0)
    container.BackgroundTransparency = 1
    container.Parent = billboard

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0,4)
    layout.Parent = container

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.AutomaticSize = Enum.AutomaticSize.X
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Visible = showNames
    nameLabel.Parent = container

    local sep = Instance.new("TextLabel")
    sep.BackgroundTransparency = 1
    sep.AutomaticSize = Enum.AutomaticSize.X
    sep.Text = " | "
    sep.TextColor3 = Color3.fromRGB(255,255,255)
    sep.TextSize = 15
    sep.Font = Enum.Font.SourceSansBold
    sep.Visible = showNames and showHealth
    sep.Parent = container

    local healthLabel = Instance.new("TextLabel")
    healthLabel.BackgroundTransparency = 1
    healthLabel.AutomaticSize = Enum.AutomaticSize.X
    healthLabel.TextSize = 15
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.Visible = showHealth
    healthLabel.Parent = container

    if showHitboxes then hrp.Size = Vector3.new(2,2,2)*hitboxScale end
    hrp.CanCollide = false

    local hitbox = createHitbox(hrp)
    hitbox.Visible = enabled and showHitboxes

    local isR15    = character:FindFirstChild("UpperTorso") ~= nil
    local boneList = isR15 and BONES_R15 or BONES_R6
    local bones    = {}

    for _, b in ipairs(boneList) do
        local line = Instance.new("Frame")
        line.BackgroundColor3 = Color3.fromRGB(255,0,0)
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5,0.5)
        line.ZIndex = 1
        line.Visible = false
        line.Parent = skeletonGui
        table.insert(bones, {from=b[1], to=b[2], line=line})
    end

    tracked[player] = {
        highlight=highlight, billboard=billboard, hitbox=hitbox,
        humanoid=humanoid, nameLabel=nameLabel, sep=sep, healthLabel=healthLabel, bones=bones,
    }

    updateHealth(player)
    humanoid.HealthChanged:Connect(function() updateHealth(player) end)
    character.AncestryChanged:Connect(function()
        if not character.Parent and tracked[player] then
            tracked[player].highlight = nil
            tracked[player].billboard = nil
            tracked[player].hitbox    = nil
            if tracked[player].bones then
                for _, b in ipairs(tracked[player].bones) do
                    if b.line then b.line.Visible = false end
                end
            end
        end
    end)
end

local function hookPlayer(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.2)
        applyESP(player, char)
    end)
    if player.Character then applyESP(player, player.Character) end
end

for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
Players.PlayerAdded:Connect(hookPlayer)
Players.PlayerRemoving:Connect(function(player)
    if tracked[player] then
        if tracked[player].highlight then pcall(function() tracked[player].highlight:Destroy() end) end
        if tracked[player].billboard then pcall(function() tracked[player].billboard:Destroy() end) end
        if tracked[player].hitbox    then pcall(function() tracked[player].hitbox:Destroy() end) end
        if tracked[player].bones then
            for _, b in ipairs(tracked[player].bones) do
                if b.line then pcall(function() b.line:Destroy() end) end
            end
        end
        tracked[player] = nil
    end
end)
