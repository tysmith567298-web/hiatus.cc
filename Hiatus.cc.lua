-- open src and skidded btw some ai too
    Hiatus.cc v2
    Rebranded addon  for Rivals
    Config: Hiatus.cc/Configs/*.json
]]
if getgenv().Library then
    if getgenv().Library.Exit then
        getgenv().Library:Exit()
    elseif getgenv().Library.Unload then
        getgenv().Library:Unload()
    end
end

cloneref = cloneref or function(o)
    return o
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local CoreGui = cloneref(game:GetService("CoreGui"))

gethui = gethui or function()
    return CoreGui
end

local LP = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LP:GetMouse())
local Camera = workspace.CurrentCamera

-- UI
local Library = {
    Flags = {}, MenuKeybind = tostring(Enum.KeyCode.X), Directory = "Hiatus.cc",
    Folders = {Assets = "/Assets", Configs = "/Configs"}, FontSize = 14,
    Animation = {Time = 0.35, Style = "Quart", Direction = "Out"},
    ZIndexOrder = {["OptionHolder"] = 5, ["KeybindWindow"] = 5, ["ColorpickerWindow"] = 6},

    -- Ignore below
    Threads = {}, Connections = {}, SetFlags = {}, ThemingStuff = {}, ThemeMap = {},
    OpenFrames = {}, OpenFrameTriggers = {}, OpenFrameInteracting = false, Notifications = {},
    Holder = nil, UnusedHolder = nil, Theme = nil, Font = nil,
}
do
    Library.__index = Library

    local Flags = Library.Flags
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"] = "Unknown", ["Backspace"] = "Back", ["Tab"] = "Tab", ["Clear"] = "Clear",
        ["Return"] = "Return", ["Pause"] = "Pause", ["Escape"] = "Escape", ["Space"] = "Space",
        ["QuotedDouble"] = '"', ["Hash"] = "#", ["Dollar"] = "$", ["Percent"] = "%",
        ["Ampersand"] = "&", ["Quote"] = "'", ["LeftParenthesis"] = "(",
        ["RightParenthesis"] = " )", ["Asterisk"] = "*", ["Plus"] = "+", ["Comma"] = ",",
        ["Minus"] = "-", ["Period"] = ".", ["Slash"] = "`", ["Three"] = "3", ["Seven"] = "7",
        ["Eight"] = "8", ["Colon"] = ":", ["Semicolon"] = ";", ["LessThan"] = "<",
        ["GreaterThan"] = ">", ["Question"] = "?", ["Equals"] = "=", ["At"] = "@",
        ["LeftBracket"] = "LeftBracket", ["RightBracket"] = "RightBracked",
        ["BackSlash"] = "BackSlash", ["Caret"] = "^", ["Underscore"] = "_", ["Backquote"] = "`",
        ["LeftCurly"] = "{", ["Pipe"] = "|", ["RightCurly"] = "}", ["Tilde"] = "~",
        ["Delete"] = "Delete", ["End"] = "End", ["KeypadZero"] = "Keypad0",
        ["KeypadOne"] = "Keypad1", ["KeypadTwo"] = "Keypad2", ["KeypadThree"] = "Keypad3",
        ["KeypadFour"] = "Keypad4", ["KeypadFive"] = "Keypad5", ["KeypadSix"] = "Keypad6",
        ["KeypadSeven"] = "Keypad7", ["KeypadEight"] = "Keypad8", ["KeypadNine"] = "Keypad9",
        ["KeypadPeriod"] = "KeypadP", ["KeypadDivide"] = "KeypadD", ["KeypadMultiply"] = "KeypadM",
        ["KeypadMinus"] = "KeypadM", ["KeypadPlus"] = "KeypadP", ["KeypadEnter"] = "KeypadE",
        ["KeypadEquals"] = "KeypadE", ["Insert"] = "Insert", ["Home"] = "Home",
        ["PageUp"] = "PageUp", ["PageDown"] = "PageDown", ["RightShift"] = "RightShift",
        ["LeftShift"] = "LeftShift", ["RightControl"] = "RightControl",
        ["LeftControl"] = "LeftControl", ["LeftAlt"] = "LeftAlt", ["RightAlt"] = "RightAlt"
    }

    -- Folders
    local function SafeLibraryMakeFolder(Path)
        if isfolder and isfolder(Path) then
            return true
        end

        return pcall(
            function()
                makefolder(Path)
            end
        )
    end

    local function SafeLibraryWriteFile(Path, Content)
        return pcall(
            function()
                writefile(Path, Content)
            end
        )
    end

    SafeLibraryMakeFolder(Library.Directory)

    for _, Folder in Library.Folders do
        SafeLibraryMakeFolder(Library.Directory .. Folder)
    end

    if not isfile(Library.Directory .. "/autoload.json") then
        SafeLibraryWriteFile(Library.Directory .. "/autoload.json", "")
    end

    local Themes = {
        ["Preset"] = {
            ["Background"] = Color3.fromRGB(20, 22, 24), ["Inline"] = Color3.fromRGB(24, 27, 29),
            ["Tab"] = Color3.fromRGB(28, 32, 34), ["Text"] = Color3.fromRGB(255, 255, 255),
            ["Inactive Text"] = Color3.fromRGB(120, 120, 120),
            ["Accent"] = Color3.fromRGB(179, 165, 255), ["Outline"] = Color3.fromRGB(29, 31, 34),
            ["Hovered Element"] = Color3.fromRGB(29, 31, 34),
        },
        ["Sky"] = {
            ["Background"] = Color3.fromRGB(20, 23, 24), ["Inline"] = Color3.fromRGB(31, 35, 36),
            ["Tab"] = Color3.fromRGB(36, 41, 43), ["Text"] = Color3.fromRGB(255, 255, 255),
            ["Inactive Text"] = Color3.fromRGB(134, 134, 134),
            ["Accent"] = Color3.fromRGB(147, 238, 255), ["Outline"] = Color3.fromRGB(41, 45, 46),
            ["Hovered Element"] = Color3.fromRGB(68, 73, 73),
        },
        ["Magma"] = {
            ["Background"] = Color3.fromRGB(34, 28, 28), ["Inline"] = Color3.fromRGB(31, 23, 23),
            ["Tab"] = Color3.fromRGB(41, 33, 33), ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(134, 121, 121),
            ["Accent"] = Color3.fromRGB(233, 43, 26), ["Outline"] = Color3.fromRGB(41, 29, 29),
            ["Hovered Element"] = Color3.fromRGB(54, 42, 42),
        },
        ["Sand"] = {
            ["Background"] = Color3.fromRGB(45, 46, 37), ["Inline"] = Color3.fromRGB(63, 65, 55),
            ["Tab"] = Color3.fromRGB(54, 56, 44), ["Text"] = Color3.fromRGB(208, 207, 227),
            ["Inactive Text"] = Color3.fromRGB(136, 135, 132),
            ["Accent"] = Color3.fromRGB(255, 229, 147), ["Outline"] = Color3.fromRGB(88, 83, 68),
            ["Hovered Element"] = Color3.fromRGB(71, 71, 59),
        },
        ["Navy"] = {
            ["Background"] = Color3.fromRGB(28, 30, 36), ["Inline"] = Color3.fromRGB(32, 34, 41),
            ["Tab"] = Color3.fromRGB(40, 43, 49), ["Text"] = Color3.fromRGB(165, 164, 187),
            ["Inactive Text"] = Color3.fromRGB(101, 105, 126),
            ["Accent"] = Color3.fromRGB(0, 102, 255), ["Outline"] = Color3.fromRGB(37, 42, 54),
            ["Hovered Element"] = Color3.fromRGB(40, 43, 49),
        },
        ["Emerald"] = {
            ["Background"] = Color3.fromRGB(18, 24, 21), ["Inline"] = Color3.fromRGB(24, 32, 28),
            ["Tab"] = Color3.fromRGB(30, 40, 34), ["Text"] = Color3.fromRGB(230, 245, 235),
            ["Inactive Text"] = Color3.fromRGB(110, 135, 120),
            ["Accent"] = Color3.fromRGB(52, 211, 153), ["Outline"] = Color3.fromRGB(36, 48, 41),
            ["Hovered Element"] = Color3.fromRGB(42, 58, 48),
        },
        ["Rose"] = {
            ["Background"] = Color3.fromRGB(28, 20, 24), ["Inline"] = Color3.fromRGB(36, 26, 31),
            ["Tab"] = Color3.fromRGB(44, 32, 38), ["Text"] = Color3.fromRGB(255, 240, 245),
            ["Inactive Text"] = Color3.fromRGB(150, 120, 130),
            ["Accent"] = Color3.fromRGB(244, 114, 182), ["Outline"] = Color3.fromRGB(52, 36, 44),
            ["Hovered Element"] = Color3.fromRGB(58, 40, 48),
        },
        ["Midnight"] = {
            ["Background"] = Color3.fromRGB(12, 12, 18), ["Inline"] = Color3.fromRGB(18, 18, 28),
            ["Tab"] = Color3.fromRGB(24, 24, 38), ["Text"] = Color3.fromRGB(230, 230, 245),
            ["Inactive Text"] = Color3.fromRGB(110, 110, 140),
            ["Accent"] = Color3.fromRGB(129, 140, 248), ["Outline"] = Color3.fromRGB(32, 32, 48),
            ["Hovered Element"] = Color3.fromRGB(40, 40, 60),
        },
        ["Coral"] = {
            ["Background"] = Color3.fromRGB(28, 22, 20), ["Inline"] = Color3.fromRGB(36, 28, 25),
            ["Tab"] = Color3.fromRGB(44, 34, 30), ["Text"] = Color3.fromRGB(255, 245, 240),
            ["Inactive Text"] = Color3.fromRGB(150, 125, 115),
            ["Accent"] = Color3.fromRGB(255, 112, 67), ["Outline"] = Color3.fromRGB(52, 40, 35),
            ["Hovered Element"] = Color3.fromRGB(58, 44, 38),
        },
        ["Mono"] = {
            ["Background"] = Color3.fromRGB(14, 14, 14), ["Inline"] = Color3.fromRGB(22, 22, 22),
            ["Tab"] = Color3.fromRGB(30, 30, 30), ["Text"] = Color3.fromRGB(245, 245, 245),
            ["Inactive Text"] = Color3.fromRGB(120, 120, 120),
            ["Accent"] = Color3.fromRGB(220, 220, 220), ["Outline"] = Color3.fromRGB(40, 40, 40),
            ["Hovered Element"] = Color3.fromRGB(48, 48, 48),
        },
    }

    local ThemeOrder = {
        "Preset", "Sky", "Magma", "Sand", "Navy", "Emerald", "Rose", "Midnight", "Coral", "Mono"
    }

    Library.Themes = Themes
    Library.ThemeOrder = ThemeOrder
    Library.Theme = table.clone(Themes["Preset"])

    Library.ApplyTheme = function(Self, Name)
        local ThemeData = Themes[Name]

        if not ThemeData then
            return false
        end

        for Index, Color in ThemeData do
            Library:ChangeTheme(Index, Color)

            local SetFunction = SetFlags[Index .. "Theming"]
            if SetFunction then
                SetFunction(Color, 0)
            end
        end

        return true
    end

    Library.AnimatedColorpickers = {}
    Library.RainbowTime = 0

    Library.LerpColor = function(Self, A, B, T)
        return A:Lerp(B, math.clamp(T, 0, 1))
    end

    Library.EnsureColorpickerAnimations = function(Self)
        if Library.ColorpickerAnimationConnection then
            return
        end

        Library.ColorpickerAnimationConnection = Library:Connect(
            RunService.RenderStepped,
            function(DeltaTime)
                local RainbowSpeedSum = 0
                local RainbowCount = 0

                for Colorpicker in Library.AnimatedColorpickers do
                    if Colorpicker.AnimationEnabled and Colorpicker.AnimationMode == "Rainbow" then
                        local Speed = Colorpicker.AnimationSpeed
                        RainbowSpeedSum += Speed * Speed
                        RainbowCount += 1
                    end
                end

                if RainbowCount > 0 then
                    Library.RainbowTime += DeltaTime * (RainbowSpeedSum / RainbowCount)
                end

                for Colorpicker in Library.AnimatedColorpickers do
                    if not Colorpicker.AnimationEnabled then
                        continue
                    end

                    local Mode = Colorpicker.AnimationMode
                    if not Mode then
                        continue
                    end

                    local Speed = Colorpicker.AnimationSpeed
                    Speed = Speed * Speed

                    local Color
                    local Alpha = Colorpicker.Alpha

                    if Mode == "Rainbow" then
                        Color = Color3.fromHSV(
                            (Library.RainbowTime * 0.2) % 1, Colorpicker.Saturation,
                            Colorpicker.Value
                        )
                    else
                        Colorpicker.AnimationTime += DeltaTime * Speed

                        local Time = Colorpicker.AnimationTime
                        local Primary = Colorpicker.KeyframeOne
                        local Secondary = Colorpicker.KeyframeTwo
                        if not Primary or not Secondary then
                            continue
                        end

                        local T = 0

                        if Mode == "Linear" then
                            T = Time % 1
                        elseif Mode == "Strobe" then
                            T = math.floor(Time * 4) % 2
                        elseif Mode == "Ping Pong" then
                            T = math.abs((Time % 2) - 1)
                        elseif Mode == "Pulse" then
                            T = math.abs(math.sin(Time * 2))
                        elseif Mode == "Oscillation" then
                            T = (math.sin(Time) + 1) * 0.5
                        end

                        Color = Library:LerpColor(Primary.Color, Secondary.Color, T)
                        Alpha = Primary.Alpha + (Secondary.Alpha - Primary.Alpha) * T
                    end

                    Colorpicker:Set(Color, Alpha, true)
                end
            end
        )
    end

    Library.SetColorpickerAnimating = function(Self, Colorpicker, Enabled)
        if Enabled then
            Library.AnimatedColorpickers[Colorpicker] = true
            Library:EnsureColorpickerAnimations()
        else
            Library.AnimatedColorpickers[Colorpicker] = nil
        end
    end

    local CustomFont = {}
    do
        function CustomFont:New(Name, Weight, Style, Data)
            local Success, Result = pcall(
                function()
                    if not isfile(Data.Id) then
                        writefile(Data.Id, game:HttpGet(Data.Url))
                    end

                    local FontData = {
                        name = Name,
                        faces = {
                            {name = Name, weight = Weight, style = Style, assetId = getcustomasset(
                                Data.Id
                            )}
                        }
                    }

                    local AssetsFolder = Library.Directory .. Library.Folders.Assets
                    if SafeLibraryMakeFolder then
                        SafeLibraryMakeFolder(AssetsFolder)
                    end

                    writefile(`{AssetsFolder}/{Name}.font`, HttpService:JSONEncode(FontData))
                    return Font.new(getcustomasset(`{AssetsFolder}/{Name}.font`))
                end
            )

            return Success and Result or Font.fromEnum(Enum.Font.Code)
        end
        Library.Font = CustomFont:New(
            "Figtree", 400, "Regular",
            {
                Id = "Figtree",
                Url = "https://github.com/NIcoGabrielRealYtr/luas/raw/refs/heads/main/fonts/Figtree-SemiBold.ttf"
            }
        )
    end

    Library.Exit = function(Self)
        for _, Connection in Library.Connections do
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do
            coroutine.close(Thread)
        end

        if Self.Holder then
            Self.Holder.Instance:Destroy()
        end

        if Self.NotifHolder then
            Self.NotifHolder.Instance:Destroy()
        end

        if Self.UnusedHolder then
            Self.UnusedHolder.Instance:Destroy()
        end

        if Self.ToggleHolder then
            Self.ToggleHolder.Instance:Destroy()
        end

        if Self.Esp then
            pcall(
                function()
                    Self.Esp:Destroy()
                end
            )
        end

        Library = nil
        getgenv().Library = nil
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {Class = Class, Properties = Properties, Instance = Instance.new(Class)}

        for Index, Property in Properties do
            if Property == "FontFace" then
                Data.Instance[Property] = Library.Font
                continue
            end

            if Property == "TextSize" then
                Data.Instance[Property] = Library.FontSize
                continue
            end

            if Property == "Name" then
                Data.Instance[Property] = "\0"
                continue
            end

            if Class == "TextButton" then
                if Property == "AutoButtonColor" then
                    Data.Instance[Property] = false
                    continue
                end

                if Property == "Text" then
                    Data.Instance[Property] = ""
                    continue
                end
            end

            Data.Instance[Index] = Property
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)

        coroutine.wrap(
            function()
                coroutine.resume(NewThread)
            end
        )()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then
                if IsMobile and Signal == "MouseButton1Down" then
                    Connection = Self.Instance.InputBegan:Connect(
                        function(Input)
                            if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Callback(Input)
                            end
                        end
                    )

                    return
                end

                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(
            Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style],
            Enum.EasingDirection[Library.Animation.Direction]
        )

        if not Object then
            return
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return {}
        end

        if Object:IsA("Frame") then
            return {"BackgroundTransparency"}
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return {"TextTransparency", "BackgroundTransparency"}
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return {"BackgroundTransparency", "ImageTransparency"}
        elseif Object:IsA("ScrollingFrame") then
            return {"BackgroundTransparency", "ScrollBarImageTransparency"}
        elseif Object:IsA("TextBox") then
            return {"TextTransparency", "BackgroundTransparency"}
        elseif Object:IsA("UIStroke") then
            return {"Transparency"}
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then
            return
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween(
            {[Property] = Visibility and OldTransparency or 1}, nil, Object
        )

        Library:Connect(
            NewTween.Completed,
            function()
                if not Visibility then
                    task.wait()
                    Object[Property] = OldTransparency
                end
            end
        )

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then
            Self.Instance.Visible = true
        end

        local NewTween

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then
                continue
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        if not NewTween then
            if Callback and type(Callback) == "function" then
                Callback()
            end

            Self.Instance.Visible = Visibility
            return
        end

        Library:Connect(
            NewTween.Completed,
            function()
                if Callback and type(Callback) == "function" then
                    Callback()
                end

                Self.Instance.Visible = Visibility
            end
        )
    end

    Library.MakeDraggable = function(Self, Handle)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local HandleInstance = (Handle and Handle.Instance) or Gui
        local Dragging = false
        local DragStart
        local StartPosition

        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize

            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)

            Self:Tween(
                {Position = UDim2.new(0, NewX, 0, NewY)},
                TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            )
        end

        local InputChanged

        Library:Connect(
            HandleInstance.InputBegan,
            function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(
                        function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                Dragging = false
                                InputChanged:Disconnect()
                                InputChanged = nil
                            end
                        end
                    )
                end
            end
        )

        Library:Connect(
            UserInputService.InputChanged,
            function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end
        )

        return Dragging
    end

    Library.ConvertAnchor = function(Self)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance
        local AbsPos = Gui.AbsolutePosition

        Gui.AnchorPoint = Vector2.new(0, 0)
        task.wait()
        Gui.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then
            return
        end

        local Gui = Self.Instance

        local Resizing = false
        local CurrentSide = nil

        local StartMouse = nil
        local StartPosition = nil
        local StartSize = nil

        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create(
                "TextButton",
                {
                    Name = "\0", Size = Size, Position = Position,
                    BackgroundColor3 = Color3.fromRGB(166, 147, 243), BackgroundTransparency = 1,
                    Text = "", BorderSizePixel = 0, AutoButtonColor = false, Parent = Gui,
                    ZIndex = 99999,
                }
            )
            Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge("Left", UDim2.new(0, 0, 0, 0), UDim2.new(0, EdgeThickness, 1, 0)), Side = "L"},
            {
                Button = MakeEdge(
                    "Right", UDim2.new(1, -EdgeThickness, 0, 0), UDim2.new(0, EdgeThickness, 1, 0)
                ), Side = "R"
            },
            {Button = MakeEdge("Top", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, EdgeThickness)), Side = "T"},
            {
                Button = MakeEdge(
                    "Bottom", UDim2.new(0, 0, 1, -EdgeThickness), UDim2.new(1, 0, 0, EdgeThickness)
                ), Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true
            CurrentSide = Side

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false
            CurrentSide = nil

            for Index, Value in Edges do
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do
            Value.Button:Connect(
                "InputBegan",
                function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        BeginResizing(Value.Side)
                    end
                end
            )
        end

        Library:Connect(
            UserInputService.InputEnded,
            function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        EndResizing()
                    end
                end
            end
        )

        Library:Connect(
            RunService.RenderStepped,
            function()
                if not Resizing or not CurrentSide then
                    return
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y

                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end

                if w < Minimum.X then
                    if CurrentSide == "L" then
                        x = x - (Minimum.X - w)
                    end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then
                        y = y - (Minimum.Y - h)
                    end
                    h = Minimum.Y
                end

                Self:Tween(
                    {Position = UDim2.fromOffset(x, y)},
                    TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                )
                Self:Tween(
                    {Size = UDim2.fromOffset(w, h)},
                    TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                )
            end
        )
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then
            return
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = {...}
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = {}

        local Success, Result = Library:SafeCall(
            function()
                for Index, Value in Library.Flags do
                    if type(Value) == "table" and Value.Key then
                        Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                    elseif type(Value) == "table" and Value.Color then
                        Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                    else
                        Config[Index] = Value
                    end
                end
            end
        )

        if not Success then
            warn("Failed to get config:\n" .. Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(
            function()
                for Index, Value in Decoded do
                    local SetFunction = Library.SetFlags[Index]

                    if not SetFunction then
                        continue
                    end

                    if type(Value) == "table" and Value.Key then
                        SetFunction(Value)
                    elseif type(Value) == "table" and Value.Color then
                        SetFunction(Value.Color, Value.Alpha)
                    else
                        SetFunction(Value)
                    end
                end
            end
        )

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = {}
        local ReturnList = {}

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {Item = Object, Properties = Properties,}

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then
            return
        end

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.IsMouseOverItems = function(Self, Items)
        for _, Item in Items do
            if Item and Item:IsMouseOverFrame() then
                return true
            end
        end

        return false
    end

    Library.RegisterOpenFrameTrigger = function(Self, Trigger)
        Library.OpenFrameTriggers[Trigger] = true
    end

    Library.IsMouseOverAnyOpenFrameTrigger = function(Self)
        for Trigger in Library.OpenFrameTriggers do
            if Trigger:IsMouseOverFrame() then
                return true
            end
        end

        return false
    end

    Library.IsMouseOverOpenFrameData = function(Self, Data)
        if Self:IsMouseOverItems(Data.HoverItems) then
            return true
        end

        if Data.GetHoverItems then
            return Self:IsMouseOverItems(Data.GetHoverItems())
        end

        return false
    end

    Library.ShouldKeepOpenFrame = function(Self, Frame)
        local Data = Library.OpenFrames[Frame]

        if not Data then
            return false
        end

        if Self:IsMouseOverOpenFrameData(Data) then
            return true
        end

        for ChildFrame, ChildData in Library.OpenFrames do
            if ChildData.Owner == Frame and ChildFrame.IsOpen and Self:ShouldKeepOpenFrame(
                ChildFrame
            ) then
                return true
            end
        end

        return false
    end

    Library.RegisterOpenFrame = function(Self, Frame, Data)
        local Owner = Data.Owner

        if Owner == nil and Data.AnchorInstance then
            Owner = Self:FindOpenFrameOwner(Data.AnchorInstance)
        end

        Data.Owner = Owner

        if Owner then
            Self:CloseOpenFramesExcept(Frame, Owner)
        else
            Self:CloseOpenFramesExcept(Frame)
        end

        Library.OpenFrames[Frame] = Data
        Library:EnsureOpenFramesConnection()
    end

    Library.UnregisterOpenFrame = function(Self, Frame)
        Library.OpenFrames[Frame] = nil
    end

    Library.FindOpenFrameOwner = function(Self, Instance)
        if not Instance then
            return nil
        end

        for Frame, Data in Library.OpenFrames do
            if Frame.IsOpen and Data.PopupInstance then
                if Instance:IsDescendantOf(Data.PopupInstance) or Instance == Data.PopupInstance then
                    return Frame
                end
            end
        end

        return nil
    end

    Library.CloseOpenFramesExcept = function(Self, KeepFrame, KeepOwner)
        for Frame, Data in Library.OpenFrames do
            if Frame == KeepFrame or Frame == KeepOwner then
                continue
            end

            if Frame.IsOpen then
                Frame:SetOpen(false)
            end
        end
    end

    Library.CloseOpenFrameChildren = function(Self, Parent)
        for Frame, Data in Library.OpenFrames do
            if Data.Owner == Parent and Frame.IsOpen then
                Frame:SetOpen(false)
            end
        end
    end

    Library.SetOpenFrameInteracting = function(Self, Bool)
        Library.OpenFrameInteracting = Bool
    end

    Library.ProcessOpenFrames = function(Self)
        if Library.OpenFrameInteracting then
            return
        end

        if Self:IsMouseOverAnyOpenFrameTrigger() then
            return
        end

        local ToClose = {}

        for Frame, Data in Library.OpenFrames do
            if Frame.IsOpen and not Frame.Picking and not Self:ShouldKeepOpenFrame(Frame) then
                table.insert(ToClose, Frame)
            end
        end

        for _, Frame in ToClose do
            Frame:SetOpen(false)
        end
    end

    Library.EnsureOpenFramesConnection = function(Self)
        if Library.OpenFramesInputConnection then
            return
        end

        Library.OpenFramesInputConnection = Library:Connect(
            UserInputService.InputBegan,
            function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                task.defer(
                    function()
                        Library:ProcessOpenFrames()
                    end
                )
            end
        )
    end

    Library.GetScreenScale = function(Self)
        local Scale = 1

        for _, Obj in Library.Holder.Instance:GetDescendants() do
            if Obj:IsA("UIScale") then
                Scale *= Obj.Scale
            end
        end

        return Scale
    end

    Library.PopupPosition = function(Self, Anchor, Popup, ExtraY)
        local Scale = Library:GetScreenScale()
        ExtraY = ExtraY or 0

        local X = Anchor.AbsolutePosition.X / Scale
        local Y = (Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset + ExtraY) / Scale

        return UDim2.fromOffset(X, Y)
    end

    Library.VisibleCheck = function(Self)
        local Object = Self.Instance

        if not Object then
            return
        end

        local OriginalParent = Object.Parent

        Library:Connect(
            Object:GetPropertyChangedSignal("Visible"),
            function()
                local IsVisible = Object.Visible
                Object.Parent = IsVisible and OriginalParent or Library.UnusedHolder.Instance
            end
        )
    end

    Library.Holder = Library:Create(
        "ScreenGui",
        {
            Parent = gethui(), IgnoreGuiInset = true, Name = "\0",
            ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false
        }
    )

    Library.NotifHolder = Library:Create(
        "ScreenGui",
        {
            Parent = gethui(), IgnoreGuiInset = true, Name = "\0", DisplayOrder = 999999999,
            ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false
        }
    )

    Library:Create(
        "UIListLayout",
        {
            Parent = Library.NotifHolder.Instance, Name = "\0",
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        }
    )

    Library:Create(
        "UIPadding",
        {
            Parent = Library.NotifHolder.Instance, Name = "\0", PaddingTop = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        }
    )

    Library.UnusedHolder = Library:Create(
        "ScreenGui",
        {
            Parent = gethui(), Name = "\0", Enabled = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Global, ResetOnSpawn = false
        }
    )

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0, Saturation = 0, Value = 0, Alpha = 0,
                Color = Color3.fromRGB(255, 255, 255), HexValue = "#FFFFFF", Flag = Data.Flag,
                IsOpen = false, Mini = Data.Mini == true, AnimationEnabled = false,
                AnimationMode = "Linear", AnimationSpeed = 1, AnimationTime = 0, Pages = {},
                Current = nil, Items = {}
            }

            local Items = {}
            do
                Items["ColorpickerButton"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Data.Parent.Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", AutoButtonColor = false, Size = UDim2.new(0, 16, 0, 16),
                        BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                    }
                )

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["ColorpickerButton"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Library:Create(
                    "UIGradient",
                    {
                        Name = "\0", Parent = Items["ColorpickerButton"].Instance, Rotation = 90,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                        }
                    }
                )

                Items["ColorpickerWindow"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Library.Holder.Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", Visible = false, AutoButtonColor = false,
                        Position = UDim2.new(0, 996, 0, 92), Size = UDim2.new(0, 250, 0, 250),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Top"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["ColorpickerWindow"].Instance,
                        Size = UDim2.new(1, 0, 0, 55), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        BottomRightRadius = UDim.new(0, 0), BottomLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["Pages"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1,
                        Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0
                    }
                )

                Library:Create(
                    "UIPadding",
                    {Name = "\0", Parent = Items["Pages"].Instance, PaddingRight = UDim.new(0, 10)}
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Pages"].Instance,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["Content"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["ColorpickerWindow"].Instance,
                        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 56),
                        Size = UDim2.new(1, 0, 1, -56), BorderSizePixel = 0
                    }
                )

                Library:Create(
                    "UICorner", {Name = "\0", Parent = Items["ColorpickerWindow"].Instance}
                )

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["ColorpickerWindow"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value =
                    Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})

                if Items["Palette"] then
                    Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})
                end

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha, Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue, Transparency = 1 - Colorpicker.Alpha
                }

                if not IsFromAlpha and Items["Alpha"] then
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.IsSettings or Data.Mini or (Data.Section and Data.Section.IsSettings)

            function Colorpicker:SetOpen(Bool)
                if Debounce then
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true

                if Colorpicker.IsOpen then
                    ColorpickerWindow.Position = UDim2.new(
                        0, ColorpickerButton.AbsolutePosition.X, 0,
                        ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + GuiInset
                    )

                    ColorpickerWindow.Parent = Library.Holder.Instance
                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween(
                        {
                            Position = UDim2.new(
                                0, ColorpickerButton.AbsolutePosition.X, 0,
                                ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y + 10 + GuiInset
                            )
                        }
                    )

                    Items["ColorpickerWindow"]:FadeDescendants(
                        true,
                        function()
                            Debounce = false
                        end
                    )

                    Library:RegisterOpenFrame(
                        Colorpicker,
                        {
                            HoverItems = {Items["ColorpickerWindow"], Items["ColorpickerButton"]},
                            AnchorInstance = ColorpickerButton, PopupInstance = ColorpickerWindow,
                        }
                    )
                else
                    Items["ColorpickerWindow"]:Tween(
                        {
                            Position = UDim2.new(
                                0, ColorpickerButton.AbsolutePosition.X, 0,
                                ColorpickerButton.AbsolutePosition.Y + ColorpickerButton.AbsoluteSize.Y - 10 + GuiInset
                            )
                        }
                    )
                    Items["ColorpickerWindow"]:FadeDescendants(
                        false,
                        function()
                            ColorpickerWindow.Parent = Library.UnusedHolder.Instance
                            Debounce = false
                        end
                    )

                    Library:CloseOpenFrameChildren(Colorpicker)
                    Library:UnregisterOpenFrame(Colorpicker)
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
            end

            Items["ColorpickerWindow"]:VisibleCheck()

            local SlidingPalette = false
            local PaletteChanged

            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = math.clamp(
                    1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X,
                    0, 1
                )
                local ValueY = math.clamp(
                    1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y,
                    0, 1
                )

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = math.clamp(
                    (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X,
                    0, 0.935
                )
                local SlideY = math.clamp(
                    (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y,
                    0, 0.92
                )

                Items["PaletteDragger"]:Tween(
                    {Position = UDim2.new(SlideX, 0, SlideY, 0)},
                    TweenInfo.new(
                        Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
                    )
                )
                Colorpicker:Update()
            end

            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end

                local ValueY = math.clamp(
                    (Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
                    0, 1
                )

                Colorpicker.Hue = ValueY

                local SlideY = math.clamp(
                    (Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y,
                    0, 0.915
                )

                Items["HueDragger"]:Tween(
                    {Position = UDim2.new(0, 0, SlideY, 0)},
                    TweenInfo.new(
                        Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
                    )
                )
                Colorpicker:Update()
            end

            local SlidingAlpha = false
            local AlphaChanged

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = math.clamp(
                    (Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X,
                    0, 1
                )

                Colorpicker.Alpha = ValueX

                local SlideX = math.clamp(
                    (Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X,
                    0, 0.915
                )

                Items["AlphaDragger"]:Tween(
                    {Position = UDim2.new(SlideX, 0, 0, 0)},
                    TweenInfo.new(
                        Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
                    )
                )
                Colorpicker:Update(true)
            end

            function Colorpicker:Set(Color, Alpha, FromAnimation)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- lul
                end

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0

                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.935)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.92)

                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 0.915)
                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.915)

                local DraggerInfo = FromAnimation and TweenInfo.new(
                    0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.Out
                ) or TweenInfo.new(
                    Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
                )

                if FromAnimation then
                    Colorpicker.Color = Color
                    Colorpicker.HexValue = Colorpicker.Color:ToHex()
                    Items["ColorpickerButton"].Instance.BackgroundColor3 = Colorpicker.Color

                    if Items["Palette"] then
                        Items["Palette"].Instance.BackgroundColor3 = Color3.fromHSV(
                            Colorpicker.Hue, 1, 1
                        )
                    end

                    if Items["Alpha"] then
                        Items["Alpha"].Instance.BackgroundColor3 = Colorpicker.Color
                    end

                    if Items["PaletteDragger"] then
                        Items["PaletteDragger"]:Tween(
                            {Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, DraggerInfo
                        )
                    end

                    if Items["HueDragger"] then
                        Items["HueDragger"]:Tween(
                            {Position = UDim2.new(0, 0, HuePositionY, 0)}, DraggerInfo
                        )
                    end

                    if Items["AlphaDragger"] then
                        Items["AlphaDragger"]:Tween(
                            {Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, DraggerInfo
                        )
                    end

                    Flags[Colorpicker.Flag] = {
                        Alpha = Colorpicker.Alpha, Color = Colorpicker.Color,
                        HexValue = Colorpicker.HexValue, Transparency = 1 - Colorpicker.Alpha
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                    end

                    return
                end

                if Items["PaletteDragger"] then
                    Items["PaletteDragger"]:Tween(
                        {Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, DraggerInfo
                    )
                end

                if Items["HueDragger"] then
                    Items["HueDragger"]:Tween(
                        {Position = UDim2.new(0, 0, HuePositionY, 0)}, DraggerInfo
                    )
                end

                if Items["AlphaDragger"] then
                    Items["AlphaDragger"]:Tween(
                        {Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, DraggerInfo
                    )
                end

                Colorpicker:Update()
            end

            function Colorpicker:Page(Params)
                Params = Params or {}

                local Page = {
                    Name = Params.Name or Params.name or "Page",
                    Icon = Params.Icon or Params.icon or "", Colorpicker = Colorpicker, Items = {},
                    Active = false, Debounce = false
                }

                local PageItems = {}
                do
                    PageItems["Inactive"] = Library:Create(
                        "TextButton",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = Colorpicker.Items["Pages"].Instance,
                            TextColor3 = Color3.fromRGB(0, 0, 0), Text = "",
                            AutoButtonColor = false, BackgroundTransparency = 1,
                            Size = UDim2.new(0, 35, 0, 35), BorderSizePixel = 0,
                            ClipsDescendants = true, LayoutOrder = #Colorpicker.Pages + 1,
                            AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundColor3 = Library.Theme["Tab"]
                        }
                    ):AddToTheme({BackgroundColor3 = 'Tab'})

                    Library:Create(
                        "UICorner", {Name = "\0", Parent = PageItems["Inactive"].Instance}
                    )

                    PageItems["Icon"] = Library:Create(
                        "ImageLabel",
                        {
                            Name = "\0", Parent = PageItems["Inactive"].Instance,
                            ImageColor3 = Library.Theme["Inactive Text"],
                            AnchorPoint = Vector2.new(0, 0.5), Image = Page.Icon,
                            BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.5, 1),
                            Size = UDim2.new(0, 20, 0, 20), BorderSizePixel = 0
                        }
                    ):AddToTheme({ImageColor3 = 'Inactive Text'})

                    PageItems["Text"] = Library:Create(
                        "TextLabel",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize + 2,
                            Parent = PageItems["Inactive"].Instance, Visible = true,
                            TextTransparency = 1, AnchorPoint = Vector2.new(0, 0.5),
                            TextColor3 = Library.Theme["Text"], Text = Page.Name,
                            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                            Position = UDim2.new(0, 30, 0.5, 0), BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.XY
                        }
                    ):AddToTheme({TextColor3 = 'Text'})

                    Library:Create(
                        "UIPadding",
                        {
                            Name = "\0", Parent = PageItems["Inactive"].Instance,
                            PaddingRight = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8)
                        }
                    )

                    PageItems["Page"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Library.UnusedHolder.Instance,
                            BackgroundTransparency = 1, Visible = false,
                            Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0
                        }
                    )

                    Page.Items = PageItems
                end

                local GetSize = function()
                    PageItems["Inactive"].Instance.Size = UDim2.new(0, 35, 0, 35)
                    PageItems["Inactive"].Instance.AutomaticSize = Enum.AutomaticSize.None

                    local TextWidth = PageItems["Text"].Instance.TextBounds.X
                    if TextWidth <= 0 then
                        TextWidth = #(Page.Name) * ((Library.FontSize + 2) * 0.55)
                    end

                    return Vector2.new(math.max(35, math.ceil(65 + TextWidth)), 35)
                end

                PageItems["Inactive"]:OnHover(
                    function()
                        if Page.Active then
                            return
                        end

                        PageItems["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
                        PageItems["Inactive"]:Tween({BackgroundTransparency = 0})
                    end,
                    function()
                        if Page.Active then
                            return
                        end

                        PageItems["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                        PageItems["Inactive"]:Tween({BackgroundTransparency = 1})
                    end
                )

                local Size = GetSize()
                local X = Size.X

                function Page:Turn()
                    local Old = Colorpicker.Current

                    if Old == Page then
                        return
                    end

                    if Page.Debounce then
                        return
                    end

                    if Old and Old.Debounce then
                        return
                    end

                    Page.Debounce = true

                    if Old then
                        Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
                        Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

                        Old.Items["Inactive"]:Tween(
                            {BackgroundTransparency = 1, Size = UDim2.new(0, 35, 0, 35)}
                        )
                        Old.Items["Text"]:Tween({TextTransparency = 1})

                        Old.Items["Page"].Instance.Visible = false
                        Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                        Old.Active = false
                        Old.Debounce = false
                    end

                    PageItems["Page"].Instance.Parent = Colorpicker.Items["Content"].Instance
                    PageItems["Page"].Instance.Visible = true

                    local PageZIndex = Colorpicker.IsOpen and (IsSettings and Library.ZIndexOrder.ColorpickerWindow + 4 or Library.ZIndexOrder.ColorpickerWindow) or 1
                    local PageDescendants = PageItems["Page"].Instance:GetDescendants()
                    table.insert(PageDescendants, PageItems["Page"].Instance)

                    for _, Value in PageDescendants do
                        if Value.ClassName:find("UI") then
                            continue
                        end

                        Value.ZIndex = PageZIndex
                    end

                    PageItems["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                    PageItems["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

                    PageItems["Inactive"].Instance.BackgroundTransparency = 0
                    PageItems["Text"].Instance.TextTransparency = 0

                    local Size = GetSize()

                    PageItems["Inactive"]:Tween(
                        {BackgroundTransparency = 0, Size = UDim2.new(0, Size.X, 0, 35)}
                    )
                    PageItems["Text"]:Tween({TextTransparency = 0})

                    Colorpicker.Current = Page
                    Page.Active = true
                    Page.Debounce = false
                end

                PageItems["Inactive"]:Connect(
                    "MouseButton1Down",
                    function()
                        Page:Turn()
                    end
                )

                table.insert(Colorpicker.Pages, Page)
                return Page
            end

            do -- Pages
                local ColorTab
                local AnimationsTab

                if Colorpicker.Mini then
                    Items["Top"].Instance.Visible = false
                    Items["Content"].Instance.Position = UDim2.new(0, 0, 0, 0)
                    Items["Content"].Instance.Size = UDim2.new(1, 0, 1, 0)

                    Items["Color"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Items["Content"].Instance,
                            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                            BorderSizePixel = 0
                        }
                    )
                else
                    ColorTab = Colorpicker:Page(
                        {Name = "Color", Icon = "rbxassetid://78658715450812"}
                    )
                    AnimationsTab = Colorpicker:Page(
                        {Name = "Animations", Icon = "rbxassetid://102653368798088"}
                    )
                    Items["Color"] = ColorTab.Items.Page
                end

                do -- Color tab
                    Items["Palette"] = Library:Create(
                        "TextButton",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = Items["Color"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                            Text = "", AutoButtonColor = false, Position = UDim2.new(0, 10, 0, 10),
                            Size = UDim2.new(1, -45, 1, -45), BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["Palette"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Items["Saturation"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Items["Palette"].Instance,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UIGradient",
                        {
                            Name = "\0", Parent = Items["Saturation"].Instance,
                            Transparency = NumberSequence.new{
                                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)
                            }
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["Saturation"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Items["Value"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Items["Palette"].Instance,
                            Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                        }
                    )

                    Library:Create(
                        "UIGradient",
                        {
                            Name = "\0", Parent = Items["Value"].Instance, Rotation = 90,
                            Transparency = NumberSequence.new{
                                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)
                            }
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["Value"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Items["PaletteDragger"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Items["Palette"].Instance,
                            BackgroundTransparency = 1, Size = UDim2.new(0, 12, 0, 12),
                            BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["PaletteDragger"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Library:Create(
                        "UIStroke",
                        {Name = "\0", Parent = Items["PaletteDragger"].Instance, Color = Library.Theme["Text"]}
                    ):AddToTheme({Color = 'Text'})

                    Items["Hue"] = Library:Create(
                        "TextButton",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = Items["Color"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                            Text = "", AutoButtonColor = false,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 10),
                            Size = UDim2.new(0, 15, 1, -20), BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["Hue"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Library:Create(
                        "UIGradient",
                        {
                            Name = "\0", Parent = Items["Hue"].Instance, Rotation = 90,
                            Color = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                            }
                        }
                    )

                    Items["HueDragger"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Items["Hue"].Instance, BackgroundTransparency = 1,
                            Size = UDim2.new(0, 15, 0, 15), BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["HueDragger"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Library:Create(
                        "UIStroke",
                        {Name = "\0", Parent = Items["HueDragger"].Instance, Color = Library.Theme["Text"]}
                    ):AddToTheme({Color = 'Text'})

                    Items["Alpha"] = Library:Create(
                        "TextButton",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = Items["Color"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                            Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(0, 1),
                            Position = UDim2.new(0, 10, 1, -10), Size = UDim2.new(1, -45, 0, 15),
                            BorderSizePixel = 0, BackgroundColor3 = Color3.fromRGB(108, 79, 255)
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["Alpha"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Items["Checkers"] = Library:Create(
                        "ImageLabel",
                        {
                            Name = "\0", Parent = Items["Alpha"].Instance,
                            ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 6, 0, 6),
                            Image = "http://www.roblox.com/asset/?id=18274452449",
                            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 2,
                            ImageColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UIGradient",
                        {
                            Name = "\0", Parent = Items["Checkers"].Instance,
                            Transparency = NumberSequence.new{
                                NumberSequenceKeypoint.new(0, 1),
                                NumberSequenceKeypoint.new(0.37, 0.5),
                                NumberSequenceKeypoint.new(1, 0)
                            }
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["Checkers"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Items["AlphaDragger"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Items["Alpha"].Instance,
                            BackgroundTransparency = 1, Size = UDim2.new(0, 15, 0, 15),
                            BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = Items["AlphaDragger"].Instance,
                            TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                            BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                        }
                    )

                    Library:Create(
                        "UIStroke",
                        {Name = "\0", Parent = Items["AlphaDragger"].Instance, Color = Library.Theme["Text"]}
                    ):AddToTheme({Color = 'Text'})
                end

                if ColorTab then
                    ColorTab:Turn()
                end

                if not Colorpicker.Mini then
                    do -- Animations tab
                        Items["Animations"] = AnimationsTab.Items.Page

                        Library:Create(
                            "UIPadding",
                            {
                                Name = "\0", Parent = Items["Animations"].Instance,
                                PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                                PaddingRight = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)
                            }
                        )

                        Library:Create(
                            "UIListLayout",
                            {
                                Name = "\0", Parent = Items["Animations"].Instance,
                                Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder
                            }
                        )

                        local KeyframeOneLabel
                        local KeyframeTwoLabel

                        local SyncAnimationControls = function(Mode)
                            local IsRainbow = Mode == "Rainbow"

                            if KeyframeOneLabel then
                                KeyframeOneLabel:SetVisibility(not IsRainbow)
                            end

                            if KeyframeTwoLabel then
                                KeyframeTwoLabel:SetVisibility(not IsRainbow)
                            end
                        end

                        local UpdateAnimating = function()
                            Library:SetColorpickerAnimating(
                                Colorpicker, Colorpicker.AnimationEnabled
                            )
                        end

                        Library:Toggle(
                            {
                                Name = "Enabled", Flag = Colorpicker.Flag .. "_Enabled",
                                Default = false, Parent = Items["Animations"],
                                Callback = function(Value)
                                    Colorpicker.AnimationEnabled = Value
                                    UpdateAnimating()
                                end
                            }
                        )

                        Library:Dropdown(
                            {
                                Name = "Animations", Flag = Colorpicker.Flag .. "_Animation",
                                Items = {
                                    "Linear", "Oscillation", "Pulse", "Strobe", "Ping Pong",
                                    "Rainbow"
                                }, Default = "Linear", Parent = Items["Animations"],
                                Callback = function(Value)
                                    Colorpicker.AnimationMode = Value
                                    SyncAnimationControls(Value)
                                    UpdateAnimating()
                                end
                            }
                        )

                        Library:Slider(
                            {
                                Name = "Speed", Flag = Colorpicker.Flag .. "_Speed", Min = 0,
                                Max = 3, Default = 1, Decimals = 0.01, Suffix = "x",
                                Parent = Items["Animations"],
                                Callback = function(Value)
                                    Colorpicker.AnimationSpeed = Value
                                end
                            }
                        )

                        KeyframeOneLabel = Library:Label(
                            {Name = "Keyframe 1", Parent = Items["Animations"]}
                        )
                        Colorpicker.KeyframeOne = Library:CreateColorpicker(
                            {
                                Parent = KeyframeOneLabel.Items.SubElements,
                                Flag = Colorpicker.Flag .. "_Keyframe1",
                                Default = Color3.fromRGB(255, 0, 0), Mini = true, IsSettings = true,
                            }
                        )

                        KeyframeTwoLabel = Library:Label(
                            {Name = "Keyframe 2", Parent = Items["Animations"]}
                        )
                        Colorpicker.KeyframeTwo = Library:CreateColorpicker(
                            {
                                Parent = KeyframeTwoLabel.Items.SubElements,
                                Flag = Colorpicker.Flag .. "_Keyframe2",
                                Default = Color3.fromRGB(255, 255, 255), Mini = true,
                                IsSettings = true,
                            }
                        )

                        Colorpicker.AnimationEnabled = Flags[Colorpicker.Flag .. "_Enabled"] or false
                        Colorpicker.AnimationMode = Flags[Colorpicker.Flag .. "_Animation"] or "Linear"
                        Colorpicker.AnimationSpeed = Flags[Colorpicker.Flag .. "_Speed"] or 1

                        SyncAnimationControls(Colorpicker.AnimationMode)
                        UpdateAnimating()
                    end
                end
            end

            Items["ColorpickerButton"]:Connect(
                "MouseButton1Down",
                function()
                    Colorpicker:SetOpen(not Colorpicker.IsOpen)
                end
            )

            Library:RegisterOpenFrameTrigger(Items["ColorpickerButton"])

            if Items["Palette"] then
                Items["Palette"]:Connect(
                    "InputBegan",
                    function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            Library:SetOpenFrameInteracting(true)
                            SlidingPalette = true

                            Colorpicker:SlidePalette(Input)

                            if PaletteChanged then
                                return
                            end

                            PaletteChanged = Input.Changed:Connect(
                                function()
                                    if Input.UserInputState == Enum.UserInputState.End then
                                        SlidingPalette = false
                                        Library:SetOpenFrameInteracting(false)

                                        PaletteChanged:Disconnect()
                                        PaletteChanged = nil
                                    end
                                end
                            )
                        end
                    end
                )
            end

            if Items["Hue"] then
                Items["Hue"]:Connect(
                    "InputBegan",
                    function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            Library:SetOpenFrameInteracting(true)
                            SlidingHue = true

                            Colorpicker:SlideHue(Input)

                            if HueChanged then
                                return
                            end

                            HueChanged = Input.Changed:Connect(
                                function()
                                    if Input.UserInputState == Enum.UserInputState.End then
                                        SlidingHue = false
                                        Library:SetOpenFrameInteracting(false)

                                        HueChanged:Disconnect()
                                        HueChanged = nil
                                    end
                                end
                            )
                        end
                    end
                )
            end

            if Items["Alpha"] then
                Items["Alpha"]:Connect(
                    "InputBegan",
                    function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            Library:SetOpenFrameInteracting(true)
                            SlidingAlpha = true

                            Colorpicker:SlideAlpha(Input)

                            if AlphaChanged then
                                return
                            end

                            AlphaChanged = Input.Changed:Connect(
                                function()
                                    if Input.UserInputState == Enum.UserInputState.End then
                                        SlidingAlpha = false
                                        Library:SetOpenFrameInteracting(false)

                                        AlphaChanged:Disconnect()
                                        AlphaChanged = nil
                                    end
                                end
                            )
                        end
                    end
                )
            end

            if Items["Alpha"] and Items["Palette"] and Items["Hue"] then
                Library:Connect(
                    UserInputService.InputChanged,
                    function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                            if SlidingPalette then
                                Colorpicker:SlidePalette(Input)
                            elseif SlidingHue then
                                Colorpicker:SlideHue(Input)
                            elseif SlidingAlpha then
                                Colorpicker:SlideAlpha(Input)
                            end
                        end
                    end
                )
            end

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end

            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Name = Data.Name or "Keybind", Flag = Data.Flag, IsOpen = false, Key = "",
                Mode = "", Value = "", Toggled = false, Picking = false, Items = {},
            }

            local Items = {}
            do
                Items["KeyButton"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Data.Parent.Instance, TextColor3 = Library.Theme["Inactive Text"],
                        Text = "MOUSE2", AutoButtonColor = false, BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 1, 0), BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X
                    }
                ):AddToTheme({TextColor3 = 'Inactive Text'})

                Items["KeybindWindow"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Library.Holder.Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", Visible = false, AutoButtonColor = false,
                        Size = UDim2.new(0, 240, 0, 0), Position = UDim2.new(0, 1004, 0, 121),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["KeybindWindow"].Instance,
                        PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)
                    }
                )

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["KeybindWindow"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["KeybindWindow"].Instance,
                        TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["KeybindWindow"].Instance,
                        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Keybind.Items = Items
            end

            local ListItem

            if Library.KeyList then
                ListItem = Library.KeyList:Add(Keybind.Name, "None")
            end

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Keybind:SetOpen(Bool)
                if Debounce then
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true

                if Keybind.IsOpen then
                    KeybindWindow.Position = UDim2.new(
                        0, KeyButton.AbsolutePosition.X, 0,
                        KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + GuiInset
                    )

                    KeybindWindow.Parent = Library.Holder.Instance
                    Items["KeybindWindow"]:Tween(
                        {
                            Position = UDim2.new(
                                0, KeyButton.AbsolutePosition.X, 0,
                                KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y + 10 + GuiInset
                            )
                        }
                    )

                    Items["KeybindWindow"]:FadeDescendants(
                        true,
                        function()
                            Debounce = false
                        end
                    )

                    Library:RegisterOpenFrame(
                        Keybind,
                        {
                            HoverItems = {Items["KeybindWindow"], Items["SettingsButton"]},
                            AnchorInstance = KeyButton, PopupInstance = KeybindWindow,
                        }
                    )
                else
                    Items["KeybindWindow"]:Tween(
                        {
                            Position = UDim2.new(
                                0, KeyButton.AbsolutePosition.X, 0,
                                KeyButton.AbsolutePosition.Y + KeyButton.AbsoluteSize.Y - 10 + GuiInset
                            )
                        }
                    )
                    Items["KeybindWindow"]:FadeDescendants(
                        false,
                        function()
                            Items["KeybindWindow"].Instance.Parent = Library.UnusedHolder.Instance
                            Debounce = false
                        end
                    )

                    Library:CloseOpenFrameChildren(Keybind)
                    Library:UnregisterOpenFrame(Keybind)
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            Items["KeybindWindow"]:VisibleCheck()

            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode, Key = Keybind.Key, Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            local ModeDropdown = Library:Dropdown(
                {
                    Name = "Mode", Flag = Keybind.Flag .. "ModeDropdown",
                    Parent = Items["KeybindWindow"], Items = {"Toggle", "Hold", "Always"},
                    Default = "Toggle",
                    Callback = function(Value)
                        Keybind.Mode = Value

                        Keybind:SetMode()

                        if Value == "Always" then
                            Keybind:Press(true)
                        end
                    end
                }
            )

            local ResetButton = Library:Button(
                {
                    Name = "Reset", Parent = Items["KeybindWindow"],
                    Callback = function()
                        if Data.Default then
                            Keybind:Set(Data.Default)
                        end
                    end
                }
            )

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then
                    Keybind.Toggled = true
                end

                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode, Key = Keybind.Key, Toggled = Keybind.Toggled
                }

                if Data.Callback then
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                if ListItem then
                    ListItem:SetStatus(Keybind.Toggled)
                end
            end

            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "None"
                    local TextToDisplay = string.gsub(
                        string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", ""
                    ) or "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode, Key = Keybind.Key, Toggled = Keybind.Toggled
                    }

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                    end
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode()
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode()
                    end

                    local KeyString = Keys[Keybind.Key] or string.gsub(
                        tostring(RealKey), "Enum.", ""
                    ) or RealKey
                    local TextToDisplay = KeyString and string.gsub(
                        string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", ""
                    ) or "None"

                    TextToDisplay = string.gsub(
                        string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", ""
                    )

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    if ListItem then
                        ListItem:Set(Keybind.Name, Keybind.Value)
                        ListItem:SetStatus(Keybind.Toggled)
                    end
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode()

                    if Data.Callback then
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
            end

            Items["KeyButton"]:Connect(
                "MouseButton1Click",
                function()
                    Keybind.Picking = true

                    Items["KeyButton"].Instance.Text = ". . ."

                    local InputBegan
                    InputBegan = UserInputService.InputBegan:Connect(
                        function(Input)
                            if Input.UserInputType == Enum.UserInputType.Keyboard then
                                Keybind:Set(Input.KeyCode)
                            else
                                Keybind:Set(Input.UserInputType)
                            end

                            InputBegan:Disconnect()
                            InputBegan = nil
                        end
                    )
                end
            )

            Library:Connect(
                UserInputService.InputBegan,
                function(Input, GPE)
                    if Keybind.Value == "None" then
                        return
                    end

                    if not GPE then
                        if tostring(Input.KeyCode) == Keybind.Key then
                            if Keybind.Mode == "Toggle" then
                                Keybind:Press()
                            elseif Keybind.Mode == "Hold" then
                                Keybind:Press(true)
                            elseif Keybind.Mode == "Always" then
                                Keybind:Press(true)
                            end
                        elseif tostring(Input.UserInputType) == Keybind.Key then
                            if Keybind.Mode == "Toggle" then
                                Keybind:Press()
                            elseif Keybind.Mode == "Hold" then
                                Keybind:Press(true)
                            elseif Keybind.Mode == "Always" then
                                Keybind:Press(true)
                            end
                        end
                    end
                end
            )

            Library:Connect(
                UserInputService.InputEnded,
                function(Input, GPE)
                    if GPE then
                        return
                    end

                    if Keybind.Value == "None" then
                        return
                    end

                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Hold" then
                            Keybind:Press(false)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Hold" then
                            Keybind:Press(false)
                        elseif Keybind.Mode == "Always" then
                            Keybind:Press(true)
                        end
                    end
                end
            )

            Library:RegisterOpenFrameTrigger(Items["KeyButton"])

            Items["KeyButton"]:Connect(
                "MouseButton2Down",
                function()
                    Keybind:SetOpen(not Keybind.IsOpen)
                end
            )

            if Data.Default then
                Keybind:Set({Mode = Data.Mode or "Toggle", Key = Data.Default,})
            end

            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

        Library.Watermark = function(Self, Params)
            Params = Params or {}

            local Watermark = {
                Name = Params.Name or Params.name or Self.Name or "Watermark",
                Logo = Params.Logo or Params.logo or Self.Logo, Window = Self, Items = {}
            }

            local Items = {}
            do
                Items["Watermark"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Library.Holder.Instance,
                        AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -10),
                        Size = UDim2.new(0, 0, 0, 45), BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Items["Watermark"]:MakeDraggable()

                Library:Create("UICorner", {Name = "\0", Parent = Items["Watermark"].Instance})

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["Watermark"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["Watermark"].Instance,
                        PaddingRight = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Watermark"].Instance,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Items["Main"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Watermark"].Instance,
                        BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X
                    }
                )

                Items["Title"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize + 4,
                        Parent = Items["Main"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Watermark.Name, AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 38, 0.5, 0), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["Logo"] = Library:Create(
                    "ImageLabel",
                    {
                        Name = "\0", Parent = Items["Main"].Instance,
                        ImageColor3 = Library.Theme["Accent"], ScaleType = Enum.ScaleType.Fit,
                        AnchorPoint = Vector2.new(0, 0.5), Image = Watermark.Logo,
                        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.new(0, 30, 0, 30), BorderSizePixel = 0
                    }
                ):AddToTheme({ImageColor3 = 'Accent'})

                Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Watermark"].Instance,
                        Size = UDim2.new(0, 1, 1, 0), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["NewHolder"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Watermark"].Instance,
                        BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X
                    }
                )

                Items["FPSText"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["NewHolder"].Instance, RichText = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = 'FPS: <font color="rgb(120, 120, 120)">0</font>',
                        Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                        BorderSizePixel = 0, BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["NewHolder"].Instance, Padding = UDim.new(0, 5),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Library:Create(
                    "UIPadding",
                    {Name = "\0", Parent = Items["NewHolder"].Instance, PaddingTop = UDim.new(0, 6)}
                )

                Items["PingText"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["NewHolder"].Instance, RichText = true,
                        TextColor3 = Library.Theme["Text"],
                        Text = 'PING: <font color="rgb(120, 120, 120)">0MS</font>',
                        Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                        BorderSizePixel = 0, BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Watermark.Items = Items
            end

            local GetInactiveRGB = function()
                local Color = Library.Theme["Inactive Text"]
                return string.format(
                    "rgb(%d, %d, %d)", math.floor(Color.R * 255 + 0.5),
                    math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5)
                )
            end

            local GetPing = function()
                local Ok, Value = pcall(
                    function()
                        return math.floor(LocalPlayer:GetNetworkPing() * 1000)
                    end
                )

                if Ok and Value then
                    return Value
                end

                Ok, Value = pcall(
                    function()
                        return math.floor(
                            game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                        )
                    end
                )

                return (Ok and Value) or 0
            end

            local FrameCount = 0
            local LastUpdate = os.clock()

            Library:Connect(
                RunService.RenderStepped,
                function()
                    FrameCount += 1

                    local Now = os.clock()
                    if Now - LastUpdate < 1 then
                        return
                    end

                    local FPS = FrameCount
                    FrameCount = 0
                    LastUpdate = Now

                    local Color = GetInactiveRGB()
                    Items["FPSText"].Instance.Text = string.format(
                        'FPS: <font color="%s">%d</font>', Color, FPS
                    )
                    Items["PingText"].Instance.Text = string.format(
                        'PING: <font color="%s">%ms</font>', Color, GetPing()
                    )
                end
            )

            function Watermark:Center()
                Items["Watermark"]:ConvertAnchor()
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:SetText(Text)
                Watermark.Name = tostring(Text)
                Items["Title"].Instance.Text = Watermark.Name
            end

            Watermark:Center()
            Self.Watermark = Watermark

            return setmetatable(Watermark, Library)
        end

        Library.KeybindList = function(Self, Params)
            Params = Params or {}

            local KeybindList = {
                Name = Params.Name or Params.name or "Keybind List", Keys = {}, Window = Self,
                Items = {}
            }

            local Items = {}
            do
                Items["KeybindList"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Library.Holder.Instance,
                        AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0.5, 0), BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                )

                Items["Top"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["KeybindList"].Instance,
                        Size = UDim2.new(0, 220, 0, 35), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Tab"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        BottomRightRadius = UDim.new(0, 0), BottomLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["Title"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Top"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = KeybindList.Name, AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 12, 0.5, 0), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Items["Content"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["KeybindList"].Instance,
                        Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 35),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["Content"].Instance,
                        PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Content"].Instance, Padding = UDim.new(0, 0),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["Content"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Content"].Instance,
                        TopRightRadius = UDim.new(0, 0), TopLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["KeybindList"]:MakeDraggable(Items["Top"])
                Items["KeybindList"]:MakeDraggable(Items["Content"])

                KeybindList.Items = Items
            end

            local KeybindTweenInfo = TweenInfo.new(
                0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out
            )
            local RowHeight = 16
            local RowGap = 6
            local RowSlot = RowHeight + RowGap
            local SlideOffset = 14

            function KeybindList:Add(Name, Key)
                local RowItems = {}
                do
                    RowItems["NewKey"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = Items["Content"].Instance,
                            BackgroundTransparency = 1, ClipsDescendants = true,
                            Size = UDim2.new(1, 0, 0, 0), Visible = false, BorderSizePixel = 0
                        }
                    )

                    RowItems["Text"] = Library:Create(
                        "TextLabel",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = RowItems["NewKey"].Instance,
                            TextColor3 = Library.Theme["Text"], Text = Name or "Keybind",
                            TextTransparency = 1, AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, -SlideOffset, 0, RowHeight / 2),
                            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY
                        }
                    ):AddToTheme({TextColor3 = 'Text'})

                    RowItems["Key"] = Library:Create(
                        "TextLabel",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = RowItems["NewKey"].Instance,
                            TextColor3 = Library.Theme["Inactive Text"],
                            Text = string.upper(tostring(Key or "None")), TextTransparency = 1,
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, SlideOffset, 0, RowHeight / 2),
                            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right,
                            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY
                        }
                    ):AddToTheme({TextColor3 = 'Inactive Text'})
                end

                local NewKey = {
                    Name = Name or "Keybind", Key = Key or "None", Active = false, Items = RowItems
                }

                function NewKey:Set(NewName, NewKeyValue)
                    if NewName ~= nil then
                        NewKey.Name = tostring(NewName)
                        RowItems["Text"].Instance.Text = NewKey.Name
                    end

                    if NewKeyValue ~= nil then
                        NewKey.Key = tostring(NewKeyValue)
                        RowItems["Key"].Instance.Text = string.upper(NewKey.Key)
                    end
                end

                function NewKey:SetStatus(Bool)
                    if NewKey.Active == Bool then
                        return
                    end

                    NewKey.Active = Bool

                    if Bool then
                        RowItems["NewKey"].Instance.Visible = true
                        RowItems["NewKey"]:Tween(
                            {Size = UDim2.new(1, 0, 0, RowSlot)}, KeybindTweenInfo
                        )

                        RowItems["Text"]:Tween(
                            {TextTransparency = 0, Position = UDim2.new(0, 0, 0, RowHeight / 2)},
                            KeybindTweenInfo
                        )
                        RowItems["Key"]:Tween(
                            {TextTransparency = 0, Position = UDim2.new(1, 0, 0, RowHeight / 2)},
                            KeybindTweenInfo
                        )
                    else
                        RowItems["NewKey"]:Tween({Size = UDim2.new(1, 0, 0, 0)}, KeybindTweenInfo)
                        RowItems["Text"]:Tween(
                            {TextTransparency = 1, Position = UDim2.new(
                                0, -SlideOffset, 0, RowHeight / 2
                            )}, KeybindTweenInfo
                        )
                        RowItems["Key"]:Tween(
                            {TextTransparency = 1, Position = UDim2.new(
                                1, SlideOffset, 0, RowHeight / 2
                            )}, KeybindTweenInfo
                        )

                        task.delay(
                            Library.Animation.Time,
                            function()
                                if not NewKey.Active and RowItems["NewKey"].Instance.Parent then
                                    RowItems["NewKey"].Instance.Visible = false
                                end
                            end
                        )
                    end
                end

                function NewKey:Remove()
                    local Index = table.find(KeybindList.Keys, NewKey)

                    if Index then
                        table.remove(KeybindList.Keys, Index)
                    end

                    RowItems["NewKey"].Instance:Destroy()
                end

                table.insert(KeybindList.Keys, NewKey)
                return NewKey
            end

            function KeybindList:SetVisibility(Bool)
                Items["KeybindList"].Instance.Visible = Bool
            end

            function KeybindList:SetText(Text)
                KeybindList.Name = tostring(Text)
                Items["Title"].Instance.Text = KeybindList.Name
            end

            function KeybindList:Center()
                Items["KeybindList"]:ConvertAnchor()
            end

            KeybindList:Center()

            Library.KeyList = KeybindList
            Self.KeybindList = KeybindList

            return setmetatable(KeybindList, Library)
        end

        Library.Notification = function(Self, Params)
            Params = Params or {}

            local Name = Params.Name or Params.name or "Notification"
            local Description = Params.Description or Params.description or ""
            local Duration = Params.Duration or Params.duration or 5
            local Color = Params.Color or Params.color or Library.Theme.Accent

            local Notification = {Removing = false, Items = {}}

            local Items = {}
            do
                Items["Notification"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Library.NotifHolder.Instance, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY, ClipsDescendants = true,
                        BackgroundColor3 = Library.Theme["Inline"], ZIndex = 100
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Items["Stroke"] = Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["Notification"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Library:Create("UICorner", {Name = "\0", Parent = Items["Notification"].Instance})

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["Notification"].Instance,
                        PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 25),
                        PaddingRight = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Notification"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Name, BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY, ZIndex = 101
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["Description"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Notification"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"], Text = Description,
                        Position = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY, ZIndex = 101
                    }
                ):AddToTheme({TextColor3 = 'Inactive Text'})

                Items["Liner"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Notification"].Instance,
                        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 15),
                        Size = UDim2.new(1, 0, 0, 5), BorderSizePixel = 0, BackgroundColor3 = Color,
                        ZIndex = 101
                    }
                )

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Liner"].Instance,
                        TopLeftRadius = UDim.new(1, 0), TopRightRadius = UDim.new(1, 0),
                        BottomRightRadius = UDim.new(1, 0), BottomLeftRadius = UDim.new(1, 0)
                    }
                )

                Items["Duration"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Notification"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = string.format("%.1fs", Duration), AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Right, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY, ZIndex = 101
                    }
                ):AddToTheme({TextColor3 = 'Inactive Text'})
            end

            Notification.Items = Items
            table.insert(Library.Notifications, 1, Notification)

            for Index, Notif in Library.Notifications do
                Notif.Items["Notification"].Instance.LayoutOrder = Index
            end

            task.wait()

            local FullSize = Items["Notification"].Instance.AbsoluteSize
            local TweenInfoIn = TweenInfo.new(
                Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style],
                Enum.EasingDirection[Library.Animation.Direction]
            )

            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
            Items["Notification"].Instance.Size = UDim2.new(0, 0, 0, 0)
            Items["Notification"].Instance.BackgroundTransparency = 1
            Items["Stroke"].Instance.Transparency = 1
            Items["Text"].Instance.TextTransparency = 1
            Items["Description"].Instance.TextTransparency = 1
            Items["Duration"].Instance.TextTransparency = 1
            Items["Liner"].Instance.BackgroundTransparency = 1
            Items["Liner"].Instance.Size = UDim2.new(1, 0, 0, 5)

            local Fade = function(Transparency)
                Items["Notification"]:Tween({BackgroundTransparency = Transparency}, TweenInfoIn)
                Items["Stroke"]:Tween({Transparency = Transparency}, TweenInfoIn)
                Items["Text"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Description"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Duration"]:Tween({TextTransparency = Transparency}, TweenInfoIn)
                Items["Liner"]:Tween({BackgroundTransparency = Transparency}, TweenInfoIn)
            end

            Library:Thread(
                function()
                    Fade(0)
                    Items["Notification"]:Tween(
                        {Size = UDim2.new(0, FullSize.X, 0, FullSize.Y)}, TweenInfoIn
                    )

                    Items["Liner"]:Tween(
                        {Size = UDim2.new(0, 0, 0, 5)},
                        TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    )

                    local Start = tick()
                    while tick() - Start < Duration and not Notification.Removing do
                        local Remaining = math.max(0, Duration - (tick() - Start))
                        Items["Duration"].Instance.Text = string.format("%.1fs", Remaining)
                        task.wait(0.05)
                    end

                    if Notification.Removing then
                        return
                    end

                    Notification.Removing = true

                    for Index, Value in Library.Notifications do
                        if Value == Notification then
                            table.remove(Library.Notifications, Index)
                            break
                        end
                    end

                    Fade(1)
                    Items["Notification"]:Tween({Size = UDim2.new(0, 0, 0, 0)}, TweenInfoIn)

                    task.wait(Library.Animation.Time)
                    Items["Notification"].Instance:Destroy()
                end
            )

            return Notification
        end

        Library.ESPPreview = function(Self, Params)
            Params = Params or {}

            local ESPPreview = {
                Name = Params.Name or Params.name or "ESP Preview", Window = Self, Player = nil,
                Spinning = false, Items = {}
            }

            local BottomHeight = 32

            local Items = {}
            do
                Items["ESPPreview"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = ESPPreview.Window.Items.MainFrame.Instance,
                        Position = UDim2.new(1, 10, 0, 0), Size = UDim2.new(0, 200, 0, 260),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {Name = "\0", Parent = Items["ESPPreview"].Instance})

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["ESPPreview"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Items["Top"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["ESPPreview"].Instance,
                        Size = UDim2.new(1, 0, 0, 35), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Tab"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        BottomRightRadius = UDim.new(0, 0), BottomLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Top"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = ESPPreview.Name, AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 12, 0.5, 0), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["ViewportBackground"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["ESPPreview"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 40),
                        Size = UDim2.new(1, 0, 1, -(40 + BottomHeight)), BorderSizePixel = 0
                    }
                )

                Items["Viewport"] = Library:Create(
                    "ViewportFrame",
                    {
                        Name = "\0", Parent = Items["ViewportBackground"].Instance,
                        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0, Ambient = Color3.fromRGB(200, 200, 200),
                        LightColor = Color3.fromRGB(255, 255, 255)
                    }
                )

                Items["Bottom"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["ESPPreview"].Instance,
                        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0),
                        Size = UDim2.new(1, 0, 0, BottomHeight), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Tab"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Bottom"].Instance,
                        TopLeftRadius = UDim.new(0, 0), TopRightRadius = UDim.new(0, 0)
                    }
                )

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["Bottom"].Instance, PaddingTop = UDim.new(0, 7),
                        PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10)
                    }
                )

                ESPPreview.Items = Items
            end

            local ClampPitch = function(PitchValue)
                return math.clamp(PitchValue, math.rad(-80), math.rad(80))
            end

            local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Viewport = Items["Viewport"]

            local ViewportCamera = Instance.new("Camera")
            Viewport.Instance.CurrentCamera = ViewportCamera
            ViewportCamera.CameraType = Enum.CameraType.Track
            ViewportCamera.Parent = Viewport.Instance

            local ViewportModel
            local Zoom = 6
            local MinZoom = 2
            local MaxZoom = 20

            local LastPosition
            local IsRotating = false
            local Sensitivity = 0.7

            local Yaw = math.rad(180)
            local Roll = 0
            local Pitch = 0

            local YawVelocity = 0
            local PitchVelocity = 0

            local Damping = 0.975
            local VelocityPower = 0.01
            local SpinSpeed = math.rad(35)

            local UpdateCamera = function()
                Library:Tween(
                    {CFrame = CFrame.new(Vector3.new(0, 2, Zoom), Vector3.new(0, 1, 0))}, nil,
                    ViewportCamera
                )
            end

            local SetupModel = function(Character)
                if ViewportModel then
                    ViewportModel:Destroy()
                    ViewportModel = nil
                end

                if not Character then
                    return
                end

                Character.Archivable = true
                ViewportModel = Character:Clone()
                Character.Archivable = false

                if ViewportModel.PrimaryPart then
                    ViewportModel.PrimaryPart.Anchored = true
                end

                ViewportModel.Parent = Viewport.Instance

                for _, Value in ViewportModel:GetDescendants() do
                    if Value:IsA("LocalScript") or Value:IsA("Script") then
                        Value:Destroy()
                    elseif Value:IsA("BasePart") then
                        Value.Anchored = true
                        Value.CanCollide = false
                    end
                end

                local HumanoidRootPart = ViewportModel:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    if not ViewportModel.PrimaryPart then
                        ViewportModel.PrimaryPart = HumanoidRootPart
                    end

                    ViewportModel:SetPrimaryPartCFrame(
                        CFrame.Angles(0, math.rad(180), 0) + Vector3.new(0, 2, 0)
                    )
                    ViewportCamera.CFrame = CFrame.new(
                        Vector3.new(0, 2, Zoom), Vector3.new(0, 1, 0)
                    )
                end

                ViewportCamera.CameraSubject = ViewportModel
                ESPPreview.Player = ViewportModel
            end

            if LocalCharacter then
                SetupModel(LocalCharacter)
            end

            Library:Connect(
                LocalPlayer.CharacterAdded,
                function(Character)
                    task.wait(0.25)
                    SetupModel(Character)
                end
            )

            local ViewportInputChanged
            Items["ViewportBackground"]:Connect(
                "InputBegan",
                function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsRotating = true
                        LastPosition = Input.Position

                        if ViewportInputChanged then
                            return
                        end

                        ViewportInputChanged = Input.Changed:Connect(
                            function()
                                if Input.UserInputState == Enum.UserInputState.End then
                                    IsRotating = false
                                    ViewportInputChanged:Disconnect()
                                    ViewportInputChanged = nil
                                end
                            end
                        )
                    end
                end
            )

            Items["ViewportBackground"]:Connect(
                "InputChanged",
                function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        if not LastPosition or not IsRotating then
                            return
                        end

                        local RotationDelta = Input.Position - LastPosition
                        local DeltaX = RotationDelta.X
                        local DeltaY = RotationDelta.Y

                        Yaw = Yaw - math.rad(DeltaX * Sensitivity)
                        Pitch = ClampPitch(Pitch - math.rad(DeltaY * Sensitivity))

                        YawVelocity = -DeltaX * VelocityPower
                        PitchVelocity = -DeltaY * VelocityPower

                        LastPosition = Input.Position
                    end

                    if Input.UserInputType == Enum.UserInputType.MouseWheel then
                        Zoom = math.clamp(Zoom - Input.Position.Z, MinZoom, MaxZoom)
                        UpdateCamera()
                    end
                end
            )

            Library:Connect(
                RunService.RenderStepped,
                function(DeltaTime)
                    if not IsRotating then
                        if ESPPreview.Spinning then
                            Yaw = Yaw + SpinSpeed * DeltaTime
                            YawVelocity = 0
                        else
                            Yaw = Yaw + YawVelocity
                            YawVelocity = YawVelocity * Damping

                            if math.abs(YawVelocity) < 0.0001 then
                                YawVelocity = 0
                            end
                        end

                        Pitch = ClampPitch(Pitch + PitchVelocity)
                        PitchVelocity = PitchVelocity * Damping

                        if math.abs(PitchVelocity) < 0.0001 then
                            PitchVelocity = 0
                        end
                    end

                    if ViewportModel and ViewportModel.PrimaryPart then
                        local Rotation = CFrame.Angles(Pitch, Yaw, Roll)
                        ViewportModel:SetPrimaryPartCFrame(Rotation + Vector3.new(0, 2, 0))
                    end
                end
            )

            UpdateCamera()

            setmetatable(ESPPreview, Library)

            ESPPreview:Toggle(
                {
                    Name = "Spin", Flag = "ESPPreview/Spin", Parent = Items["Bottom"],
                    Default = false,
                    Callback = function(Value)
                        ESPPreview.Spinning = Value
                    end
                }
            )

            function ESPPreview:SetVisibility(Bool)
                Items["ESPPreview"].Instance.Visible = Bool
            end

            function ESPPreview:SetText(Text)
                ESPPreview.Name = tostring(Text)
                Items["Text"].Instance.Text = ESPPreview.Name
            end

            Self.ESPPreview = ESPPreview

            return ESPPreview
        end

        Library.ToggleButton = function(Self, Window, Params)
            Params = Params or {}

            local ButtonSize = Params.Size or 46
            local Margin = 8
            local DragThreshold = 6

            local ToggleButton = {Window = Window, Dragging = false, Items = {}}

            local Camera = workspace.CurrentCamera

            local Items = {}
            do
                Items["Holder"] = Library:Create(
                    "ScreenGui",
                    {
                        Name = "\0", Parent = gethui(), IgnoreGuiInset = true,
                        DisplayOrder = 999999998, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                        ResetOnSpawn = false
                    }
                )

                Library.ToggleHolder = Items["Holder"]

                Items["Button"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", Parent = Items["Holder"].Instance,
                        AnchorPoint = Vector2.new(0, 0),
                        Position = UDim2.fromOffset(Margin + 6, 120),
                        Size = UDim2.fromOffset(ButtonSize, ButtonSize), AutoButtonColor = false,
                        Text = "", BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = "Inline"})

                Library:Create(
                    "UICorner",
                    {Name = "\0", Parent = Items["Button"].Instance, CornerRadius = UDim.new(1, 0)}
                )

                Items["Stroke"] = Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["Button"].Instance, Thickness = 1.5,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Library.Theme["Outline"]
                    }
                ):AddToTheme(
                    {
                        Color = function()
                            return Window.IsOpen and Library.Theme["Accent"] or Library.Theme["Outline"]
                        end
                    }
                )

                Items["Scale"] = Library:Create(
                    "UIScale", {Name = "\0", Parent = Items["Button"].Instance, Scale = 0}
                )

                Items["Logo"] = Library:Create(
                    "ImageLabel",
                    {
                        Name = "\0", Parent = Items["Button"].Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(
                            0, math.floor(ButtonSize * 0.56), 0, math.floor(ButtonSize * 0.56)
                        ), BackgroundTransparency = 1, BorderSizePixel = 0,
                        ScaleType = Enum.ScaleType.Fit, Image = Window.Logo, Active = false,
                        ImageColor3 = Library.Theme["Accent"]
                    }
                ):AddToTheme(
                    {
                        ImageColor3 = function()
                            return Window.IsOpen and Library.Theme["Accent"] or Library.Theme["Inactive Text"]
                        end
                    }
                )

                ToggleButton.Items = Items
            end

            local Button = Items["Button"].Instance
            local Holder = Items["Holder"].Instance

            local GetScreenSize = function()
                local Size = Holder.AbsoluteSize

                if Size.X <= 0 or Size.Y <= 0 then
                    Size = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
                end

                return Size
            end

            local Place = function(X, Y)
                local Screen = GetScreenSize()

                X = math.clamp(X, Margin, math.max(Margin, Screen.X - ButtonSize - Margin))
                Y = math.clamp(Y, Margin, math.max(Margin, Screen.Y - ButtonSize - Margin))

                Button.Position = UDim2.fromOffset(X, Y)
            end

            local Press = function(Down)
                Items["Scale"]:Tween(
                    {Scale = Down and 0.9 or 1},
                    TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                )
            end

            function ToggleButton:Update()
                local Open = Window.IsOpen

                Items["Stroke"]:Tween(
                    {Color = Open and Library.Theme["Accent"] or Library.Theme["Outline"]}
                )
                Items["Logo"]:Tween(
                    {ImageColor3 = Open and Library.Theme["Accent"] or Library.Theme["Inactive Text"]}
                )
            end

            function ToggleButton:SetVisibility(Bool)
                Holder.Enabled = Bool
            end

            function ToggleButton:SetPosition(X, Y)
                Place(X, Y)
            end

            local DragInput
            local DragChanged
            local StartPointer
            local StartPosition
            local Moved = false

            local Finish = function(Cancelled)
                if not DragInput then
                    return
                end

                local WasMoved = Moved

                if DragChanged then
                    DragChanged:Disconnect()
                    DragChanged = nil
                end

                DragInput = nil
                Moved = false
                ToggleButton.Dragging = false

                Press(false)

                if not WasMoved and not Cancelled then
                    Window:SetOpen(not Window.IsOpen)
                end
            end

            Library:Connect(
                Button.InputBegan,
                function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    if DragInput then
                        return
                    end

                    DragInput = Input
                    Moved = false

                    StartPointer = Vector2.new(Input.Position.X, Input.Position.Y)
                    StartPosition = Vector2.new(Button.Position.X.Offset, Button.Position.Y.Offset)

                    Press(true)

                    DragChanged = Input.Changed:Connect(
                        function()
                            if Input.UserInputState == Enum.UserInputState.End then
                                Finish(false)
                            end
                        end
                    )
                end
            )

            Library:Connect(
                UserInputService.InputChanged,
                function(Input)
                    if not DragInput then
                        return
                    end

                    local IsTouch = DragInput.UserInputType == Enum.UserInputType.Touch and Input == DragInput
                    local IsMouse = DragInput.UserInputType == Enum.UserInputType.MouseButton1 and Input.UserInputType == Enum.UserInputType.MouseMovement

                    if not IsTouch and not IsMouse then
                        return
                    end

                    local Pointer = Vector2.new(Input.Position.X, Input.Position.Y)

                    if not Moved then
                        if (Pointer - StartPointer).Magnitude < DragThreshold then
                            return
                        end

                        -- re-base at the moment the drag starts so the button never jumps under the finger
                        Moved = true
                        ToggleButton.Dragging = true
                        StartPointer = Pointer
                        StartPosition = Vector2.new(
                            Button.Position.X.Offset, Button.Position.Y.Offset
                        )
                        return
                    end

                    local Delta = Pointer - StartPointer
                    Place(StartPosition.X + Delta.X, StartPosition.Y + Delta.Y)
                end
            )

            Library:Connect(
                UserInputService.InputEnded,
                function(Input)
                    if not DragInput then
                        return
                    end

                    if Input == DragInput or (DragInput.UserInputType == Enum.UserInputType.MouseButton1 and Input.UserInputType == Enum.UserInputType.MouseButton1) then
                        Finish(false)
                    end
                end
            )

            Library:Connect(
                UserInputService.WindowFocusReleased,
                function()
                    Finish(true)
                end
            )

            Library:Connect(
                Holder:GetPropertyChangedSignal("AbsoluteSize"),
                function()
                    Place(Button.Position.X.Offset, Button.Position.Y.Offset)
                end
            )

            Place(Margin + 6, math.floor(GetScreenSize().Y * 0.3))

            Items["Scale"]:Tween(
                {Scale = 1}, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            )

            return ToggleButton
        end

        Library.Window = function(Self, Params)
            Params = Params or {}

            local Window = {
                Name = Params.Name or Params.name or "Window",
                SubName = Params.SubName or Params.subname or "",
                Logo = Params.Logo or Params.logo or "rbxassetid://87164893498141", IsOpen = true,
                Pages = {}, Items = {}
            }

            local Items = {}
            do
                if IsMobile then
                    Library:Create("UIScale", {Parent = Library.Holder.Instance, Scale = 0.65})
                end

                Items["MainFrame"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Library.Holder.Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 560, 0, 560), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(
                    Vector2.new(
                        Items["MainFrame"].Instance.AbsoluteSize.X,
                        Items["MainFrame"].Instance.AbsoluteSize.Y
                    )
                )

                Library:Create("UICorner", {Name = "\0", Parent = Items["MainFrame"].Instance})

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["MainFrame"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Items["Top"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["MainFrame"].Instance,
                        Size = UDim2.new(1, 0, 0, 55), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        BottomRightRadius = UDim.new(0, 0), BottomLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["Logo"] = Library:Create(
                    "ImageLabel",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        ImageColor3 = Library.Theme["Accent"], ScaleType = Enum.ScaleType.Fit,
                        AnchorPoint = Vector2.new(0, 0.5), Image = Window.Logo,
                        BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0.5, 0),
                        Size = UDim2.new(0, 30, 0, 30), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Text"]
                    }
                ):AddToTheme({ImageColor3 = 'Accent'})

                Items["Title"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize + 4,
                        Parent = Items["Top"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Window.Name, Position = UDim2.new(0, 52, 0, 10),
                        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundColor3 = Library.Theme["Text"]
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["SubTitle"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Top"].Instance, TextColor3 = Library.Theme["Inactive Text"],
                        Text = Window.SubName, Position = UDim2.new(0, 52, 0, 30),
                        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundColor3 = Library.Theme["Text"]
                    }
                ):AddToTheme({TextColor3 = 'Inactive Text'})

                Items["Pages"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1,
                        Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 0, 1, 0),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = Library.Theme["Text"]
                    }
                )

                Library:Create(
                    "UIPadding",
                    {Name = "\0", Parent = Items["Pages"].Instance, PaddingRight = UDim.new(0, 10)}
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Pages"].Instance,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Items["Content"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["MainFrame"].Instance,
                        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 56),
                        Size = UDim2.new(1, 0, 1, -56), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Text"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Text'})

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then
                    return
                end

                Debounce = true

                Window.IsOpen = Bool

                if Window.ToggleButton then
                    Window.ToggleButton:Update()
                end

                Items["MainFrame"]:FadeDescendants(
                    Bool,
                    function()
                        Debounce = false
                    end
                )

                for Index, Value in Library.OpenFrames do
                    Value:SetOpen(false)
                end
            end

            function Window:Center()
                Items["MainFrame"]:ConvertAnchor()
            end

            Library:Connect(
                UserInputService.InputBegan,
                function(Input)
                    if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(
                        Input.UserInputType
                    ) == Library.MenuKeybind then
                        if UserInputService:GetFocusedTextBox() then
                            return
                        end

                        Window:SetOpen(not Window.IsOpen)
                    end
                end
            )

            Window:Center()

            Window.ToggleButton = Library:ToggleButton(Window, Params.ToggleButton)

            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or {}

            local Page = {
                Name = Params.Name or Params.name or "Page",
                Icon = Params.Icon or Params.icon or "", Window = Self, ColumnsData = {},
                Items = {}, Active = false, Debounce = false
            }

            local Items = {}
            do
                Items["Inactive"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Page.Window.Items["Pages"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                        BackgroundTransparency = 1, Size = UDim2.new(0, 35, 0, 35),
                        BorderSizePixel = 0, ClipsDescendants = true,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = Library.Theme["Tab"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create("UICorner", {Name = "\0", Parent = Items["Inactive"].Instance})

                Items["Icon"] = Library:Create(
                    "ImageLabel",
                    {
                        Name = "\0", Parent = Items["Inactive"].Instance,
                        ImageColor3 = Library.Theme["Inactive Text"],
                        AnchorPoint = Vector2.new(0, 0.5), Image = Page.Icon,
                        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.5, 1),
                        Size = UDim2.new(0, 20, 0, 20), BorderSizePixel = 0
                    }
                ):AddToTheme({ImageColor3 = 'Inactive Text'})

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize + 2,
                        Parent = Items["Inactive"].Instance, Visible = true, TextTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5), TextColor3 = Library.Theme["Text"],
                        Text = Page.Name, BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 30, 0.5, 0), BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["Inactive"].Instance,
                        PaddingRight = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8)
                    }
                )

                Items["Page"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Library.UnusedHolder.Instance,
                        BackgroundTransparency = 1, Visible = false, Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Page"].Instance,
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = UDim.new(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Items["LeftColumn"] = Library:Create(
                    "ScrollingFrame",
                    {
                        Name = "\0", Parent = Items["Page"].Instance,
                        ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0), Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0,
                        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0)
                    }
                )

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["LeftColumn"].Instance,
                        PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10),
                        PaddingBottom = UDim.new(0, 10)
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["LeftColumn"].Instance,
                        Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Items["RightColumn"] = Library:Create(
                    "ScrollingFrame",
                    {
                        Name = "\0", Parent = Items["Page"].Instance,
                        ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0), Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 0,
                        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0, CanvasSize = UDim2.new(0, 0, 0, 0)
                    }
                )

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["RightColumn"].Instance,
                        PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
                        PaddingBottom = UDim.new(0, 10)
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["RightColumn"].Instance,
                        Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["RightColumn"]

                Page.Items = Items
            end

            local Size
            local TextOnly = Page.Icon == ""
            Page.TextOnly = TextOnly

            if TextOnly then
                Items["Icon"].Instance.Visible = false
                Items["Inactive"].Instance.Size = UDim2.new(0, 0, 0, 35)

                Items["Text"].Instance.Position = UDim2.new(0, 0, 0.5, 0)
                Items["Text"].Instance.TextTransparency = 0
                Items["Text"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
            end

            local GetSize = function()
                local AbsSize = Items["Inactive"].Instance.AbsoluteSize
                Items["Inactive"].Instance.Size = UDim2.new(0, 35, 0, 35)
                task.wait()
                Items["Inactive"].Instance.AutomaticSize = Enum.AutomaticSize.None

                return AbsSize
            end

            Items["Inactive"]:OnHover(
                function()
                    if Page.Active then
                        return
                    end

                    if TextOnly then
                        Items["Text"]:Tween({TextColor3 = Library.Theme.Text})
                    else
                        Items["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
                    end

                    Items["Inactive"]:Tween({BackgroundTransparency = 0})
                end,
                function()
                    if Page.Active then
                        return
                    end

                    if TextOnly then
                        Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                    else
                        Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                    end

                    Items["Inactive"]:Tween({BackgroundTransparency = 1})
                end
            )

            if not TextOnly then
                Size = GetSize()
            end

            function Page:Turn()
                local Old = Page.Window.Current

                if Old == Page then
                    return
                end
                if Page.Debounce then
                    return
                end
                if Old and Old.Debounce then
                    return
                end

                Page.Debounce = true

                if Old then
                    if Old.TextOnly then
                        Old.Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                        Old.Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                        Old.Items["Inactive"]:Tween({BackgroundTransparency = 1})
                    else
                        Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
                        Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

                        Old.Items["Inactive"]:Tween(
                            {BackgroundTransparency = 1, Size = UDim2.new(0, 35, 0, 35)}
                        )
                        Old.Items["Text"]:Tween({TextTransparency = 1})
                    end

                    Old.Items["Page"]:FadeDescendants(
                        false,
                        function()
                            Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance
                        end
                    )

                    Old.Active = false
                end

                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true
                Items["Page"]:FadeDescendants(
                    true,
                    function()
                        Page.Debounce = false
                    end
                )

                if TextOnly then
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme.Accent})
                    Items["Inactive"]:Tween({BackgroundTransparency = 0})
                else
                    Items["Text"].Instance.Visible = true

                    local TextWidth = Items["Text"].Instance.TextBounds.X
                    if TextWidth <= 0 then
                        TextWidth = #(Page.Name) * ((Library.FontSize + 2) * 0.65)
                    end

                    local TabWidth = math.max(35, math.ceil(58 + TextWidth))

                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                    Items["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

                    Items["Inactive"]:Tween(
                        {BackgroundTransparency = 0, Size = UDim2.new(0, TabWidth, 0, 35)}
                    )
                    Items["Text"]:Tween({TextTransparency = 0})
                end

                Page.Window.Current = Page
                Page.Active = true
            end

            Items["Inactive"]:Connect(
                "MouseButton1Down",
                function()
                    Page:Turn()
                end
            )

            if #Page.Window.Pages == 0 then
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or {}

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Side = Params.Side or Params.side or 1, Window = Self.Window, Page = Self,
                Items = {},
            }

            local Items = {}
            do
                Items["Section"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Section.Page.ColumnsData[Section.Side].Instance,
                        Size = UDim2.new(1, 0, 0, 75), BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create("UICorner", {Name = "\0", Parent = Items["Section"].Instance})

                Items["Top"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Section"].Instance,
                        Size = UDim2.new(1, 0, 0, 40), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Tab"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Tab'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Top"].Instance,
                        BottomRightRadius = UDim.new(0, 0), BottomLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize + 2,
                        Parent = Items["Top"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Section.Name, AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 12, 0.5, 0), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Library:Create(
                    "UIPadding",
                    {Name = "\0", Parent = Items["Section"].Instance, PaddingBottom = UDim.new(
                        0, 12
                    )}
                )

                Items["Content"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Section"].Instance, BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 52), Size = UDim2.new(1, -24, 0, 0),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.Y
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Content"].Instance, Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Library:Create(
                    "UIPadding",
                    {Name = "\0", Parent = Items["Section"].Instance, PaddingBottom = UDim.new(
                        0, 12
                    )}
                )

                Section.Items = Items
            end

            return setmetatable(Section, Library)
        end

        Library.Toggle = function(Self, Params)
            Params = Params or {}

            local Toggle = {
                Name = Params.Name or Params.name or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,
                Window = Self.Window, Page = Self.Page, Section = Self, Value = false, Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Toggle"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Parent.Instance, TextColor3 = Color3.fromRGB(0, 0, 0), Text = "",
                        AutoButtonColor = false, BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 18), BorderSizePixel = 0
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Toggle"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"], Text = Toggle.Name,
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Inactive Text'})

                Items["IndicatorOutline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Toggle"].Instance,
                        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                        Size = UDim2.new(0, 18, 0, 18), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["IndicatorOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Indicator"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["IndicatorOutline"].Instance,
                        Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Indicator"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Inline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Indicator"].Instance,
                        BackgroundTransparency = 1, BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Inline"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Check"] = Library:Create(
                    "ImageLabel",
                    {
                        Name = "\0", Parent = Items["Indicator"].Instance,
                        ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5), Image = "rbxassetid://133055463536692",
                        BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12), BorderSizePixel = 0
                    }
                )

                Library:Create(
                    "UIGradient",
                    {
                        Name = "\0", Parent = Items["Inline"].Instance, Rotation = 90,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                        }
                    }
                )

                Items["SubElements"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Toggle"].Instance,
                        AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1,
                        Position = UDim2.new(1, -26, 0, 0), Size = UDim2.new(0, 0, 1, 0),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["SubElements"].Instance,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Toggle.Items = Items
            end

            Items["Toggle"]:OnHover(
                function()
                    if Toggle.Value then
                        return
                    end
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end,
                function()
                    if Toggle.Value then
                        return
                    end
                    Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end
            )

            function Toggle:Set(Bool)
                Toggle.Value = Bool

                if Bool then
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme.Text})

                    Items["Inline"]:Tween(
                        {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}
                    )
                    Items["Check"]:Tween({ImageTransparency = 0})
                else
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})

                    Items["Inline"]:Tween(
                        {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}
                    )
                    Items["Check"]:Tween({ImageTransparency = 1})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0, Window = Toggle.Window,
                    Page = Toggle.Page, Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker(
                    {
                        Parent = Items["SubElements"], Page = Colorpicker.Page,
                        Section = Colorpicker.Section, Flag = Colorpicker.Flag,
                        Default = Colorpicker.Default, Callback = Colorpicker.Callback,
                        Alpha = Colorpicker.Alpha
                    }
                )

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle", Window = Toggle.Window,
                    Page = Toggle.Page, Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind(
                    {
                        Parent = Items["SubElements"], Name = Keybind.Name, Page = Keybind.Page,
                        Section = Keybind.Section, Flag = Keybind.Flag, Default = Keybind.Default,
                        Mode = Keybind.Mode, Callback = Keybind.Callback
                    }
                )

                return NewKeybind
            end

            Items["Toggle"]:Connect(
                "MouseButton1Down",
                function()
                    Toggle:Set(not Toggle.Value)
                end
            )

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or {}

            local Button = {
                Name = Params.Name or Params.name or "Button",
                Callback = Params.Callback or Params.callback or function() end,
                Window = Self.Window, Page = Self.Page, Section = Self, Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Button.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Button"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Parent.Instance, TextColor3 = Color3.fromRGB(0, 0, 0), Text = "",
                        AutoButtonColor = false, Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Button"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["RealButton"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Button"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", AutoButtonColor = false, Position = UDim2.new(0, 1, 0, 1),
                        Size = UDim2.new(1, -2, 1, -2), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["RealButton"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["RealButton"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Button.Name, ZIndex = 2, AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["Accent"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["RealButton"].Instance, BorderSizePixel = 0,
                        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
                        BackgroundColor3 = Library.Theme["Accent"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Accent"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Button.Items = Items
            end

            Items["RealButton"]:OnHover(
                function()
                    Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end,
                function()
                    Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end
            )

            function Button:Press()
                Items["Accent"]:Tween({Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0})
                task.wait(0.18)
                Items["Accent"]:Tween({Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})

                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["RealButton"]:Connect(
                "MouseButton1Down",
                function()
                    Button:Press()
                end
            )

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or {}

            local Slider = {
                Name = Params.Name or Params.name or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0, Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or 1,
                Suffix = Params.Suffix or Params.suffix or "", Window = Self.Window,
                Page = Self.Page, Section = Self, Value = 0, Sliding = false, Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Slider"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Parent.Instance, BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 32), BorderSizePixel = 0
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Slider"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Slider.Name, BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["RealSliderOutline"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Slider"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 8),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["RealSliderOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 2), TopRightRadius = UDim.new(0, 2),
                        BottomRightRadius = UDim.new(0, 2), BottomLeftRadius = UDim.new(0, 2)
                    }
                )

                Items["RealSlider"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["RealSliderOutline"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                        Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["RealSlider"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Accent"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["RealSlider"].Instance,
                        Size = UDim2.new(0.8999999761581421, 0, 1, 0), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Accent"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Accent"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Library:Create(
                    "UIGradient",
                    {
                        Name = "\0", Parent = Items["Accent"].Instance,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                        }
                    }
                )

                Items["DraggerOutline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["RealSlider"].Instance,
                        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Size = UDim2.new(0, 12, 0, 12), BorderSizePixel = 0
                    }
                )

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["DraggerOutline"].Instance,
                        TopLeftRadius = UDim.new(1, 0), TopRightRadius = UDim.new(1, 0),
                        BottomRightRadius = UDim.new(1, 0), BottomLeftRadius = UDim.new(1, 0)
                    }
                )

                Items["DraggerInline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["DraggerOutline"].Instance,
                        Position = UDim2.new(0, 2, 0, 2), Size = UDim2.new(1, -4, 1, -4),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Accent"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Accent'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["DraggerInline"].Instance,
                        TopLeftRadius = UDim.new(1, 0), TopRightRadius = UDim.new(1, 0),
                        BottomRightRadius = UDim.new(1, 0), BottomLeftRadius = UDim.new(1, 0)
                    }
                )

                Library:Create(
                    "UIGradient",
                    {
                        Name = "\0", Parent = Items["DraggerInline"].Instance, Rotation = 90,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                        }
                    }
                )

                Items["Value"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Slider"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"], Text = "%90 gay",
                        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Inactive Text'})

                Slider.Items = Items
            end

            Items["RealSlider"]:OnHover(
                function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end,
                function()
                    Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end
            )

            Slider.DisplayValue = Slider.Default

            function Slider:AnimateValue(NewValue)
                if Slider.ValueTween then
                    Slider.ValueTween:Disconnect()
                end

                local Start = Slider.DisplayValue
                local Goal = NewValue
                local Duration = 0.18

                local Clock = tick()

                Slider.ValueTween = RunService.RenderStepped:Connect(
                    function()
                        local Alpha = math.clamp((tick() - Clock) / Duration, 0, 1)
                        Alpha = TweenService:GetValue(
                            Alpha, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
                        )

                        local Current = Start + (Goal - Start) * Alpha

                        local Rounded = Library:Round(Current, Slider.Decimals)

                        Items["Value"].Instance.Text = string.format("%s%s", Rounded, Slider.Suffix)

                        if Alpha >= 1 then
                            Slider.DisplayValue = Goal
                            Items["Value"].Instance.Text = string.format(
                                "%s%s", Goal, Slider.Suffix
                            )

                            Slider.ValueTween:Disconnect()
                            Slider.ValueTween = nil
                        end
                    end
                )
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(
                    math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals
                )

                Items["Accent"]:Tween(
                    {Size = UDim2.new(
                        (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0
                    )},
                    TweenInfo.new(
                        Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
                    )
                )
                Slider:AnimateValue(Slider.Value)

                local Percent = math.clamp(
                    (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1
                )
                Items["DraggerOutline"]:Tween(
                    {Position = UDim2.new(Percent, (12 / 2) - (Percent * 12), 0.5, 0)},
                    TweenInfo.new(
                        Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out
                    )
                )

                if Slider.Value == Slider.Min then
                    Items["Accent"]:Tween({BackgroundTransparency = 1})
                else
                    Items["Accent"]:Tween({BackgroundTransparency = 0})
                end

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged

            Items["RealSlider"]:Connect(
                "InputBegan",
                function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Slider.Sliding = true

                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)

                        if InputChanged then
                            return
                        end

                        InputChanged = Input.Changed:Connect(
                            function()
                                if Input.UserInputState == Enum.UserInputState.End then
                                    Slider.Sliding = false

                                    InputChanged:Disconnect()
                                    InputChanged = nil
                                end
                            end
                        )
                    end
                end
            )

            Library:Connect(
                UserInputService.InputChanged,
                function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        if Slider.Sliding then
                            local Value = Slider:GetSize(Input)

                            Slider:Set(Value)
                        end
                    end
                end
            )

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return setmetatable(Slider, Library)
        end

        local OptionSearchInfo = TweenInfo.new(
            0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out
        )
        local OptionHeight = 18
        local OptionGap = 6
        local OptionSlot = OptionHeight + OptionGap

        local SetOptionSearchVisible = function(
            OptionData, OptionItems, Visible
        ) -- sorry i have to do this brto 
            if OptionData.SearchVisible == Visible then
                return
            end

            OptionData.SearchVisible = Visible

            local Button = OptionItems["Toggle"]
            local ButtonInstance = Button.Instance

            if Visible then
                ButtonInstance.Visible = true
                Button:Tween({Size = UDim2.new(1, 0, 0, OptionSlot)}, OptionSearchInfo)
                OptionItems["IndicatorOutline"]:Tween(
                    {BackgroundTransparency = 0}, OptionSearchInfo
                )
                OptionItems["Indicator"]:Tween({BackgroundTransparency = 0}, OptionSearchInfo)

                if OptionData.IsSelected then
                    OptionItems["Text"]:Tween(
                        {TextTransparency = 0, TextColor3 = Library.Theme.Text}, OptionSearchInfo
                    )
                    OptionItems["Inline"]:Tween(
                        {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}, OptionSearchInfo
                    )
                    OptionItems["Check"]:Tween({ImageTransparency = 0}, OptionSearchInfo)
                else
                    OptionItems["Text"]:Tween(
                        {TextTransparency = 0, TextColor3 = Library.Theme["Inactive Text"]},
                        OptionSearchInfo
                    )
                    OptionItems["Inline"]:Tween(
                        {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, OptionSearchInfo
                    )
                    OptionItems["Check"]:Tween({ImageTransparency = 1}, OptionSearchInfo)
                end
            else
                Button:Tween({Size = UDim2.new(1, 0, 0, 0)}, OptionSearchInfo)
                OptionItems["Text"]:Tween({TextTransparency = 1}, OptionSearchInfo)
                OptionItems["IndicatorOutline"]:Tween(
                    {BackgroundTransparency = 1}, OptionSearchInfo
                )
                OptionItems["Indicator"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Inline"]:Tween({BackgroundTransparency = 1}, OptionSearchInfo)
                OptionItems["Check"]:Tween({ImageTransparency = 1}, OptionSearchInfo)
            end
        end

        local SearchOptions = function(Options, Query, Holder)
            Query = string.lower(tostring(Query or ""))

            for _, OptionData in Options do
                local Matches = Query == "" or string.find(
                    string.lower(OptionData.Name), Query, 1, true
                ) ~= nil
                OptionData:SetSearchVisible(Matches)
            end

            if Holder then
                Holder:Tween({CanvasPosition = Vector2.new(0, 0)}, OptionSearchInfo)
            end
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or {}

            local Dropdown = {
                Name = Params.Name or Params.name or "Dropdown",
                OptionItems = Params.Items or Params.items or {},
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                MaxSize = Params.MaxSize or Params.maxsize or 120, Window = Self.Window,
                Page = Self.Page, Section = Self, Value = {}, Options = {}, IsOpen = false,
                Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Dropdown"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Parent.Instance, BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 51), BorderSizePixel = 0
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Dropdown"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Dropdown.Name, BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["RealDropdownOutline"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Dropdown"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 30),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["RealDropdownOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["RealDropdown"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["RealDropdownOutline"].Instance,
                        TextColor3 = Color3.fromRGB(0, 0, 0), Text = "", AutoButtonColor = false,
                        Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["RealDropdown"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Value"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["RealDropdown"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"], Text = "...",
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
                        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Inactive Text'})

                Items["Icon"] = Library:Create(
                    "ImageLabel",
                    {
                        Name = "\0", Parent = Items["RealDropdown"].Instance,
                        ImageColor3 = Library.Theme["Inactive Text"],
                        AnchorPoint = Vector2.new(1, 0.5), Image = "rbxassetid://73883327119089",
                        BackgroundTransparency = 1, Position = UDim2.new(1, -8, 0.5, 0),
                        Size = UDim2.new(0, 16, 0, 16), BorderSizePixel = 0
                    }
                ):AddToTheme({ImageColor3 = 'Inactive Text'})

                Items["OptionHolder"] = Library:Create(
                    "TextButton",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Library.Holder.Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                        Text = "", Visible = false, AutoButtonColor = false,
                        Position = UDim2.new(0.719742476940155, 0, 0.1462799459695816, 0),
                        Size = UDim2.new(0, 241, 0, 175), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Inline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["OptionHolder"].Instance,
                        TopLeftRadius = UDim.new(0, 6), TopRightRadius = UDim.new(0, 6),
                        BottomRightRadius = UDim.new(0, 6), BottomLeftRadius = UDim.new(0, 6)
                    }
                )

                Library:Create(
                    "UIStroke",
                    {
                        Name = "\0", Parent = Items["OptionHolder"].Instance,
                        Color = Library.Theme["Outline"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }
                ):AddToTheme({Color = 'Outline'})

                Items["Search"] = Library:Create(
                    "TextBox",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["OptionHolder"].Instance, TextWrapped = true,
                        PlaceholderColor3 = Library.Theme["Inactive Text"],
                        PlaceholderText = "Search..", Size = UDim2.new(1, -20, 0, 20),
                        TextColor3 = Library.Theme["Text"], Text = "", BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10, 0, 7), ClearTextOnFocus = false,
                        BorderSizePixel = 0
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["Holder"] = Library:Create(
                    "ScrollingFrame",
                    {
                        Name = "\0", Parent = Items["OptionHolder"].Instance, Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y, BorderSizePixel = 0,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollBarImageColor3 = Library.Theme["Accent"],
                        MidImage = "rbxassetid://103256802537537", ScrollBarThickness = 2,
                        Size = UDim2.new(1, -20, 1, -45), BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 35),
                        BottomImage = "rbxassetid://103256802537537",
                        TopImage = "rbxassetid://103256802537537"
                    }
                ):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Library:Create(
                    "UIPadding",
                    {Name = "\0", Parent = Items["Holder"].Instance, PaddingBottom = UDim.new(0, 0)}
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Holder"].Instance, Padding = UDim.new(0, 0),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Dropdown.Items = Items
            end

            Items["RealDropdown"]:OnHover(
                function()
                    Items["RealDropdown"]:Tween(
                        {BackgroundColor3 = Library.Theme["Hovered Element"]}
                    )
                end,
                function()
                    Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end
            )

            function Dropdown:Set(Value)
                if Dropdown.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                local OptionItems = {}
                do
                    OptionItems["Toggle"] = Library:Create(
                        "TextButton",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = Items["Holder"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                            Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
                            ClipsDescendants = true, Size = UDim2.new(1, 0, 0, OptionSlot),
                            BorderSizePixel = 0
                        }
                    )

                    OptionItems["Text"] = Library:Create(
                        "TextLabel",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = OptionItems["Toggle"].Instance,
                            TextColor3 = Library.Theme["Text"], Text = Value,
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 28, 0, OptionHeight / 2),
                            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY
                        }
                    ):AddToTheme({TextColor3 = 'Text'})

                    OptionItems["IndicatorOutline"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = OptionItems["Toggle"].Instance,
                            Size = UDim2.new(0, 18, 0, 18), BorderSizePixel = 0,
                            BackgroundColor3 = Library.Theme["Outline"]
                        }
                    ):AddToTheme({BackgroundColor3 = 'Outline'})

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = OptionItems["IndicatorOutline"].Instance,
                            TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                            BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                        }
                    )

                    OptionItems["Indicator"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = OptionItems["IndicatorOutline"].Instance,
                            Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(1, -2, 1, -2),
                            BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Background"]
                        }
                    ):AddToTheme({BackgroundColor3 = 'Background'})

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = OptionItems["Indicator"].Instance,
                            TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                            BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                        }
                    )

                    OptionItems["Inline"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = OptionItems["Indicator"].Instance,
                            BackgroundTransparency = 1, BorderSizePixel = 0,
                            BackgroundColor3 = Library.Theme["Accent"]
                        }
                    ):AddToTheme({BackgroundColor3 = 'Accent'})

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = OptionItems["Inline"].Instance,
                            TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                            BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                        }
                    )

                    OptionItems["Check"] = Library:Create(
                        "ImageLabel",
                        {
                            Name = "\0", Parent = OptionItems["Inline"].Instance,
                            ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = "rbxassetid://133055463536692", BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12),
                            BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UIGradient",
                        {
                            Name = "\0", Parent = OptionItems["Inline"].Instance, Rotation = 90,
                            Color = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                            }
                        }
                    )
                end

                local OptionData = {
                    Button = OptionItems["Toggle"], Text = OptionItems["Text"], Name = Value,
                    IsSelected = false, SearchVisible = true
                }

                OptionItems["Toggle"]:OnHover(
                    function()
                        if OptionData.IsSelected or not Dropdown.IsOpen then
                            return
                        end
                        OptionItems["Indicator"]:Tween(
                            {BackgroundColor3 = Library.Theme["Hovered Element"]}
                        )
                    end,
                    function()
                        if OptionData.IsSelected or not Dropdown.IsOpen then
                            return
                        end
                        OptionItems["Indicator"]:Tween(
                            {BackgroundColor3 = Library.Theme.Background}
                        )
                    end
                )

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme.Text})
                            OptionItems["Inline"]:Tween(
                                {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}
                            )
                            OptionItems["Check"]:Tween({ImageTransparency = 0})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme.Text
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 1, 0)
                        end
                    else
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            OptionItems["Inline"]:Tween(
                                {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}
                            )
                            OptionItems["Check"]:Tween({ImageTransparency = 1})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 0, 0)
                        end
                    end
                end

                function OptionData:SetSearchVisible(Visible)
                    SetOptionSearchVisible(OptionData, OptionItems, Visible)
                end

                function OptionData:Set()
                    if not Dropdown.IsOpen then
                        return
                    end

                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(
                            Dropdown.Value, ", "
                        ) or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect(
                    "MouseButton1Down",
                    function()
                        OptionData:Set()
                    end
                )

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Search(Query)
                SearchOptions(Dropdown.Options, Query, Items["Holder"])

                if not Dropdown.IsOpen then
                    return
                end

                Query = string.lower(tostring(Query or ""))
                local Width = Items["RealDropdown"].Instance.AbsoluteSize.X
                local TargetHeight = Dropdown.MaxSize

                if Query ~= "" then
                    local VisibleCount = 0

                    for _, OptionData in Dropdown.Options do
                        if OptionData.SearchVisible then
                            VisibleCount += 1
                        end
                    end

                    local HeaderHeight = 40
                    TargetHeight = math.clamp(
                        HeaderHeight + VisibleCount * OptionSlot, HeaderHeight, Dropdown.MaxSize
                    )
                end

                Items["Holder"]:Tween(
                    {ScrollBarImageTransparency = Query ~= "" and 1 or 0}, OptionSearchInfo
                )
                Items["OptionHolder"]:Tween(
                    {Size = UDim2.new(0, Width, 0, TargetHeight)}, OptionSearchInfo
                )
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do
                    Dropdown:Add(Value)
                end

                Dropdown:Search(Items["Search"].Instance.Text)
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            function Dropdown:SetOpen(Bool)
                if Debounce then
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true

                if Dropdown.IsOpen then
                    OptionHolder.Position = UDim2.new(
                        0, RealDropdown.AbsolutePosition.X, 0,
                        RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + GuiInset
                    )
                    OptionHolder.Size = UDim2.new(
                        0, RealDropdown.AbsoluteSize.X, 0, Dropdown.MaxSize
                    )

                    OptionHolder.Parent = Library.Holder.Instance
                    Items["OptionHolder"]:Tween(
                        {
                            Position = UDim2.new(
                                0, RealDropdown.AbsolutePosition.X, 0,
                                RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y + 10 + GuiInset
                            )
                        }
                    )

                    Items["OptionHolder"]:FadeDescendants(
                        true,
                        function()
                            Debounce = false
                        end
                    )

                    Library:RegisterOpenFrame(
                        Dropdown,
                        {
                            HoverItems = {Items["OptionHolder"], Items["RealDropdown"]},
                            AnchorInstance = RealDropdown, PopupInstance = OptionHolder,
                        }
                    )
                else
                    Items["OptionHolder"]:Tween(
                        {
                            Position = UDim2.new(
                                0, RealDropdown.AbsolutePosition.X, 0,
                                RealDropdown.AbsolutePosition.Y + RealDropdown.AbsoluteSize.Y - 10 + GuiInset
                            )
                        }
                    )
                    Items["OptionHolder"]:FadeDescendants(
                        false,
                        function()
                            OptionHolder.Parent = Library.UnusedHolder.Instance
                            Items["Search"].Instance.Text = ""
                            Dropdown:Search("")
                            Debounce = false
                        end
                    )

                    Library:CloseOpenFrameChildren(Dropdown)
                    Library:UnregisterOpenFrame(Dropdown)
                end

                local Descendants = OptionHolder:GetDescendants()
                table.insert(Descendants, OptionHolder)

                for Index, Value in Descendants do
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if not Params.Parent then
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder or 1
                    else
                        Value.ZIndex = Dropdown.IsOpen and Library.ZIndexOrder.OptionHolder + 3 or 1
                    end
                end
            end

            Items["OptionHolder"]:VisibleCheck()

            Library:RegisterOpenFrameTrigger(Items["RealDropdown"])

            Library:Connect(
                Items["Search"].Instance:GetPropertyChangedSignal("Text"),
                function()
                    Dropdown:Search(Items["Search"].Instance.Text)
                end
            )

            Items["RealDropdown"]:Connect(
                "MouseButton1Down",
                function()
                    Dropdown:SetOpen(not Dropdown.IsOpen)
                end
            )

            for Index, Value in Dropdown.OptionItems do
                Dropdown:Add(Value)
            end

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = Params or {}

            local Label = {
                Name = Params.Name or Params.name or "Label", Window = Self.Window,
                Page = Self.Page, Section = Self, Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Label"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Parent.Instance, BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 16), BorderSizePixel = 0
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Label"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Label.Name, AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 0, 0.5, 0), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["SubElements"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Label"].Instance,
                        AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1,
                        Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 0, 1, 0),
                        BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X
                    }
                )

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["SubElements"].Instance,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                Label.Items = Items
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or {}

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or 0, Window = Label.Window, Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker(
                    {
                        Parent = Items["SubElements"], Page = Colorpicker.Page,
                        Section = Colorpicker.Section, Flag = Colorpicker.Flag,
                        Default = Colorpicker.Default, Callback = Colorpicker.Callback,
                        Alpha = Colorpicker.Alpha
                    }
                )

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or {}

                local Keybind = {
                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle", Window = Label.Window,
                    Page = Label.Page, Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind(
                    {
                        Parent = Items["SubElements"], Name = Keybind.Name, Page = Keybind.Page,
                        Section = Keybind.Section, Flag = Keybind.Flag, Default = Keybind.Default,
                        Mode = Keybind.Mode, Callback = Keybind.Callback
                    }
                )

                return NewKeybind
            end

            Label:SetText(Label.Name)

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or {}

            local Textbox = {
                Name = Params.Name or Params.name or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Numeric = Params.Numeric or Params.numeric or false, Window = Self.Window,
                Page = Self.Page, Section = Self, Value = "", Items = {},
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["Textbox"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Parent.Instance, BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 51), BorderSizePixel = 0
                    }
                )

                Items["Text"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Textbox"].Instance, TextColor3 = Library.Theme["Text"],
                        Text = Textbox.Name, BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["BackgroundOutline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Textbox"].Instance,
                        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0),
                        Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["BackgroundOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Background"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["BackgroundOutline"].Instance,
                        Size = UDim2.new(1, -2, 1, -2), ClipsDescendants = true,
                        Position = UDim2.new(0, 1, 0, 1), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Background"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Input"] = Library:Create(
                    "TextBox",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["Background"].Instance, AnchorPoint = Vector2.new(0, 0.5),
                        PlaceholderColor3 = Library.Theme["Inactive Text"],
                        PlaceholderText = Textbox.Placeholder, Size = UDim2.new(1, -16, 0, 0),
                        TextColor3 = Library.Theme["Text"], Text = "",
                        Position = UDim2.new(0, 8, 0.5, 0), CursorPosition = -1,
                        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                        BorderSizePixel = 0, ClearTextOnFocus = false,
                        AutomaticSize = Enum.AutomaticSize.Y
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Textbox.Items = Items
            end

            Items["Background"]:OnHover(
                function()
                    Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                end,
                function()
                    Items["Background"]:Tween({BackgroundColor3 = Library.Theme.Background})
                end
            )

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            Items["Input"]:Connect(
                "Focused",
                function()
                    Items["BackgroundOutline"]:ChangeItemTheme(
                        {BackgroundColor3 = Library.Theme["Accent"]}
                    )
                    Items["BackgroundOutline"]:Tween({BackgroundColor3 = Library.Theme["Accent"]})
                end
            )

            Items["Input"]:Connect(
                "FocusLost",
                function(PressedEnterQuestionMark)
                    if Textbox.Finished then
                        if PressedEnterQuestionMark then
                            Textbox:Set(Items["Input"].Instance.Text)
                        end
                    end

                    Items["BackgroundOutline"]:ChangeItemTheme(
                        {BackgroundColor3 = Library.Theme["Outline"]}
                    )
                    Items["BackgroundOutline"]:Tween({BackgroundColor3 = Library.Theme["Outline"]})
                end
            )

            if not Textbox.Finished then
                Library:Connect(
                    Items["Input"].Instance:GetPropertyChangedSignal("Text"),
                    function()
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                )
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return setmetatable(Textbox, Library)
        end

        Library.Divider = function(Self)
            local Items = {}
            do
                Items["Divider"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Self.Items.Content.Instance,
                        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 7),
                        BorderSizePixel = 0
                    }
                )

                Items["RealDivider"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["Divider"].Instance,
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.new(1, 0, 0, 3), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["RealDivider"].Instance,
                        TopLeftRadius = UDim.new(1, 0), TopRightRadius = UDim.new(1, 0),
                        BottomRightRadius = UDim.new(1, 0), BottomLeftRadius = UDim.new(1, 0)
                    }
                )
            end

            return Items
        end

        Library.ListBox = function(Self, Params)
            Params = Params or {}

            local List = {
                Name = Params.Name or Params.name or "ListBox",
                OptionItems = Params.Items or Params.items or {},
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                Height = Params.Height or Params.height or Params.MaxSize or Params.maxsize or 225,
                Window = Self.Window, Page = Self.Page, Section = Self, Value = {}, Options = {},
                Items = {}
            }

            local Parent

            if Params.Parent then
                Parent = Params.Parent
            else
                Parent = List.Section.Items["Content"]
            end

            local Items = {}
            do
                Items["List"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Parent.Instance, BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, List.Height), BorderSizePixel = 0
                    }
                )

                Items["TopOutline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["List"].Instance, Size = UDim2.new(0, 0, 0, 30),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["TopOutline"].Instance,
                        PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1),
                        PaddingRight = UDim.new(0, 1), PaddingLeft = UDim.new(0, 1)
                    }
                )

                Items["TopInline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["TopOutline"].Instance,
                        Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UIPadding",
                    {
                        Name = "\0", Parent = Items["TopInline"].Instance,
                        PaddingRight = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8)
                    }
                )

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["TopInline"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 0), BottomLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["Icon"] = Library:Create(
                    "ImageLabel",
                    {
                        Name = "\0", Parent = Items["TopInline"].Instance,
                        ImageColor3 = Library.Theme["Inactive Text"],
                        AnchorPoint = Vector2.new(0, 0.5), Image = "rbxassetid://132783180980031",
                        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.5, 2),
                        Size = UDim2.new(0, 16, 0, 16), BorderSizePixel = 0
                    }
                ):AddToTheme({ImageColor3 = 'Inactive Text'})

                Items["Input"] = Library:Create(
                    "TextBox",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Items["TopInline"].Instance, AnchorPoint = Vector2.new(0, 0.5),
                        PlaceholderColor3 = Library.Theme["Inactive Text"],
                        PlaceholderText = "Search...", TextColor3 = Library.Theme["Text"],
                        Text = "", Position = UDim2.new(0, 24, 0.5, 1),
                        Size = UDim2.new(0, 0, 0, 16), BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                        ClearTextOnFocus = false, ClipsDescendants = true
                    }
                ):AddToTheme({TextColor3 = 'Text'})

                Items["SearchMeasure"] = Library:Create(
                    "TextLabel",
                    {
                        Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                        Parent = Library.UnusedHolder.Instance, TextColor3 = Library.Theme["Text"],
                        Text = "Search...", BackgroundTransparency = 1, BorderSizePixel = 0,
                        Visible = false, AutomaticSize = Enum.AutomaticSize.XY
                    }
                )

                Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["TopInline"].Instance,
                        Size = UDim2.new(1, 16, 0, 2), Position = UDim2.new(0, -8, 1, 0),
                        ZIndex = 2, BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["TopOutline"].Instance,
                        TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 0), BottomLeftRadius = UDim.new(0, 0)
                    }
                )

                Items["InlineOutline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["List"].Instance,
                        Position = UDim2.new(0, 0, 0, 30), Size = UDim2.new(1, 0, 1, -30),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Outline"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["Inline"] = Library:Create(
                    "Frame",
                    {
                        Name = "\0", Parent = Items["InlineOutline"].Instance,
                        Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(1, -2, 1, -2),
                        BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Background"]
                    }
                ):AddToTheme({BackgroundColor3 = 'Background'})

                Library:Create(
                    "UICorner",
                    {
                        Name = "\0", Parent = Items["Inline"].Instance,
                        TopLeftRadius = UDim.new(0, 0), TopRightRadius = UDim.new(0, 4),
                        BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                    }
                )

                Items["Holder"] = Library:Create(
                    "ScrollingFrame",
                    {
                        Name = "\0", Parent = Items["Inline"].Instance, Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y, BorderSizePixel = 0,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollBarImageColor3 = Library.Theme["Accent"],
                        MidImage = "rbxassetid://103256802537537", ScrollBarThickness = 2,
                        Size = UDim2.new(1, -16, 1, -16), BackgroundTransparency = 1,
                        Position = UDim2.new(0, 8, 0, 8),
                        BottomImage = "rbxassetid://103256802537537",
                        TopImage = "rbxassetid://103256802537537"
                    }
                ):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Library:Create(
                    "UIListLayout",
                    {
                        Name = "\0", Parent = Items["Holder"].Instance, Padding = UDim.new(0, 0),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }
                )

                List.Items = Items
            end

            local SearchBarExtra = 48

            local UpdateSearchBarSize = function(Instant)
                local Input = Items["Input"].Instance
                local Measure = Items["SearchMeasure"].Instance
                local Text = Input.Text ~= "" and Input.Text or Input.PlaceholderText

                Measure.Text = Text

                local TextWidth = math.ceil(math.max(Measure.TextBounds.X, Measure.AbsoluteSize.X))
                local TargetWidth = TextWidth + SearchBarExtra
                local MaxWidth = Items["List"].Instance.AbsoluteSize.X

                if MaxWidth > 0 then
                    TargetWidth = math.min(TargetWidth, MaxWidth)
                end

                local InputWidth = math.max(TextWidth + 6, 0)

                if Instant then
                    Items["TopOutline"].Instance.Size = UDim2.new(0, TargetWidth, 0, 30)
                    Input.Size = UDim2.new(0, InputWidth, 0, 16)
                else
                    Items["TopOutline"]:Tween(
                        {Size = UDim2.new(0, TargetWidth, 0, 30)}, OptionSearchInfo
                    )
                    Items["Input"]:Tween({Size = UDim2.new(0, InputWidth, 0, 16)}, OptionSearchInfo)
                end
            end

            UpdateSearchBarSize(true)

            function List:Set(Value)
                if List.Multi then
                    if type(Value) ~= "table" then
                        return
                    end

                    List.Value = Value

                    for Index, Value in Value do
                        local OptionData = List.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true
                        OptionData:ToggleState("Active")
                    end

                    Flags[List.Flag] = Value
                else
                    if not List.Options[Value] then
                        return
                    end

                    local OptionData = List.Options[Value]

                    List.Value = Value

                    for Index, Value in List.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[List.Flag] = Value
                end

                Library:SafeCall(List.Callback, List.Value)
            end

            function List:Add(Value)
                local OptionItems = {}
                do
                    OptionItems["Toggle"] = Library:Create(
                        "TextButton",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = Items["Holder"].Instance, TextColor3 = Color3.fromRGB(0, 0, 0),
                            Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
                            ClipsDescendants = true, Size = UDim2.new(1, 0, 0, OptionSlot),
                            BorderSizePixel = 0
                        }
                    )

                    OptionItems["Text"] = Library:Create(
                        "TextLabel",
                        {
                            Name = "\0", FontFace = Library.Font, TextSize = Library.FontSize,
                            Parent = OptionItems["Toggle"].Instance,
                            TextColor3 = Library.Theme["Text"], Text = Value,
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 28, 0, OptionHeight / 2),
                            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                            BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.XY
                        }
                    ):AddToTheme({TextColor3 = 'Text'})

                    OptionItems["IndicatorOutline"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = OptionItems["Toggle"].Instance,
                            Size = UDim2.new(0, 18, 0, 18), BorderSizePixel = 0,
                            BackgroundColor3 = Library.Theme["Outline"]
                        }
                    ):AddToTheme({BackgroundColor3 = 'Outline'})

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = OptionItems["IndicatorOutline"].Instance,
                            TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                            BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                        }
                    )

                    OptionItems["Indicator"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = OptionItems["IndicatorOutline"].Instance,
                            Position = UDim2.new(0, 1, 0, 1), Size = UDim2.new(1, -2, 1, -2),
                            BorderSizePixel = 0, BackgroundColor3 = Library.Theme["Background"]
                        }
                    ):AddToTheme({BackgroundColor3 = 'Background'})

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = OptionItems["Indicator"].Instance,
                            TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                            BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                        }
                    )

                    OptionItems["Inline"] = Library:Create(
                        "Frame",
                        {
                            Name = "\0", Parent = OptionItems["Indicator"].Instance,
                            BackgroundTransparency = 1, BorderSizePixel = 0,
                            BackgroundColor3 = Library.Theme["Accent"]
                        }
                    ):AddToTheme({BackgroundColor3 = 'Accent'})

                    Library:Create(
                        "UICorner",
                        {
                            Name = "\0", Parent = OptionItems["Inline"].Instance,
                            TopLeftRadius = UDim.new(0, 4), TopRightRadius = UDim.new(0, 4),
                            BottomRightRadius = UDim.new(0, 4), BottomLeftRadius = UDim.new(0, 4)
                        }
                    )

                    OptionItems["Check"] = Library:Create(
                        "ImageLabel",
                        {
                            Name = "\0", Parent = OptionItems["Inline"].Instance,
                            ImageColor3 = Color3.fromRGB(0, 0, 0), ImageTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Image = "rbxassetid://133055463536692", BackgroundTransparency = 1,
                            Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12),
                            BorderSizePixel = 0
                        }
                    )

                    Library:Create(
                        "UIGradient",
                        {
                            Name = "\0", Parent = OptionItems["Inline"].Instance, Rotation = 90,
                            Color = ColorSequence.new{
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(197, 197, 197))
                            }
                        }
                    )
                end

                local OptionData = {
                    Button = OptionItems["Toggle"], Text = OptionItems["Text"], Name = Value,
                    IsSelected = false, SearchVisible = true
                }

                OptionItems["Toggle"]:OnHover(
                    function()
                        if OptionData.IsSelected then
                            return
                        end
                        OptionItems["Indicator"]:Tween(
                            {BackgroundColor3 = Library.Theme["Hovered Element"]}
                        )
                    end,
                    function()
                        if OptionData.IsSelected then
                            return
                        end
                        OptionItems["Indicator"]:Tween(
                            {BackgroundColor3 = Library.Theme.Background}
                        )
                    end
                )

                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme.Text})
                            OptionItems["Inline"]:Tween(
                                {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0}
                            )
                            OptionItems["Check"]:Tween({ImageTransparency = 0})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme.Text
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 1, 0)
                        end
                    else
                        OptionItems["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})

                        if OptionData.SearchVisible then
                            OptionItems["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                            OptionItems["Inline"]:Tween(
                                {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}
                            )
                            OptionItems["Check"]:Tween({ImageTransparency = 1})
                        else
                            OptionItems["Text"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                            OptionItems["Inline"].Instance.Size = UDim2.new(1, 0, 0, 0)
                        end
                    end
                end

                function OptionData:SetSearchVisible(Visible)
                    SetOptionSearchVisible(OptionData, OptionItems, Visible)
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if List.Multi then
                        local Index = table.find(List.Value, OptionData.Name)

                        if Index then
                            table.remove(List.Value, Index)
                        else
                            table.insert(List.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[List.Flag] = List.Value
                    else
                        if OptionData.IsSelected then
                            List.Value = OptionData.Name
                            Flags[List.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in List.Options do
                                if Value ~= OptionData then
                                    Value.IsSelected = false
                                    Value:ToggleState("Inactive")
                                end
                            end
                        else
                            List.Value = nil
                            Flags[List.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")
                        end
                    end

                    Library:SafeCall(List.Callback, List.Value)
                end

                OptionData.Button:Connect(
                    "MouseButton1Down",
                    function()
                        OptionData:Set()
                    end
                )

                List.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function List:Search(Query)
                SearchOptions(List.Options, Query, Items["Holder"])
            end

            function List:Remove(Option)
                if List.Options[Option] then
                    List.Options[Option].Button.Instance:Destroy()
                    List.Options[Option] = nil
                end
            end

            function List:Refresh(ListItems)
                for Index, Value in List.Options do
                    List:Remove(Value.Name)
                end

                for Index, Value in ListItems do
                    List:Add(Value)
                end

                List:Search(Items["Input"].Instance.Text)
            end

            function List:SetVisibility(Bool)
                Items["List"].Instance.Visible = Bool
            end

            Library:Connect(
                Items["Input"].Instance:GetPropertyChangedSignal("Text"),
                function()
                    UpdateSearchBarSize(false)
                    List:Search(Items["Input"].Instance.Text)
                end
            )

            for Index, Value in List.OptionItems do
                List:Add(Value)
            end

            List:Set(List.Default)

            SetFlags[List.Flag] = function(Value)
                List:Set(Value)
            end

            return setmetatable(List, Library)
        end

        Library.Init = function(Self)
            local SettingsPage = Self:Page({Name = "Settings"})

            local ConfigName
            local ConfigSelected
            local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"

            local Notify = function(Name, Description, Color)
                Library:Notification(
                    {Name = Name, Description = Description or "", Duration = 3, Color = Color or Library.Theme.Accent}
                )
            end

            local SuccessColor = Color3.fromRGB(52, 255, 126)
            local ErrorColor = Color3.fromRGB(255, 80, 80)

            do -- Profiles
                local ConfigsSection = SettingsPage:Section({Name = "Profiles", Side = 1})

                local ConfigsList = ConfigsSection:ListBox(
                    {
                        Flag = "Configs", Items = {}, Multi = false, Height = 200,
                        Callback = function(Value)
                            ConfigSelected = Value
                        end
                    }
                )

                ConfigsSection:Textbox(
                    {
                        Name = "Config name", Flag = "ConfigName", Placeholder = "Config name",
                        Callback = function(Value)
                            ConfigName = Value
                        end
                    }
                )

                ConfigsSection:Button(
                    {
                        Name = "Create",
                        Callback = function()
                            if not ConfigName or ConfigName == "" then
                                Notify("Error", "Config name can't be empty.", ErrorColor)
                                return
                            end

                            if isfile(ConfigsFolder .. ConfigName .. ".json") then
                                Notify(
                                    "Error", 'Config "' .. ConfigName .. '" already exists.',
                                    ErrorColor
                                )
                                return
                            end

                            writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                            Library:GetConfigsList(ConfigsList)
                            Notify(
                                "Success", 'Created config "' .. ConfigName .. '".', SuccessColor
                            )
                        end
                    }
                )

                ConfigsSection:Button(
                    {
                        Name = "Load",
                        Callback = function()
                            if not ConfigSelected or ConfigSelected == "" then
                                Notify("Error", "No config selected.", ErrorColor)
                                return
                            end

                            if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                Notify(
                                    "Error", 'Config "' .. ConfigSelected .. '" does not exist.',
                                    ErrorColor
                                )
                                return
                            end

                            local Success, Error = Library:LoadConfig(
                                readfile(ConfigsFolder .. ConfigSelected .. ".json")
                            )

                            if Success then
                                Notify(
                                    "Success", 'Loaded config "' .. ConfigSelected .. '".',
                                    SuccessColor
                                )
                            else
                                Notify(
                                    "Error", "Failed to load config:\n" .. tostring(Error),
                                    ErrorColor
                                )
                            end
                        end
                    }
                )

                ConfigsSection:Button(
                    {
                        Name = "Delete",
                        Callback = function()
                            if not ConfigSelected or ConfigSelected == "" then
                                Notify("Error", "No config selected.", ErrorColor)
                                return
                            end

                            if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                Notify(
                                    "Error", 'Config "' .. ConfigSelected .. '" does not exist.',
                                    ErrorColor
                                )
                                return
                            end

                            delfile(ConfigsFolder .. ConfigSelected .. ".json")
                            ConfigSelected = nil
                            Library:GetConfigsList(ConfigsList)
                            Notify("Success", "Deleted config.", SuccessColor)
                        end
                    }
                )

                ConfigsSection:Button(
                    {
                        Name = "Overwrite",
                        Callback = function()
                            if not ConfigSelected or ConfigSelected == "" then
                                Notify("Error", "No config selected.", ErrorColor)
                                return
                            end

                            if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                Notify(
                                    "Error", 'Config "' .. ConfigSelected .. '" does not exist.',
                                    ErrorColor
                                )
                                return
                            end

                            writefile(
                                ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig()
                            )
                            Notify(
                                "Success", 'Overwrote config "' .. ConfigSelected .. '".',
                                SuccessColor
                            )
                        end
                    }
                )

                Library:GetConfigsList(ConfigsList)
            end

            do -- Autoload
                local AutoloadSection = SettingsPage:Section({Name = "Autoload", Side = 1})

                AutoloadSection:Button(
                    {
                        Name = "Set selected as autoload",
                        Callback = function()
                            if not ConfigSelected or ConfigSelected == "" then
                                Notify("Error", "No config selected.", ErrorColor)
                                return
                            end

                            if not isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                Notify(
                                    "Error", 'Config "' .. ConfigSelected .. '" does not exist.',
                                    ErrorColor
                                )
                                return
                            end

                            writefile(
                                Library.Directory .. "/autoload.json",
                                readfile(ConfigsFolder .. ConfigSelected .. ".json")
                            )
                            Notify(
                                "Success", 'Set "' .. ConfigSelected .. '" as autoload.',
                                SuccessColor
                            )
                        end
                    }
                )

                AutoloadSection:Button(
                    {
                        Name = "Clear autoload",
                        Callback = function()
                            writefile(Library.Directory .. "/autoload.json", "")
                            Notify("Success", "Cleared autoload.", SuccessColor)
                        end
                    }
                )
            end

            do -- Theming
                local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2})
                local ThemeReady = false

                ThemingSection:Dropdown(
                    {
                        Name = "Theme", Flag = "SelectedTheme", Items = Library.ThemeOrder,
                        Default = "Preset",
                        Callback = function(Value)
                            if not Library:ApplyTheme(Value) then
                                return
                            end

                            if ThemeReady then
                                Notify("Theme", 'Applied "' .. Value .. '" theme.', SuccessColor)
                            end
                        end
                    }
                )

                ThemeReady = true
                ThemingSection:Divider()

                for Index, Value in Library.Theme do
                    ThemingSection:Label({Name = Index}):Colorpicker(
                        {
                            Name = Index, Flag = Index .. "Theming", Default = Value,
                            Callback = function(Color)
                                Library.Theme[Index] = Color
                                Library:ChangeTheme(Index, Color)
                            end
                        }
                    )
                end
            end

            do -- Menu
                local MenuSection = SettingsPage:Section({Name = "Menu", Side = 2})

                MenuSection:Label({Name = "Menu Keybind"}):Keybind(
                    {
                        Name = "Menu Keybind", Flag = "MenuKeybind", Default = Enum.KeyCode.X,
                        Mode = "Toggle",
                        Callback = function()
                            if Library.Flags["MenuKeybind"] and Library.Flags["MenuKeybind"].Key then
                                Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                            end
                        end
                    }
                )

                MenuSection:Toggle(
                    {
                        Name = "Toggle Button", Flag = "ToggleButton", Default = true,
                        Callback = function(Value)
                            if Self.ToggleButton then
                                Self.ToggleButton:SetVisibility(Value)
                            end
                        end
                    }
                )

                MenuSection:Divider()

                MenuSection:Button(
                    {
                        Name = "Unload",
                        Callback = function()
                            Notify("Unloading", "Library is being unloaded.", Library.Theme.Accent)
                            task.delay(
                                0.35,
                                function()
                                    Library:Exit()
                                end
                            )
                        end
                    }
                )
            end

            local AutoloadContent = readfile(Library.Directory .. "/autoload.json")

            if AutoloadContent ~= "" then
                local Success, Error = Library:LoadConfig(AutoloadContent)

                if Success then
                    Notify("Autoload", "Loaded autoload config.", SuccessColor)
                else
                    Notify("Autoload", "Failed to load autoload:\n" .. tostring(Error), ErrorColor)
                end
            end
        end
    end
end

local Esp = (function()
    --// ESP Framework made by @publicmain, github.com/pubmain, just added shit
    --// Why not open source?, don't want my script with 5k lines xd
    --//Please credit if using - astral
    local IB_NO_VIRTUALIZE = function(...)
        return ...
    end

    local Players = cloneref(game:GetService("Players"))
    local RunService = cloneref(game:GetService("RunService"))
    local Workspace = cloneref(game:GetService("Workspace"))

    local LocalPlayer = Players.LocalPlayer

    local esp = {
        Classes = {}, Objects = {}, Connections = {}, Gui = Instance.new("ScreenGui", gethui()),
        FontSize = 12, Font, UpdateRate = 0.05,
        Bones = {
            R15 = {
                {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
                {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
                {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
                {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
                {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
                {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
                {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
            },
            R6 = {
                {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Left Arm", "Left Forearm"},
                {"Left Forearm", "Left Hand"}, {"Torso", "Right Arm"},
                {"Right Arm", "Right Forearm"}, {"Right Forearm", "Right Hand"},
                {"Torso", "Left Leg"}, {"Left Leg", "Left Foot"}, {"Torso", "Right Leg"},
                {"Right Leg", "Right Foot"},
            },
        },
        Configuration = {
            Enabled = false, MaxDistance = 5000,
            TeamCheck = {Enabled = false, UseTeamColors = false,},
            Box = {
                Style = "Dynamic", Type = "Full",
                Fill = {
                    Enabled = false, Color = Color3.new(1, 1, 1), Transparency = {0.3, 0.8},
                    Gradient = {
                        Enabled = false, Rotation = -90,
                        Color = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255),},
                    },
                },
                Outline = {
                    Enabled = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1,
                    CornerLength = 12,
                },
                Glow = {
                    Enabled = false, Image = "rbxassetid://90231585382483", Transparency = 0,
                    Color = Color3.new(1, 1, 1),
                    Gradient = {
                        Enabled = false, Rotation = 0,
                        Color = {Color3.new(1, 1, 1), Color3.new(0.8, 0.8, 1),},
                    },
                },
                GetStyle = function(Type, cachedParts, camera)
                    Type = Type or "Dynamic"
                    if not camera or not cachedParts or #cachedParts == 0 then
                        return nil, nil
                    end

                    local min_x, min_y, min_z = math.huge, math.huge, math.huge
                    local max_x, max_y, max_z = -math.huge, -math.huge, -math.huge

                    if Type == "Static" then
                        for _, part in cachedParts do
                            if part.Name == "HumanoidRootPart" and part.Parent then
                                local p = part.Position
                                local s = part.Size
                                local hx = s.X * 0.5
                                local hy = s.Y * 0.5
                                local hz = s.Z * 0.5
                                min_x = p.X - hx;
                                max_x = p.X + hx
                                min_y = p.Y - hy;
                                max_y = p.Y + hy
                                min_z = p.Z - hz;
                                max_z = p.Z + hz
                                break
                            end
                        end
                    else
                        for _, part in cachedParts do
                            if part.Parent then
                                local p = part.Position
                                local s = part.Size
                                local hx = s.X * 0.5
                                local hy = s.Y * 0.5
                                local hz = s.Z * 0.5
                                if p.X - hx < min_x then
                                    min_x = p.X - hx
                                end
                                if p.Y - hy < min_y then
                                    min_y = p.Y - hy
                                end
                                if p.Z - hz < min_z then
                                    min_z = p.Z - hz
                                end
                                if p.X + hx > max_x then
                                    max_x = p.X + hx
                                end
                                if p.Y + hy > max_y then
                                    max_y = p.Y + hy
                                end
                                if p.Z + hz > max_z then
                                    max_z = p.Z + hz
                                end
                            end
                        end
                    end

                    if max_x == -math.huge then
                        return nil, nil
                    end

                    local sc_min_x, sc_min_y = math.huge, math.huge
                    local sc_max_x, sc_max_y = -math.huge, -math.huge
                    local anyOn = false

                    local function proj(x, y, z)
                        local sp, on = camera:WorldToViewportPoint(Vector3.new(x, y, z))
                        if on then
                            anyOn = true
                            if sp.X < sc_min_x then
                                sc_min_x = sp.X
                            end
                            if sp.Y < sc_min_y then
                                sc_min_y = sp.Y
                            end
                            if sp.X > sc_max_x then
                                sc_max_x = sp.X
                            end
                            if sp.Y > sc_max_y then
                                sc_max_y = sp.Y
                            end
                        end
                    end

                    proj(min_x, min_y, min_z);
                    proj(min_x, min_y, max_z)
                    proj(min_x, max_y, min_z);
                    proj(min_x, max_y, max_z)
                    proj(max_x, min_y, min_z);
                    proj(max_x, min_y, max_z)
                    proj(max_x, max_y, min_z);
                    proj(max_x, max_y, max_z)

                    if not anyOn then
                        return nil, nil
                    end
                    return
                        Vector2.new(sc_min_x, sc_min_y),
                        Vector2.new(sc_max_x - sc_min_x, sc_max_y - sc_min_y)
                end,
            },
            HealthBar = {
                Enabled = false, Position = "Left", Animated = false, AnimSpeed = 1,
                Color = {
                    High = Color3.fromRGB(131, 245, 78), Medium = Color3.fromRGB(255, 255, 0),
                    Low = Color3.fromRGB(252, 71, 77),
                },
                GetHealth = function(humanoid)
                    if not humanoid or humanoid.MaxHealth == 0 then
                        return 1
                    end
                    return math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                end,
                Text = {
                    Enabled = false, Color = Color3.fromRGB(255, 255, 255), Transparency = 0,
                    GetText = function(humanoid)
                        if not humanoid then
                            return "0", false
                        end
                        return
                            tostring(math.floor(humanoid.Health)),
                            humanoid.Health ~= humanoid.MaxHealth
                    end,
                },
            }, Name = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Transparency = 0,},
            Distance = {
                Enabled = false, Color = Color3.fromRGB(235, 235, 235), Transparency = 0,
                Format = function(d)
                    return string.format("%dst", d)
                end,
            },
            Tool = {
                Enabled = false, Color = Color3.fromRGB(235, 235, 235), Transparency = 0,
                NoToolText = "none",
            }, Flags = {Enabled = false, Offset = 4,},
        },
    }

    esp.Font = Font.fromEnum(Enum.Font.Code)

    pcall(
        function()
            local Base = Library.Directory .. Library.Folders.Assets .. "/"

            if not isfile(Base .. "esp.ttf") then
                writefile(
                    Base .. "esp.ttf",
                    game:HttpGet(
                        "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf"
                    )
                )
            end

            if not isfile(Base .. "esp.font") then
                writefile(
                    Base .. "esp.font",
                    HttpService:JSONEncode(
                        {
                            name = "SmallestPixel7",
                            faces = {
                                {name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(
                                    Base .. "esp.ttf"
                                )}
                            },
                        }
                    )
                )
            end

            esp.Font = Font.new(getcustomasset(Base .. "esp.font"), Enum.FontWeight.Regular)
        end
    )

    esp.Gui.ClipToDeviceSafeArea = false
    esp.Gui.IgnoreGuiInset = true
    esp.Gui.Name = ""
    esp.Gui.DisplayOrder = -10

    local function makeLabel(parent)
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.new(1, 1, 1)
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.FontFace = esp.Font
        lbl.TextSize = esp.FontSize
        lbl.Size = UDim2.new(0, 100, 0, esp.FontSize + 2)
        lbl.Parent = parent
        return lbl
    end

    local function makeFrame(parent, z, color, transparency)
        local f = Instance.new("Frame", parent)
        f.BackgroundColor3 = color
        f.BackgroundTransparency = transparency or 0
        f.BorderSizePixel = 0
        f.ZIndex = z
        return f
    end

    local function buildCorners(parent, thickness, length, color, shadowColor)
        local t = thickness
        local cl = length
        local out = {}

        local defs = {{ax = 0, ay = 0}, {ax = 1, ay = 0}, {ax = 0, ay = 1}, {ax = 1, ay = 1},}

        for _, d in defs do
            local px = d.ax
            local py = d.ay
            local ox = d.ax == 0 and 0 or -cl
            local oy = d.ay == 0 and 0 or -cl

            local sh = makeFrame(parent, 1, shadowColor)
            sh.AnchorPoint = Vector2.new(d.ax, d.ay)
            sh.Size = UDim2.new(0, cl + 1, 0, t + 2)
            sh.Position = UDim2.new(px, ox - 1, py, oy - 1)

            local sv = makeFrame(parent, 1, shadowColor)
            sv.AnchorPoint = Vector2.new(d.ax, d.ay)
            sv.Size = UDim2.new(0, t + 2, 0, cl + 1)
            sv.Position = UDim2.new(px, ox - 1, py, oy - 1)

            local ch = makeFrame(parent, 2, color)
            ch.AnchorPoint = Vector2.new(d.ax, d.ay)
            ch.Size = UDim2.new(0, cl, 0, t)
            ch.Position = UDim2.new(px, ox, py, oy)

            local cv = makeFrame(parent, 2, color)
            cv.AnchorPoint = Vector2.new(d.ax, d.ay)
            cv.Size = UDim2.new(0, t, 0, cl)
            cv.Position = UDim2.new(px, ox, py, oy)

            table.insert(out, sh)
            table.insert(out, sv)
            table.insert(out, ch)
            table.insert(out, cv)
        end

        return out
    end

    function esp:Register(className, create, update, destroy, setVisible)
        if self.Classes[className] then
            error(`class "{className}" already exists`)
        end
        self.Classes[className] = {
            name = className, create = create, update = update, destroy = destroy,
            set_visible = setVisible,
        }
    end

    function esp:Create(className, instance)
        if self.Objects[instance] then
            return
        end
        local class = self.Classes[className]
        if not class then
            error(`no class "{className}"`)
        end
        local obj = class.create(instance)
        if not obj then
            return
        end
        obj.__class = class
        setmetatable(obj, {__index = class})
        self.Objects[instance] = obj
        return obj
    end

    function esp:ImplementCharacterClass()
        esp:Register(
            "character",
            function(character)
                local cfg = esp.Configuration
                local hbCfg = cfg.HealthBar
                local boxCfg = cfg.Box
                local fillCfg = boxCfg.Fill
                local outCfg = boxCfg.Outline
                local glowCfg = boxCfg.Glow

                local cachedParts = {}
                for _, v in character:GetDescendants() do
                    if v:IsA("BasePart") then
                        cachedParts[#cachedParts + 1] = v
                    end
                end

                local partConns = {}
                partConns[1] = character.DescendantAdded:Connect(
                    function(d)
                        if d:IsA("BasePart") then
                            cachedParts[#cachedParts + 1] = d
                        end
                    end
                )
                partConns[2] = character.DescendantRemoving:Connect(
                    function(d)
                        if d:IsA("BasePart") then
                            for i = #cachedParts, 1, -1 do
                                if cachedParts[i] == d then
                                    table.remove(cachedParts, i)
                                    break
                                end
                            end
                        end
                    end
                )

                local cachedHumanoid = character:FindFirstChildWhichIsA("Humanoid")
                local cachedHead = character:FindFirstChild("Head")

                local holder = Instance.new("Frame", esp.Gui)
                holder.BackgroundTransparency = 1
                holder.ClipsDescendants = false
                holder.ZIndex = 1

                local box = Instance.new("Frame", holder)
                box.Name = ""
                box.Size = UDim2.new(1, 0, 1, 0)
                box.BorderSizePixel = 0
                box.ZIndex = 2

                local glow, glowGradient
                if glowCfg.Enabled then
                    glow = Instance.new("ImageLabel", box)
                    glow.Name = ""
                    glow.Image = glowCfg.Image
                    glow.BackgroundTransparency = 1
                    glow.ImageTransparency = glowCfg.Transparency
                    glow.ImageColor3 = glowCfg.Color
                    glow.ZIndex = 1
                    glow.Size = UDim2.new(1, 45, 1, 45)
                    glow.Position = UDim2.new(0, -23, 0, -23)
                    glow.ScaleType = Enum.ScaleType.Slice
                    glow.SliceCenter = Rect.new(21, 21, 79, 79)

                    if glowCfg.Gradient.Enabled then
                        glowGradient = Instance.new("UIGradient", glow)
                        local seq = {}
                        local colors = glowCfg.Gradient.Color
                        for i, c in ipairs(colors) do
                            table.insert(
                                seq,
                                ColorSequenceKeypoint.new((i - 1) / math.max(#colors - 1, 1), c)
                            )
                        end
                        glowGradient.Color = ColorSequence.new(seq)
                        glowGradient.Rotation = glowCfg.Gradient.Rotation
                    end
                end

                local boxGradient
                if fillCfg.Enabled then
                    boxGradient = Instance.new("UIGradient", box)
                    if fillCfg.Gradient.Enabled then
                        box.BackgroundColor3 = Color3.new(1, 1, 1)
                        local seq = {}
                        local colors = fillCfg.Gradient.Color
                        for i, c in ipairs(colors) do
                            table.insert(
                                seq,
                                ColorSequenceKeypoint.new((i - 1) / math.max(#colors - 1, 1), c)
                            )
                        end
                        boxGradient.Color = ColorSequence.new(seq)
                        boxGradient.Rotation = fillCfg.Gradient.Rotation
                    else
                        box.BackgroundColor3 = fillCfg.Color
                        boxGradient.Color = ColorSequence.new(fillCfg.Color)
                        boxGradient.Rotation = 0
                    end
                    local tr = fillCfg.Transparency
                    if type(tr) == "table" then
                        boxGradient.Transparency = NumberSequence.new(
                            {NumberSequenceKeypoint.new(0, tr[1]), NumberSequenceKeypoint.new(
                                1, tr[2]
                            ),}
                        )
                        box.BackgroundTransparency = 0
                    else
                        box.BackgroundTransparency = tr
                    end
                else
                    box.BackgroundTransparency = 1
                end

                local boxOutline, boxBorder
                if outCfg.Enabled then
                    boxOutline = Instance.new("UIStroke", box)
                    boxOutline.Name = "outline"
                    boxOutline.Thickness = outCfg.Thickness
                    boxOutline.Color = outCfg.Color
                    boxOutline.LineJoinMode = Enum.LineJoinMode.Miter
                    boxOutline.ZIndex = 2

                    boxBorder = Instance.new("UIStroke", box)
                    boxBorder.Name = "border"
                    boxBorder.Color = Color3.new(0, 0, 0)
                    boxBorder.Thickness = 3
                    boxBorder.LineJoinMode = Enum.LineJoinMode.Miter
                    boxBorder.ZIndex = 1
                    boxBorder.BorderOffset = UDim.new(0, -1)
                end

                local cornerFrames = {}
                if outCfg.Enabled then
                    cornerFrames = buildCorners(
                        holder, outCfg.Thickness, outCfg.CornerLength, outCfg.Color,
                        Color3.new(0, 0, 0)
                    )
                    for _, f in cornerFrames do
                        f.Visible = false
                    end
                end

                local hbHolder = Instance.new("Frame", holder)
                hbHolder.Name = "HealthbarHolder"
                hbHolder.BackgroundColor3 = Color3.new(0, 0, 0)
                hbHolder.BorderSizePixel = 0
                hbHolder.ZIndex = 5

                local hbOutline = Instance.new("UIStroke", hbHolder)
                hbOutline.Color = Color3.new(0, 0, 0)
                hbOutline.Thickness = 1
                hbOutline.LineJoinMode = Enum.LineJoinMode.Round

                local hbFill = Instance.new("Frame", hbHolder)
                hbFill.Name = "Fill"
                hbFill.BackgroundColor3 = Color3.new(1, 1, 1)
                hbFill.BorderSizePixel = 0
                hbFill.AnchorPoint = Vector2.new(0, 1)
                hbFill.ZIndex = 6

                local hbGradient = Instance.new("UIGradient", hbFill)
                hbGradient.Rotation = 90
                hbGradient.Color = ColorSequence.new(
                    {
                        ColorSequenceKeypoint.new(0, hbCfg.Color.High),
                        ColorSequenceKeypoint.new(0.5, hbCfg.Color.Medium),
                        ColorSequenceKeypoint.new(1, hbCfg.Color.Low),
                    }
                )

                local hbText = makeLabel(holder)
                hbText.Name = "HealthText"
                hbText.TextColor3 = hbCfg.Text.Color
                hbText.TextTransparency = hbCfg.Text.Transparency
                hbText.TextSize = esp.FontSize
                hbText.Size = UDim2.new(0, 30, 0, esp.FontSize + 2)
                hbText.ZIndex = 8

                local topContainer = Instance.new("Frame", holder)
                topContainer.Name = "TopLabels"
                topContainer.BackgroundTransparency = 1
                topContainer.Size = UDim2.new(1, 0, 0, 0)
                topContainer.Position = UDim2.new(0, 0, 0, -3)
                topContainer.ZIndex = 4
                local topLayout = Instance.new("UIListLayout", topContainer)
                topLayout.FillDirection = Enum.FillDirection.Vertical
                topLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                topLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                topLayout.Padding = UDim.new(0, 0)

                local nameLabel = makeLabel(topContainer)
                nameLabel.Name = "NameLabel"
                nameLabel.TextXAlignment = Enum.TextXAlignment.Center
                nameLabel.TextColor3 = cfg.Name.Color
                nameLabel.TextTransparency = cfg.Name.Transparency
                nameLabel.ZIndex = 4

                local bottomContainer = Instance.new("Frame", holder)
                bottomContainer.Name = "BottomLabels"
                bottomContainer.BackgroundTransparency = 1
                bottomContainer.Size = UDim2.new(1, 0, 0, 0)
                bottomContainer.Position = UDim2.new(0, 0, 1, 3)
                bottomContainer.ZIndex = 4
                local botLayout = Instance.new("UIListLayout", bottomContainer)
                botLayout.FillDirection = Enum.FillDirection.Vertical
                botLayout.VerticalAlignment = Enum.VerticalAlignment.Top
                botLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                botLayout.Padding = UDim.new(0, 0)

                local distLabel = makeLabel(bottomContainer)
                distLabel.Name = "DistLabel"
                distLabel.TextXAlignment = Enum.TextXAlignment.Center
                distLabel.TextColor3 = cfg.Distance.Color
                distLabel.TextTransparency = cfg.Distance.Transparency
                distLabel.ZIndex = 4

                local toolLabel = makeLabel(bottomContainer)
                toolLabel.Name = "ToolLabel"
                toolLabel.TextXAlignment = Enum.TextXAlignment.Center
                toolLabel.TextColor3 = cfg.Tool.Color
                toolLabel.TextTransparency = cfg.Tool.Transparency
                toolLabel.ZIndex = 4

                local flagsContainer = Instance.new("Frame", holder)
                flagsContainer.Name = "Flags"
                flagsContainer.BackgroundTransparency = 1
                flagsContainer.Size = UDim2.new(0, 80, 1, 0)
                flagsContainer.Position = UDim2.new(1, cfg.Flags.Offset, 0, 0)
                flagsContainer.ZIndex = 10
                flagsContainer.ClipsDescendants = false
                local flagLayout = Instance.new("UIListLayout", flagsContainer)
                flagLayout.FillDirection = Enum.FillDirection.Vertical
                flagLayout.VerticalAlignment = Enum.VerticalAlignment.Top
                flagLayout.Padding = UDim.new(0, 1)

                return {
                    model = character, holder = holder, glow = glow, glowGradient = glowGradient,
                    box = box, boxGradient = boxGradient, boxOutline = boxOutline,
                    boxBorder = boxBorder, cornerFrames = cornerFrames, hbHolder = hbHolder,
                    hbFill = hbFill, hbGradient = hbGradient, hbText = hbText,
                    nameLabel = nameLabel, distLabel = distLabel, toolLabel = toolLabel,
                    flagsContainer = flagsContainer, cachedParts = cachedParts,
                    partConns = partConns, cachedHumanoid = cachedHumanoid, cachedHead = cachedHead,
                    lastUpdate = 0, cachedFlags = {}, lastHealth = 1, lastToolName = "",
                }
            end,
            IB_NO_VIRTUALIZE(
                function(character, obj)
                    local cfg = esp.Configuration
                    local boxCfg = cfg.Box
                    local outCfg = boxCfg.Outline
                    local fillCfg = boxCfg.Fill
                    local glowCfg = boxCfg.Glow
                    local hbCfg = cfg.HealthBar
                    local teamCfg = cfg.TeamCheck

                    local now = tick()
                    local dt = now - obj.lastUpdate

                    local fullUpdate = dt >= esp.UpdateRate

                    if not cfg.Enabled then
                        obj.holder.Visible = false
                        return false
                    end

                    local camera = Workspace.CurrentCamera
                    if not camera then
                        obj.holder.Visible = false
                        return false
                    end

                    local humanoid = obj.cachedHumanoid
                    local head = obj.cachedHead

                    if not head or not humanoid or humanoid.Health <= 0 then
                        return true
                    end

                    local player = Players:GetPlayerFromCharacter(obj.model)
                    if player == LocalPlayer and not esp.ShowLocal then
                        obj.holder.Visible = false
                        return false
                    end
                    if teamCfg.Enabled and player and player ~= LocalPlayer then
                        if LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team then
                            obj.holder.Visible = false
                            return false
                        end
                    end

                    local _, onScreen = camera:WorldToViewportPoint(head.Position)
                    if not onScreen then
                        obj.holder.Visible = false
                        return false
                    end

                    if (camera.CFrame.Position - head.Position).Magnitude > cfg.MaxDistance then
                        obj.holder.Visible = false
                        return false
                    end

                    local position, size = boxCfg.GetStyle(boxCfg.Style, obj.cachedParts, camera)
                    if not position or not size then
                        obj.holder.Visible = false
                        return false
                    end

                    obj.holder.Visible = true
                    obj.holder.Position = UDim2.new(0, position.X, 0, position.Y)
                    obj.holder.Size = UDim2.new(0, size.X, 0, size.Y)

                    if fullUpdate then
                        obj.lastUpdate = now

                        local teamColor = nil
                        if teamCfg.UseTeamColors and player and player.Team then
                            teamColor = player.TeamColor.Color
                        end

                        if obj.boxGradient and fillCfg.Enabled and fillCfg.Gradient.Enabled then
                            local c1 = teamColor or fillCfg.Gradient.Color[1]
                            local c2 = fillCfg.Gradient.Color[2]
                            obj.boxGradient.Color = ColorSequence.new(
                                {ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2),}
                            )
                        end

                        if obj.boxOutline then
                            obj.boxOutline.Color = teamColor or outCfg.Color
                        end
                    end

                    if obj.glow then
                        obj.glow.Visible = glowCfg.Enabled
                    end

                    local isCorners = outCfg.Enabled and boxCfg.Type == "Corners"
                    local isFull = outCfg.Enabled and boxCfg.Type == "Full"
                    if obj.boxOutline then
                        obj.boxOutline.Enabled = isFull
                        obj.boxBorder.Enabled = isFull
                    end
                    for _, f in obj.cornerFrames do
                        f.Visible = isCorners
                    end

                    if hbCfg.Enabled then
                        obj.hbHolder.Visible = true

                        local pct = hbCfg.GetHealth(humanoid)
                        local pos = hbCfg.Position
                        local gap = 4

                        if math.abs(pct - obj.lastHealth) > 0.01 or fullUpdate then
                            obj.lastHealth = pct

                            if pos == "Left" then
                                obj.hbHolder.AnchorPoint = Vector2.new(1, 0)
                                obj.hbHolder.Position = UDim2.new(0, -gap, 0, -1)
                                obj.hbHolder.Size = UDim2.new(0, 1, 1, 2)
                                obj.hbFill.AnchorPoint = Vector2.new(0, 1)
                                obj.hbFill.Position = UDim2.new(0, 0, 1, 0)
                                obj.hbFill.Size = UDim2.new(1, 0, pct, 0)
                                obj.hbGradient.Rotation = 90
                            elseif pos == "Right" then
                                obj.hbHolder.AnchorPoint = Vector2.new(0, 0)
                                obj.hbHolder.Position = UDim2.new(1, gap, 0, -1)
                                obj.hbHolder.Size = UDim2.new(0, 1, 1, 2)
                                obj.hbFill.AnchorPoint = Vector2.new(0, 1)
                                obj.hbFill.Position = UDim2.new(0, 0, 1, 0)
                                obj.hbFill.Size = UDim2.new(1, 0, pct, 0)
                                obj.hbGradient.Rotation = 90
                            elseif pos == "Top" then
                                obj.hbHolder.AnchorPoint = Vector2.new(0, 1)
                                obj.hbHolder.Position = UDim2.new(0, 0, 0, -gap)
                                obj.hbHolder.Size = UDim2.new(1, 0, 0, 4)
                                obj.hbFill.AnchorPoint = Vector2.new(0, 0)
                                obj.hbFill.Position = UDim2.new(0, 0, 0, 0)
                                obj.hbFill.Size = UDim2.new(pct, 0, 1, 0)
                                obj.hbGradient.Rotation = 0
                            elseif pos == "Bottom" then
                                obj.hbHolder.AnchorPoint = Vector2.new(0, 0)
                                obj.hbHolder.Position = UDim2.new(0, 0, 1, gap)
                                obj.hbHolder.Size = UDim2.new(1, 0, 0, 4)
                                obj.hbFill.AnchorPoint = Vector2.new(0, 0)
                                obj.hbFill.Position = UDim2.new(0, 0, 0, 0)
                                obj.hbFill.Size = UDim2.new(pct, 0, 1, 0)
                                obj.hbGradient.Rotation = 0
                            end

                            if hbCfg.Animated then
                                local hc1 = hbCfg.Color.High
                                local hc2 = hbCfg.Color.Medium
                                local hc3 = hbCfg.Color.Low
                                local spd = math.max(hbCfg.AnimSpeed or 1, 0.01)
                                local p = (now * spd) % 3

                                local function sampleHealth(s)
                                    s = s % 3
                                    if s < 1 then
                                        return hc1:Lerp(hc2, s)
                                    elseif s < 2 then
                                        return hc2:Lerp(hc3, s - 1)
                                    else
                                        return hc3:Lerp(hc1, s - 2)
                                    end
                                end

                                obj.hbGradient.Color = ColorSequence.new(
                                    {
                                        ColorSequenceKeypoint.new(0, sampleHealth(p)),
                                        ColorSequenceKeypoint.new(0.5, sampleHealth(p + 1)),
                                        ColorSequenceKeypoint.new(1, sampleHealth(p + 2)),
                                    }
                                )
                            end

                            if hbCfg.Text.Enabled then
                                local hpText, showText = hbCfg.Text.GetText(humanoid)
                                obj.hbText.Text = hpText
                                obj.hbText.Visible = showText
                                if showText then
                                    if pos == "Left" then
                                        obj.hbText.AnchorPoint = Vector2.new(1, 0)
                                        obj.hbText.TextXAlignment = Enum.TextXAlignment.Right
                                        obj.hbText.Position = UDim2.new(0, -2, 1 - pct, 0)
                                    elseif pos == "Right" then
                                        obj.hbText.AnchorPoint = Vector2.new(0, 0)
                                        obj.hbText.TextXAlignment = Enum.TextXAlignment.Left
                                        obj.hbText.Position = UDim2.new(1, 2, 1 - pct, 0)
                                    elseif pos == "Top" then
                                        obj.hbText.AnchorPoint = Vector2.new(0, 1)
                                        obj.hbText.TextXAlignment = Enum.TextXAlignment.Left
                                        obj.hbText.Position = UDim2.new(0, 2, 0, -2)
                                    elseif pos == "Bottom" then
                                        obj.hbText.AnchorPoint = Vector2.new(0, 0)
                                        obj.hbText.TextXAlignment = Enum.TextXAlignment.Left
                                        obj.hbText.Position = UDim2.new(0, 2, 1, 2)
                                    end
                                end
                            else
                                obj.hbText.Visible = false
                            end
                        end
                    else
                        obj.hbHolder.Visible = false
                        obj.hbText.Visible = false
                    end

                    if fullUpdate then
                        if cfg.Name.Enabled then
                            obj.nameLabel.Visible = true
                            obj.nameLabel.Text = obj.model.Name
                        else
                            obj.nameLabel.Visible = false
                        end

                        if cfg.Distance.Enabled then
                            obj.distLabel.Visible = true
                            local dist = math.round(
                                (camera.CFrame.Position - head.Position).Magnitude
                            )
                            obj.distLabel.Text = cfg.Distance.Format(dist)
                        else
                            obj.distLabel.Visible = false
                        end

                        if cfg.Tool.Enabled then
                            local tool = obj.model:FindFirstChildWhichIsA("Tool")
                            local toolName = tool and tool.Name or cfg.Tool.NoToolText
                            if toolName ~= obj.lastToolName then
                                obj.lastToolName = toolName
                                obj.toolLabel.Text = toolName
                            end
                            obj.toolLabel.Visible = true
                        else
                            obj.toolLabel.Visible = false
                        end

                        if cfg.Flags.Enabled then
                            obj.flagsContainer.Visible = true
                            obj.flagsContainer.Size = UDim2.new(0, 80, 1, 0)
                            obj.flagsContainer.Position = UDim2.new(1, cfg.Flags.Offset, 0, 0)

                            local flags = {}

                            local state = humanoid:GetState()
                            local stateStr = tostring(state)
                            local stateName = stateStr:match("HumanoidStateType%.(.+)$")
                            if stateName and stateName ~= "Running" and stateName ~= "None" then
                                table.insert(
                                    flags, {text = stateName, color = Color3.fromRGB(255, 220, 80)}
                                )
                            end

                            local rootPart = obj.model:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                local spd = math.round(
                                    Vector3.new(
                                        rootPart.AssemblyLinearVelocity.X, 0,
                                        rootPart.AssemblyLinearVelocity.Z
                                    ).Magnitude
                                )
                                if spd > 24 then
                                    table.insert(
                                        flags,
                                        {text = spd .. " spd", color = Color3.fromRGB(255, 100, 100)}
                                    )
                                end
                            end

                            if player and player:GetAttribute("Cheating") then
                                table.insert(
                                    flags,
                                    {text = "Exploiting", color = Color3.fromRGB(255, 60, 60)}
                                )
                            end

                            for i, flag in ipairs(flags) do
                                local label = obj.cachedFlags[i]
                                if not label then
                                    label = makeLabel(obj.flagsContainer)
                                    label.TextXAlignment = Enum.TextXAlignment.Left
                                    label.TextSize = esp.FontSize
                                    label.Size = UDim2.new(1, 0, 0, esp.FontSize + 2)
                                    label.ZIndex = 10
                                    obj.cachedFlags[i] = label
                                end
                                label.Text = flag.text
                                label.TextColor3 = flag.color
                                label.Visible = true
                            end

                            for i = #flags + 1, #obj.cachedFlags do
                                obj.cachedFlags[i].Visible = false
                            end
                        else
                            obj.flagsContainer.Visible = false
                        end
                    end

                    return false
                end
            ),
            function(obj)
                for _, c in obj.partConns do
                    pcall(
                        function()
                            c:Disconnect()
                        end
                    )
                end
                obj.holder:Destroy()
                table.clear(obj.cachedFlags)
            end,
            function(obj, visible)
                obj.holder.Visible = visible
            end
        )
    end

    function esp:Remove(instance)
        local obj = self.Objects[instance]

        if obj then
            self.Objects[instance] = nil
            pcall(obj.destroy, obj)
        end
    end

    -- rebuilds every object once the user stops touching a setting, new objects are
    -- built and updated before the old ones are destroyed so nothing flickers
    function esp:Refresh()
        self.RefreshToken = (self.RefreshToken or 0) + 1
        local Token = self.RefreshToken

        task.delay(
            0.12,
            function()
                if Token ~= self.RefreshToken or self.Destroyed then
                    return
                end

                local Instances = {}
                for Instance_ in self.Objects do
                    table.insert(Instances, Instance_)
                end

                for _, Character in Instances do
                    local Old = self.Objects[Character]
                    self.Objects[Character] = nil

                    local Ok, New = pcall(self.Create, self, "character", Character)

                    if Ok and New then
                        pcall(New.update, Character, New)
                        if Old then
                            pcall(Old.destroy, Old)
                        end
                    else
                        self.Objects[Character] = Old
                    end
                end
            end
        )
    end

    function esp:ImplementPlayerESP()
        if not esp.Classes.character then
            esp:ImplementCharacterClass()
        end

        local function onPlayerAdded(player)
            local function onCharAdded(char)
                char:WaitForChild("Humanoid", 10)
                char:WaitForChild("Head", 10)

                if char.Parent then
                    esp:Create("character", char)
                end
            end

            if player.Character then
                task.spawn(onCharAdded, player.Character)
            end

            table.insert(esp.Connections, player.CharacterAdded:Connect(onCharAdded))
            table.insert(
                esp.Connections,
                player.CharacterRemoving:Connect(
                    function(char)
                        esp:Remove(char)
                    end
                )
            )
        end

        for _, p in Players:GetPlayers() do
            task.spawn(onPlayerAdded, p)
        end

        table.insert(esp.Connections, Players.PlayerAdded:Connect(onPlayerAdded))
    end

    function esp:Destroy()
        esp.Destroyed = true
        for _, c in esp.Connections do
            c:Disconnect()
        end
        table.clear(esp.Connections)
        for _, o in esp.Objects do
            o:destroy()
        end
        table.clear(esp.Objects)
        table.clear(esp.Classes)
        esp.Gui:Destroy()
    end

    table.insert(
        esp.Connections,
        RunService.Heartbeat:Connect(
            IB_NO_VIRTUALIZE(
                function()
                    for instance, object in esp.Objects do
                        local ok, result = pcall(object.update, instance, object)
                        if not ok then
                            esp.Objects[instance] = nil
                            task.spawn(error, result)
                            pcall(object.destroy, object)
                        elseif result then
                            esp.Objects[instance] = nil
                            object:destroy()
                        end
                    end
                end
            )
        )
    )

    esp.ShowLocal = false
    esp:ImplementPlayerESP()

    return esp
end)()

Library.Esp = Esp

local BuildVisuals = function(Page)
    local Cfg = Esp.Configuration
    local Box = Cfg.Box
    local Fill = Box.Fill
    local Outline = Box.Outline
    local Glow = Box.Glow
    local Health = Cfg.HealthBar

    local Refresh = function()
        Esp:Refresh()
    end

    -- callback that writes Value into Table[Key]; Live = true skips the rebuild
    local Bind = function(Table, Key, Live)
        return function(Value)
            Table[Key] = Value

            if not Live then
                Refresh()
            end
        end
    end

    local BindIndex = function(Table, Index)
        return function(Value)
            Table[Index] = Value
            Refresh()
        end
    end

    local Slider = function(Section, Name, Flag, Min, Max, Default, Step, Suffix, Callback)
        return Section:Slider(
            {
                Name = Name, Flag = Flag, Min = Min, Max = Max, Default = Default, Decimals = Step,
                Suffix = Suffix or "", Callback = Callback
            }
        )
    end

    local Picker = function(Parent, Flag, Default, Callback)
        return Parent:Colorpicker({Flag = Flag, Default = Default, Callback = Callback})
    end

    do -- General
        local Section = Page:Section({Name = "Player ESP", Side = 1})

        Section:Toggle(
            {Name = "Enabled", Flag = "ESP/Enabled", Default = false, Callback = Bind(
                Cfg, "Enabled", true
            )}
        )

        Section:Toggle(
            {
                Name = "Team Check", Flag = "ESP/TeamCheck", Default = false,
                Callback = Bind(Cfg.TeamCheck, "Enabled", true)
            }
        )

        Section:Toggle(
            {
                Name = "Team Colors", Flag = "ESP/TeamColors", Default = false,
                Callback = Bind(Cfg.TeamCheck, "UseTeamColors", true)
            }
        )

        Section:Toggle(
            {
                Name = "Show Local Player", Flag = "ESP/ShowLocal", Default = false,
                Callback = function(Value)
                    Esp.ShowLocal = Value
                end
            }
        )

        Section:Divider()

        Slider(
            Section, "Max Distance", "ESP/MaxDistance", 100, 10000, Cfg.MaxDistance, 50, " st",
            Bind(Cfg, "MaxDistance", true)
        )

        Slider(
            Section, "Update Rate", "ESP/UpdateRate", 0, 200, Esp.UpdateRate * 1000, 5, " ms",
            function(Value)
                Esp.UpdateRate = Value / 1000
            end
        )

        Slider(
            Section, "Font Size", "ESP/FontSize", 8, 20, Esp.FontSize, 1, " px",
            function(Value)
                Esp.FontSize = Value
                Refresh()
            end
        )
    end

    do -- Box
        local Section = Page:Section({Name = "Box", Side = 1})

        Section:Dropdown(
            {
                Name = "Style", Flag = "ESP/BoxStyle", Items = {"Dynamic", "Static"},
                Default = Box.Style, Callback = Bind(Box, "Style", true)
            }
        )

        Section:Dropdown(
            {
                Name = "Type", Flag = "ESP/BoxType", Items = {"Full", "Corners"},
                Default = Box.Type, Callback = Bind(Box, "Type", true)
            }
        )

        local Toggle = Section:Toggle(
            {Name = "Outline", Flag = "ESP/Outline", Default = true, Callback = Bind(
                Outline, "Enabled"
            )}
        )

        Picker(Toggle, "ESP/OutlineColor", Outline.Color, Bind(Outline, "Color"))

        Slider(
            Section, "Thickness", "ESP/OutlineThickness", 1, 5, Outline.Thickness, 1, " px",
            Bind(Outline, "Thickness")
        )
        Slider(
            Section, "Corner Length", "ESP/CornerLength", 4, 40, Outline.CornerLength, 1, " px",
            Bind(Outline, "CornerLength")
        )
    end

    do -- Fill
        local Section = Page:Section({Name = "Fill", Side = 1})

        local Toggle = Section:Toggle(
            {Name = "Fill", Flag = "ESP/Fill", Default = false, Callback = Bind(Fill, "Enabled")}
        )

        Picker(Toggle, "ESP/FillColor", Color3.fromRGB(179, 165, 255), Bind(Fill, "Color"))

        Slider(
            Section, "Top Transparency", "ESP/FillTop", 0, 1, Fill.Transparency[1], 0.01, "",
            BindIndex(Fill.Transparency, 1)
        )
        Slider(
            Section, "Bottom Transparency", "ESP/FillBottom", 0, 1, Fill.Transparency[2], 0.01, "",
            BindIndex(Fill.Transparency, 2)
        )

        Section:Divider()

        Section:Toggle(
            {
                Name = "Gradient", Flag = "ESP/FillGradient", Default = false,
                Callback = Bind(Fill.Gradient, "Enabled")
            }
        )

        Picker(
            Section:Label({Name = "Gradient Start"}), "ESP/FillGradientStart",
            Color3.fromRGB(179, 165, 255), BindIndex(Fill.Gradient.Color, 1)
        )
        Picker(
            Section:Label({Name = "Gradient End"}), "ESP/FillGradientEnd",
            Color3.fromRGB(90, 70, 200), BindIndex(Fill.Gradient.Color, 2)
        )

        Slider(
            Section, "Rotation", "ESP/FillRotation", -180, 180, Fill.Gradient.Rotation, 1, "°",
            Bind(Fill.Gradient, "Rotation")
        )
    end

    do -- Glow
        local Section = Page:Section({Name = "Glow", Side = 2})

        local Toggle = Section:Toggle(
            {Name = "Glow", Flag = "ESP/Glow", Default = false, Callback = Bind(Glow, "Enabled")}
        )

        Picker(Toggle, "ESP/GlowColor", Color3.fromRGB(179, 165, 255), Bind(Glow, "Color"))

        Slider(
            Section, "Transparency", "ESP/GlowTransparency", 0, 1, 0.4, 0.01, "",
            Bind(Glow, "Transparency")
        )

        Section:Divider()

        Section:Toggle(
            {
                Name = "Gradient", Flag = "ESP/GlowGradient", Default = false,
                Callback = Bind(Glow.Gradient, "Enabled")
            }
        )

        Picker(
            Section:Label({Name = "Gradient Start"}), "ESP/GlowGradientStart",
            Color3.fromRGB(179, 165, 255), BindIndex(Glow.Gradient.Color, 1)
        )
        Picker(
            Section:Label({Name = "Gradient End"}), "ESP/GlowGradientEnd",
            Color3.fromRGB(90, 70, 200), BindIndex(Glow.Gradient.Color, 2)
        )

        Slider(
            Section, "Rotation", "ESP/GlowRotation", -180, 180, Glow.Gradient.Rotation, 1, "°",
            Bind(Glow.Gradient, "Rotation")
        )
    end

    do -- Health bar
        local Section = Page:Section({Name = "Health Bar", Side = 2})

        Section:Toggle(
            {Name = "Enabled", Flag = "ESP/Health", Default = true, Callback = Bind(
                Health, "Enabled", true
            )}
        )

        Section:Dropdown(
            {
                Name = "Position", Flag = "ESP/HealthPosition",
                Items = {"Left", "Right", "Top", "Bottom"}, Default = Health.Position,
                Callback = function(Value)
                    Health.Position = Value
                    Esp:Refresh()
                end
            }
        )

        Section:Toggle(
            {
                Name = "Animated", Flag = "ESP/HealthAnimated", Default = false,
                Callback = Bind(Health, "Animated", true)
            }
        )

        Slider(
            Section, "Animation Speed", "ESP/HealthAnimSpeed", 0.1, 5, Health.AnimSpeed, 0.1, "x",
            Bind(Health, "AnimSpeed", true)
        )

        Section:Divider()

        Picker(
            Section:Label({Name = "High"}), "ESP/HealthHigh", Health.Color.High,
            BindIndex(Health.Color, "High")
        )
        Picker(
            Section:Label({Name = "Medium"}), "ESP/HealthMedium", Health.Color.Medium,
            BindIndex(Health.Color, "Medium")
        )
        Picker(
            Section:Label({Name = "Low"}), "ESP/HealthLow", Health.Color.Low,
            BindIndex(Health.Color, "Low")
        )

        Section:Divider()

        local Toggle = Section:Toggle(
            {
                Name = "Health Text", Flag = "ESP/HealthText", Default = false,
                Callback = Bind(Health.Text, "Enabled", true)
            }
        )

        Picker(Toggle, "ESP/HealthTextColor", Health.Text.Color, Bind(Health.Text, "Color"))
    end

    do -- Labels
        local Section = Page:Section({Name = "Labels", Side = 2})

        local Suffix = " st"

        Picker(
            Section:Toggle(
                {Name = "Name", Flag = "ESP/Name", Default = true, Callback = Bind(
                    Cfg.Name, "Enabled", true
                )}
            ), "ESP/NameColor", Cfg.Name.Color, Bind(Cfg.Name, "Color")
        )

        Picker(
            Section:Toggle(
                {
                    Name = "Distance", Flag = "ESP/Distance", Default = true,
                    Callback = Bind(Cfg.Distance, "Enabled", true)
                }
            ), "ESP/DistanceColor", Cfg.Distance.Color, Bind(Cfg.Distance, "Color")
        )

        Picker(
            Section:Toggle(
                {Name = "Tool", Flag = "ESP/Tool", Default = false, Callback = Bind(
                    Cfg.Tool, "Enabled", true
                )}
            ), "ESP/ToolColor", Cfg.Tool.Color, Bind(Cfg.Tool, "Color")
        )

        Section:Toggle(
            {Name = "Flags", Flag = "ESP/Flags", Default = false, Callback = Bind(
                Cfg.Flags, "Enabled", true
            )}
        )

        Section:Divider()

        Slider(
            Section, "Text Transparency", "ESP/TextTransparency", 0, 1, 0, 0.01, "",
            function(Value)
                Cfg.Name.Transparency = Value
                Cfg.Distance.Transparency = Value
                Cfg.Tool.Transparency = Value
                Health.Text.Transparency = Value
                Refresh()
            end
        )

        Slider(
            Section, "Flags Offset", "ESP/FlagsOffset", 0, 30, Cfg.Flags.Offset, 1, " px",
            Bind(Cfg.Flags, "Offset", true)
        )

        Section:Textbox(
            {
                Name = "Distance Suffix", Flag = "ESP/DistanceSuffix", Placeholder = "st",
                Default = "st", Finished = true,
                Callback = function(Value)
                    Suffix = Value ~= "" and (" " .. Value) or ""
                end
            }
        )

        Cfg.Distance.Format = function(Distance)
            return Distance .. Suffix
        end

        Section:Textbox(
            {
                Name = "No Tool Text", Flag = "ESP/NoToolText", Placeholder = "none",
                Default = "none", Finished = true,
                Callback = function(Value)
                    Cfg.Tool.NoToolText = Value ~= "" and Value or "none"
                end
            }
        )
    end
end

-- ─────────────────────────────────────────────────────────────
--  Shared State
-- ─────────────────────────────────────────────────────────────
local char, root, hum
local conns = {}

local function killConn(key)
    if conns[key] then
        pcall(
            function()
                conns[key]:Disconnect()
            end
        )
        conns[key] = nil
    end
end

local function getLocalRoot()
    return root
end

local function applyNoClip(character)
    if not character then
        return
    end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(
                function()
                    part.CanCollide = false;
                    part.Massless = true
                end
            )
        end
    end
end

local function setNetworkOwnerLocal(hrp)
    if not hrp then
        return
    end
    pcall(
        function()
            hrp:SetNetworkOwner(LP)
        end
    )
end

local function fireTool()
    local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
    if tool then
        pcall(
            function()
                tool:Activate()
            end
        )
        task.wait(0.02)
        pcall(
            function()
                tool:Deactivate()
            end
        )
    end
end

local function aimAtTarget(myHrp, targetPos)
    if not myHrp then
        return
    end
    local dir = targetPos - myHrp.Position
    if dir.Magnitude < 0.1 then
        return
    end
    pcall(
        function()
            myHrp.CFrame = CFrame.new(myHrp.Position, myHrp.Position + Vector3.new(dir.X, 0, dir.Z))
        end
    )
end

local function getClosest()
    if not root then
        return nil
    end
    local best, bestD = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP or not p.Character then
            continue
        end
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            continue
        end
        local d = (root.Position - hrp.Position).Magnitude
        if d < bestD then
            bestD = d;
            best = p
        end
    end
    return best
end

local function getTarget(mode)
    if mode == "closest" then
        return getClosest()
    end
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, p)
        end
    end
    if #list == 0 then
        return nil
    end
    if mode == "random" then
        return list[math.random(1, #list)]
    elseif mode == "weakest" then
        table.sort(
            list,
            function(a, b)
                local ha = a.Character:FindFirstChildOfClass("Humanoid")
                local hb = b.Character:FindFirstChildOfClass("Humanoid")
                return (ha and ha.Health or 0) < (hb and hb.Health or 0)
            end
        )
        return list[1]
    elseif mode == "strongest" then
        table.sort(
            list,
            function(a, b)
                local ha = a.Character:FindFirstChildOfClass("Humanoid")
                local hb = b.Character:FindFirstChildOfClass("Humanoid")
                return (ha and ha.Health or 0) > (hb and hb.Health or 0)
            end
        )
        return list[1]
    end
    return list[1]
end

local function predictPos(hrp, lead)
    if not hrp then
        return Vector3.zero
    end
    local vel = hrp.AssemblyLinearVelocity
    local grav = Vector3.new(0, -workspace.Gravity * 0.5, 0)
    return hrp.Position + vel * lead + grav * (lead * lead * 0.5)
end

-- ─────────────────────────────────────────────────────────────
--  Max dodges per frame budget (prevents void freeze)
-- ─────────────────────────────────────────────────────────────
local MAX_DODGES_PER_FRAME = 3
local _dodgeFrame, _dodgeCount = -1, 0
local function tryDodgeFrame()
    local f = math.floor(tick() * 60 + 0.5)
    if f ~= _dodgeFrame then
        _dodgeFrame = f;
        _dodgeCount = 0
    end
    if _dodgeCount >= MAX_DODGES_PER_FRAME then
        return false
    end
    _dodgeCount = _dodgeCount + 1
    return true
end

-- ─────────────────────────────────────────────────────────────
--  VOID CONFIG
-- ─────────────────────────────────────────────────────────────
local VCFG = {
    enabled = false, method = "quantum", speed = 1e15, chaos = 0.98, baseX = 0, baseY = 0,
    baseZ = 0, radius = 1e11, yMin = -1e15, yMax = 1e15, preserveY = false, antiFling = true,
    stopOnDamage = false, safeRadius = 0, orbitTarget = false, orbitSpeed = 90, predictive = false,
    predictLead = 0.15, durationEnabled = false, duration = 10,
    -- void hide specifics
    hideEnabled = false, hideX = 1e6, hideY = 9e25, hideZ = 1e6,
}

local voidElapsed = 0
local voidPos = Vector3.zero
local voidDriftDir = Vector3.new(1, 0, 0)

local function driftDir3D(t)
    local nx, ny, nz, amp, freq = 0, 0, 0, 1, 0.0001
    for _ = 1, 4 do
        nx = nx + math.noise(t * freq, 0, 0) * amp
        ny = ny + math.noise(0, t * freq, 0) * amp
        nz = nz + math.noise(0, 0, t * freq) * amp
        freq = freq * 2.37;
        amp = amp * 0.5
    end
    local sp, cp = t * 0.00073, t * 0.00213
    nx = nx + math.noise(sp + 13.7, 7.3, 0) * 0.3 + math.sin(cp) * math.cos(cp * 1.618) * 0.2
    ny = ny + math.noise(0, sp + 31.1, 17.9) * 0.3 + math.cos(cp * 0.618) * math.sin(cp * 2.718) * 0.2
    nz = nz + math.noise(7.3, 0, sp + 11.5) * 0.3 + math.sin(cp * 1.3) * math.cos(cp * 0.7) * 0.2
    local len = math.sqrt(nx * nx + ny * ny + nz * nz)
    if len < 0.001 then
        return 1, 0, 0
    end
    return nx / len, ny / len, nz / len
end

local function voidSafeFilter(pos)
    if not pos then
        return pos
    end
    local x, y, z = pos.X, pos.Y, pos.Z
    if x ~= x or x == math.huge or x == -math.huge then
        x = VCFG.baseX
    end
    if y ~= y or y == math.huge or y == -math.huge then
        y = 0
    end
    if z ~= z or z == math.huge or z == -math.huge then
        z = VCFG.baseZ
    end
    y = math.clamp(y, VCFG.yMin, VCFG.yMax)
    local r = math.abs(VCFG.radius)
    if r > 0 then
        local dx, dz = x - VCFG.baseX, z - VCFG.baseZ
        local flat = math.sqrt(dx * dx + dz * dz)
        if flat > r and flat > 0 then
            local s = r / flat;
            x = VCFG.baseX + dx * s;
            z = VCFG.baseZ + dz * s
        end
    end
    if VCFG.safeRadius > 0 and root then
        local me = root.Position
        local ddx, ddy, ddz = x - me.X, y - me.Y, z - me.Z
        local dist = math.sqrt(ddx * ddx + ddy * ddy + ddz * ddz)
        if dist < VCFG.safeRadius then
            if dist < 0.01 then
                ddx, ddy, ddz, dist = 1, 0, 0, 1
            end
            local s = VCFG.safeRadius / dist
            x = me.X + ddx * s;
            y = me.Y + ddy * s;
            z = me.Z + ddz * s
        end
    end
    return Vector3.new(x, y, z)
end

local function stepVoid(dt)
    local m = VCFG.method
    -- hide variant: static offset
    if VCFG.hideEnabled then
        return Vector3.new(VCFG.hideX, VCFG.hideY, VCFG.hideZ)
    end
    if m == "drift" then
        local dx, dy, dz = driftDir3D(voidElapsed)
        voidDriftDir = voidDriftDir:Lerp(
            Vector3.new(dx, dy, dz).Unit, math.clamp(VCFG.chaos * dt * 10, 0, 1)
        )
        voidPos = voidPos + voidDriftDir * VCFG.speed * dt
        if voidPos.X > VCFG.baseX + VCFG.radius or voidPos.X < VCFG.baseX - VCFG.radius then
            voidDriftDir = Vector3.new(-voidDriftDir.X, voidDriftDir.Y, voidDriftDir.Z)
        end
        if voidPos.Y > VCFG.yMax or voidPos.Y < VCFG.yMin then
            voidDriftDir = Vector3.new(voidDriftDir.X, -voidDriftDir.Y, voidDriftDir.Z)
        end
        if voidPos.Z > VCFG.baseZ + VCFG.radius or voidPos.Z < VCFG.baseZ - VCFG.radius then
            voidDriftDir = Vector3.new(voidDriftDir.X, voidDriftDir.Y, -voidDriftDir.Z)
        end
        return voidPos
    elseif m == "chaos" then
        voidPos = voidPos + Vector3.new(
            (math.random() - 0.5) * VCFG.speed * dt * 5,
            (math.random() - 0.5) * VCFG.speed * dt * 5, (math.random() - 0.5) * VCFG.speed * dt * 5
        )
        voidPos = Vector3.new(
            math.clamp(voidPos.X, VCFG.baseX - VCFG.radius, VCFG.baseX + VCFG.radius),
            math.clamp(voidPos.Y, VCFG.yMin, VCFG.yMax),
            math.clamp(voidPos.Z, VCFG.baseZ - VCFG.radius, VCFG.baseZ + VCFG.radius)
        )
        return voidPos
    elseif m == "loop" then
        local r = math.min(VCFG.radius * 0.8, 1e9 + (voidElapsed % 100) * 1e7)
        return Vector3.new(
            VCFG.baseX + math.cos(voidElapsed * 2) * r,
            (VCFG.yMin + VCFG.yMax) / 2 + math.sin(voidElapsed * 1.3) * r * 0.2,
            VCFG.baseZ + math.sin(voidElapsed * 2) * r
        )
    elseif m == "spiral" then
        local r = math.min(VCFG.radius * 0.9, (voidElapsed % 50) * 2e9)
        return Vector3.new(
            VCFG.baseX + math.cos(voidElapsed * 3) * r,
            (VCFG.yMin + VCFG.yMax) / 2 + math.sin(voidElapsed * 0.5) * r * 0.3,
            VCFG.baseZ + math.sin(voidElapsed * 3) * r
        )
    elseif m == "orbit target" then
        local t = getClosest()
        if t and t.Character then
            local hrp = t.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local ang = voidElapsed * math.rad(VCFG.orbitSpeed)
                return hrp.Position + Vector3.new(math.cos(ang) * 5, 2, math.sin(ang) * 5)
            end
        end
    end
    -- default: quantum
    return Vector3.new(
        VCFG.baseX + (math.random() * 2 - 1) * VCFG.radius,
        VCFG.yMin + math.random() * (VCFG.yMax - VCFG.yMin),
        VCFG.baseZ + (math.random() * 2 - 1) * VCFG.radius
    )
end

local voidStartTick = 0
local function startVoid()
    killConn("void")
    voidPos = root and root.Position or Vector3.zero
    voidElapsed = 0;
    voidStartTick = tick()
    conns.void = RunService.Heartbeat:Connect(
        function(dt)
            if not VCFG.enabled and not VCFG.hideEnabled then
                killConn("void");
                return
            end
            if not root then
                return
            end
            if VCFG.antiFling then
                pcall(
                    function()
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                    end
                )
            end
            if VCFG.durationEnabled and (tick() - voidStartTick) > VCFG.duration then
                VCFG.enabled = false;
                VCFG.hideEnabled = false;
                killConn("void");
                return
            end
            if VCFG.stopOnDamage and hum and hum.Health < hum.MaxHealth * 0.9 then
                VCFG.enabled = false;
                killConn("void");
                return
            end
            if not tryDodgeFrame() then
                return
            end
            voidElapsed = voidElapsed + dt
            local target = voidSafeFilter(stepVoid(dt))
            if target then
                if VCFG.preserveY and root then
                    target = Vector3.new(target.X, root.Position.Y, target.Z)
                end
                pcall(
                    function()
                        root.CFrame = CFrame.new(target)
                    end
                )
            end
        end
    )
end

local function stopVoid()
    killConn("void");
    VCFG.enabled = false;
    VCFG.hideEnabled = false
end

-- ─────────────────────────────────────────────────────────────
--  ORBIT CONFIG
-- ─────────────────────────────────────────────────────────────
local OCFG = {
    enabled = false, speed = 90, dist = 8, height = 0, lerp = 0.3, mode = "circle", predict = false,
    predStr = 0.2, face = true, lockDist = 999999999, target = "closest", axis = "xz",
    reverse = false, randRad = false, randMin = 5, randMax = 20, yawOff = 0, pitchOff = 0, offX = 0,
    offZ = 0, heightOsc = false, heightOscAmp = 5, heightOscSpeed = 2, autoShoot = false,
    attackRange = 10, shootCooldown = 0.05,
}

local orbitAngle, orbitLocalElapsed, orbitLastShot = 0, 0, 0

local function startOrbit()
    killConn("orbit")
    orbitAngle = 0;
    orbitLocalElapsed = 0;
    orbitLastShot = 0
    if hum then
        pcall(
            function()
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end
        )
    end
    conns.orbit = RunService.Heartbeat:Connect(
        function(dt)
            if not OCFG.enabled then
                killConn("orbit");
                return
            end
            if not root then
                return
            end
            pcall(
                function()
                    root:SetNetworkOwner(LP)
                end
            )
            if LP.Character then
                applyNoClip(LP.Character)
            end
            if hum then
                pcall(
                    function()
                        if hum:GetState() ~= Enum.HumanoidStateType.Physics then
                            hum:ChangeState(Enum.HumanoidStateType.Physics)
                        end
                    end
                )
            end
            local target = getTarget(OCFG.target)
            local targetPos = root.Position;
            local tHrp = nil
            if target and target.Character then
                tHrp = target.Character:FindFirstChild("HumanoidRootPart")
                if tHrp and (root.Position - tHrp.Position).Magnitude <= OCFG.lockDist then
                    targetPos = tHrp.Position
                    if OCFG.predict then
                        targetPos = targetPos + tHrp.AssemblyLinearVelocity * OCFG.predStr
                    end
                end
            end
            local speed = OCFG.reverse and -OCFG.speed or OCFG.speed
            orbitAngle = (orbitAngle + math.rad(speed) * dt) % (2 * math.pi)
            orbitLocalElapsed = orbitLocalElapsed + dt
            local r = OCFG.randRad and math.random(OCFG.randMin, OCFG.randMax) or OCFG.dist
            local h = OCFG.height
            if OCFG.heightOsc then
                h = h + math.sin(orbitLocalElapsed * OCFG.heightOscSpeed * 2 * math.pi) * OCFG.heightOscAmp
            end
            local x, y, z = 0, 0, 0
            local ax = OCFG.axis
            local m = OCFG.mode
            if m == "circle" then
                if ax == "xz" then
                    x = math.cos(orbitAngle) * r;
                    z = math.sin(orbitAngle) * r;
                    y = h
                elseif ax == "xy" then
                    x = math.cos(orbitAngle) * r;
                    y = math.sin(orbitAngle) * r;
                    z = h
                elseif ax == "yz" then
                    y = math.cos(orbitAngle) * r;
                    z = math.sin(orbitAngle) * r;
                    x = h
                end
            elseif m == "figure 8" then
                x = math.sin(orbitAngle) * r;
                z = math.sin(orbitAngle) * math.cos(orbitAngle) * r * 0.7;
                y = h
            elseif m == "ellipse" then
                x = math.cos(orbitAngle) * r;
                z = math.sin(orbitAngle) * r * 0.6;
                y = h
            elseif m == "bounce" then
                x = math.cos(orbitAngle) * r;
                z = math.sin(orbitAngle) * r
                y = h + math.sin(orbitLocalElapsed * 3) * 5
            end
            x = x + OCFG.offX;
            z = z + OCFG.offZ
            local dst = targetPos + Vector3.new(x, y, z)
            local alpha = math.min(1, 1 - (1 - OCFG.lerp) ^ (dt * 60))
            local smooth = root.Position:Lerp(dst, alpha)
            pcall(
                function()
                    if OCFG.face then
                        local cf = CFrame.new(
                            smooth, Vector3.new(targetPos.X, smooth.Y, targetPos.Z)
                        )
                        cf = cf * CFrame.Angles(math.rad(OCFG.pitchOff), math.rad(OCFG.yawOff), 0)
                        root.CFrame = cf
                    else
                        root.CFrame = CFrame.new(smooth)
                    end
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            )
            if OCFG.autoShoot and tHrp and target then
                local now = tick()
                if (root.Position - tHrp.Position).Magnitude < OCFG.attackRange and now - orbitLastShot > OCFG.shootCooldown then
                    orbitLastShot = now
                    aimAtTarget(root, tHrp.Position)
                    fireTool()
                end
            end
        end
    )
end

local function stopOrbit()
    killConn("orbit");
    OCFG.enabled = false
    if hum then
        pcall(
            function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        )
    end
end

-- ─────────────────────────────────────────────────────────────
--  PREDICTION DODGE CONFIG
-- ─────────────────────────────────────────────────────────────
local PDCFG = {
    enabled = false, radius = 400, dodgeDist = 160, cooldown = 0.008, threshold = 150,
    leadTime = 0.22, bulletSpd = 200, reactTime = 0.06, raycast = true, backstep = true,
    shootDot = 0.60, shootDist = 100, infiniteRange = true, notifyAnywhere = false,
    adaptiveCooldown = true,
}

local predLastDodge = 0
local predShootCD = {}

local function perpDodgeDir(fromPos, myPos)
    local d = (myPos - fromPos)
    if d.Magnitude < 0.01 then
        return Vector3.new(1, 0, 0)
    end
    d = d.Unit
    local up = Vector3.new(0, 1, 0)
    local right = d:Cross(up)
    if right.Magnitude < 0.01 then
        right = Vector3.new(1, 0, 0)
    end
    return (math.random() < 0.5 and right or -right).Unit
end

local function enemyAiming(plr, myPos, dot)
    local char = plr.Character
    if not char then
        return false
    end
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then
        return false
    end
    local look = head.CFrame.LookVector
    local eye = head.Position + look * 0.5
    local toMe = myPos - eye
    if toMe.Magnitude < 0.01 then
        return false
    end
    return look:Dot(toMe.Unit) > dot
end

local function doPredictionDodge()
    if not root then
        return
    end
    local now = tick()
    local cd = PDCFG.cooldown
    if PDCFG.adaptiveCooldown then
        local threats = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (root.Position - hrp.Position).Magnitude
                    if d <= PDCFG.radius then
                        threats = threats + 1
                    end
                end
            end
        end
        if threats > 1 then
            cd = cd / math.max(1, threats * 0.5)
        end
    end
    if now - predLastDodge < cd then
        return
    end

    local myPos = root.Position
    local primary, primaryScore, primaryHrp = nil, -1, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP or not p.Character then
            continue
        end
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            continue
        end
        local d = (myPos - hrp.Position).Magnitude
        if not PDCFG.infiniteRange and d > PDCFG.radius then
            continue
        end
        local score = 0
        if enemyAiming(p, myPos, PDCFG.shootDot) then
            score = score + 60
        end
        if predShootCD[p] and (now - predShootCD[p]) < 0.3 then
            score = score + 80
        end
        local vel = hrp.AssemblyLinearVelocity
        if vel.Magnitude > 50 then
            local predicted = hrp.Position + vel * PDCFG.leadTime
            if (myPos - predicted).Magnitude < PDCFG.threshold then
                score = score + 50
            end
        end
        score = score - d * 0.1
        if score > primaryScore then
            primaryScore = score;
            primary = p;
            primaryHrp = hrp
        end
    end
    if not primary or primaryScore < 10 then
        return
    end

    local dodgeDir = perpDodgeDir(primaryHrp.Position, myPos)
    local dodge = dodgeDir * PDCFG.dodgeDist
    if PDCFG.backstep then
        dodge = dodge + (myPos - primaryHrp.Position).Unit * 20
    end
    local finalPos = myPos + dodge
    predLastDodge = now
    pcall(
        function()
            root.CFrame = CFrame.new(finalPos)
        end
    )
end

local function startPrediction()
    killConn("pred")
    -- hook tool activate for enemy tool detection
    local function hookToolActivate(tool)
        if not tool then
            return
        end
        pcall(
            function()
                local oldActivate
                oldActivate = hookfunction(
                    tool.Activate,
                    function(self, ...)
                        if not checkcaller() and self == tool then
                            local owner = tool.Parent and tool.Parent.Parent
                            if owner and owner ~= LP and owner.Character then
                                predShootCD[owner] = tick()
                            end
                        end
                        return oldActivate(self, ...)
                    end
                )
            end
        )
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tool = p.Character:FindFirstChildOfClass("Tool")
            if tool then
                hookToolActivate(tool)
            end
            p.Character.ChildAdded:Connect(
                function(c)
                    if c:IsA("Tool") then
                        hookToolActivate(c)
                    end
                end
            )
        end
    end
    conns.pred = RunService.Heartbeat:Connect(
        function()
            if not PDCFG.enabled then
                killConn("pred");
                return
            end
            pcall(doPredictionDodge)
        end
    )
end

local function stopPrediction()
    killConn("pred");
    PDCFG.enabled = false
end

-- ─────────────────────────────────────────────────────────────
--  ANTI-BAIT CONFIG
-- ─────────────────────────────────────────────────────────────
local ABCFG = {
    enabled = false, velThreshold = 200, velDodgeDist = 100, flickerWindow = 0.3, flickerMinTps = 2,
    flickerTpDist = 10, dodgeCooldown = 0.005, dodgeMode = "perpendicular", dodgeOnShoot = true,
    shootLookThresh = 0.85, gunPredEnabled = true, gunPredDot = 0.80, gunPredVelMin = 30,
    gunPredDodgeDist = 160, gunPredCooldown = 0.005, gunPredLead = 0.22, baitStallTime = 0.08,
    baitFakeLock = true,
}

local antiBaitLastDodge = 0
local antiBaitHistory = {
} -- [player] = { positions = {}, times = {} }

local function doAntiBaitDodge(fromPos)
    if not root then
        return
    end
    local now = tick()
    if now - antiBaitLastDodge < ABCFG.dodgeCooldown then
        return
    end
    local myPos = root.Position
    local dodge
    if ABCFG.dodgeMode == "perpendicular" then
        dodge = perpDodgeDir(fromPos, myPos) * ABCFG.velDodgeDist
    else
        dodge = (myPos - fromPos).Unit * ABCFG.velDodgeDist
    end
    antiBaitLastDodge = now
    pcall(
        function()
            root.CFrame = CFrame.new(myPos + dodge)
        end
    )
end

local function startAntiBait()
    killConn("antiBait")
    conns.antiBait = RunService.Heartbeat:Connect(
        function()
            if not ABCFG.enabled then
                killConn("antiBait");
                return
            end
            if not root then
                return
            end
            local myPos = root.Position
            for _, p in ipairs(Players:GetPlayers()) do
                if p == LP or not p.Character then
                    continue
                end
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then
                    continue
                end
                -- velocity spike detection
                local vel = hrp.AssemblyLinearVelocity
                if vel.Magnitude > ABCFG.velThreshold then
                    local predicted = hrp.Position + vel * ABCFG.gunPredLead
                    if (myPos - predicted).Magnitude < ABCFG.gunPredDodgeDist then
                        pcall(doAntiBaitDodge, hrp.Position)
                    end
                end
                -- gun prediction: enemy aiming + moving fast
                if ABCFG.gunPredEnabled and vel.Magnitude > ABCFG.gunPredVelMin then
                    if enemyAiming(p, myPos, ABCFG.gunPredDot) then
                        pcall(doAntiBaitDodge, hrp.Position)
                    end
                end
                -- flicker detection: rapid position changes
                local hist = antiBaitHistory[p]
                if not hist then
                    antiBaitHistory[p] = {positions = {}, times = {}};
                    hist = antiBaitHistory[p]
                end
                table.insert(hist.positions, hrp.Position)
                table.insert(hist.times, tick())
                if #hist.positions > 20 then
                    table.remove(hist.positions, 1);
                    table.remove(hist.times, 1)
                end
                if #hist.positions >= ABCFG.flickerMinTps then
                    local recent = 0
                    local now2 = tick()
                    for i, t in ipairs(hist.times) do
                        if now2 - t < ABCFG.flickerWindow then
                            if i > 1 and (hist.positions[i] - hist.positions[i - 1]).Magnitude > ABCFG.flickerTpDist then
                                recent = recent + 1
                            end
                        end
                    end
                    if recent >= ABCFG.flickerMinTps then
                        pcall(doAntiBaitDodge, hrp.Position)
                    end
                end
            end
        end
    )
end

local function stopAntiBait()
    killConn("antiBait");
    ABCFG.enabled = false;
    antiBaitHistory = {}
end

-- ─────────────────────────────────────────────────────────────
--  ANTI-AIM CONFIG
-- ─────────────────────────────────────────────────────────────
local AACFG = {
    enabled = false, mode = "random spin", speed = 5000, jitterPitch = true, pitchAngle = 45,
    yawAngle = 45, staticYaw = 90, staticPitch = 0, customYaw = 180, customPitch = 0,
    jitterYaw = true, microJitter = false, microJitterAmp = 5, microJitterSpeed = 30,
    desyncMode = false, desyncOffset = 180, rollEnabled = false, rollSpeed = 360, noClip = true,
    massless = true, antiFling = true, velZero = true, networkOwn = true,
}

local aaAngAcc, aaJitter, aaRandMult = 0, 0, 1
local aaRandTimer, aaMicroTimer, aaRollAcc = 0, 0, 0

local function startAntiAim()
    killConn("antiAim")
    conns.antiAim = RunService.Heartbeat:Connect(
        function(dt)
            if not AACFG.enabled then
                killConn("antiAim");
                return
            end
            if not root then
                return
            end
            if AACFG.noClip and LP.Character then
                applyNoClip(LP.Character)
            end
            if AACFG.networkOwn then
                setNetworkOwnerLocal(root)
            end
            aaRollAcc = aaRollAcc + dt;
            aaMicroTimer = aaMicroTimer + dt

            local spd = AACFG.speed
            aaRandTimer = aaRandTimer + dt
            if aaRandTimer > 0.1 then
                aaRandTimer = 0;
                aaRandMult = 0.2 + math.random() * 0.8
            end

            local extraYaw, extraPitch, rollAngle = 0, 0, 0
            if AACFG.desyncMode then
                extraYaw = extraYaw + AACFG.desyncOffset
            end
            if AACFG.microJitter and aaMicroTimer >= (1 / math.max(AACFG.microJitterSpeed, 1)) then
                aaMicroTimer = 0
                extraYaw = extraYaw + (math.random() - 0.5) * AACFG.microJitterAmp * 2
                extraPitch = extraPitch + (math.random() - 0.5) * AACFG.microJitterAmp
            end
            if AACFG.rollEnabled then
                rollAngle = (aaRollAcc * AACFG.rollSpeed * math.pi / 180) % (2 * math.pi)
            end
            local m = AACFG.mode
            pcall(
                function()
                    if m == "spin" then
                        aaAngAcc = aaAngAcc + spd * dt
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(
                            math.rad(extraPitch), math.rad(aaAngAcc + extraYaw), rollAngle
                        )
                    elseif m == "jitter" then
                        local p = AACFG.jitterPitch and AACFG.pitchAngle or 0
                        local y = AACFG.jitterYaw and AACFG.yawAngle or 0
                        root.CFrame = root.CFrame * CFrame.Angles(
                            math.rad((aaJitter == 0 and p or -p) + extraPitch),
                            math.rad((aaJitter == 0 and y or -y) + extraYaw), rollAngle
                        )
                        aaJitter = (aaJitter + 1) % 2
                    elseif m == "static" then
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(
                            math.rad(AACFG.staticPitch + extraPitch),
                            math.rad(AACFG.staticYaw + extraYaw), rollAngle
                        )
                    elseif m == "up" then
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(
                            math.rad(90 + extraPitch), math.rad(extraYaw), rollAngle
                        )
                    elseif m == "down" then
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(
                            math.rad(-90 + extraPitch), math.rad(extraYaw), rollAngle
                        )
                    elseif m == "side" then
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(
                            math.rad(extraPitch), math.rad(extraYaw), math.rad(90) + rollAngle
                        )
                    elseif m == "random spin" then
                        aaAngAcc = aaAngAcc + spd * dt * aaRandMult * (math.random() * 2 - 1)
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(
                            math.rad(AACFG.customPitch + extraPitch), math.rad(aaAngAcc + extraYaw),
                            rollAngle
                        )
                    elseif m == "custom" then
                        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(
                            math.rad(AACFG.customPitch + extraPitch),
                            math.rad(AACFG.customYaw + extraYaw), rollAngle
                        )
                    end
                    if AACFG.velZero then
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            )
        end
    )
end

local function stopAntiAim()
    killConn("antiAim");
    AACFG.enabled = false
end

-- ─────────────────────────────────────────────────────────────
--  VEL DESYNC CONFIG
-- ─────────────────────────────────────────────────────────────
local VDCFG = {
    enabled = false, intensity = 50, speed = 10, angle = 90, jitter = 20, flip = false,
    noClip = true, networkOwn = true, multiVector = false, vectorCount = 3, oscillate = false,
    oscillateFreq = 2, oscillateAmp = 30, spikeMode = false, spikeMag = 50000, spikeInterval = 0.5,
    noiseVel = false, noiseScale = 0.5, counterVel = false,
}

local vdHB, vdRS = nil, nil
local vdRealVel = nil
local vdAngleAcc = 0
local vdOscAcc, vdBurstT = 0, 0
local vdInverted = false

local function startVelDesync()
    if vdHB then
        vdHB:Disconnect()
    end
    if vdRS then
        vdRS:Disconnect()
    end
    vdRealVel = nil;
    vdAngleAcc = 0;
    vdOscAcc = 0;
    vdBurstT = 0;
    vdInverted = false
    vdHB = RunService.Heartbeat:Connect(
        function(dt)
            local hrp = getLocalRoot()
            if not VDCFG.enabled or not hrp then
                return
            end
            if VDCFG.noClip and LP.Character then
                applyNoClip(LP.Character)
            end
            if VDCFG.networkOwn then
                setNetworkOwnerLocal(hrp)
            end
            vdRealVel = hrp.AssemblyLinearVelocity
            vdOscAcc = vdOscAcc + dt;
            vdBurstT = vdBurstT + dt
            local sign = (VDCFG.flip or vdInverted) and -1 or 1
            local spd = math.clamp(VDCFG.speed, 1, 100)
            vdAngleAcc = (vdAngleAcc + math.rad(spd * dt * 360)) % (2 * math.pi)
            local baseAng = math.rad(VDCFG.angle)
            local jR = math.clamp(VDCFG.jitter, 0, 180)
            local angle = baseAng + math.rad((math.random() - 0.5) * jR * 2) + vdAngleAcc
            if VDCFG.oscillate then
                angle = angle + math.rad(
                    math.sin(vdOscAcc * VDCFG.oscillateFreq * 2 * math.pi) * VDCFG.oscillateAmp
                )
            end
            local mag = (math.clamp(VDCFG.intensity, 1, 100) / 100) * 50000
            if VDCFG.spikeMode and vdBurstT >= VDCFG.spikeInterval then
                vdBurstT = 0;
                mag = mag + VDCFG.spikeMag
            end
            local noiseX, noiseZ = 0, 0
            if VDCFG.noiseVel then
                local t = tick() * VDCFG.noiseScale
                noiseX = math.noise(t, 0, 0) * mag * 0.5
                noiseZ = math.noise(0, t, 0) * mag * 0.5
            end
            local spoofs = {}
            local count = VDCFG.multiVector and VDCFG.vectorCount or 1
            for i = 1, count do
                local a = angle + (i - 1) * (2 * math.pi / count)
                table.insert(
                    spoofs,
                    Vector3.new(
                        math.cos(a) * mag * sign + noiseX, (math.random() - 0.5) * mag * 0.5,
                        math.sin(a) * mag * sign + noiseZ
                    )
                )
            end
            if VDCFG.counterVel and vdRealVel then
                table.insert(spoofs, -vdRealVel * 2)
            end
            local mt = getrawmetatable and getrawmetatable(hrp)
            local ni = mt and rawget(mt, "__newindex")
            for _, spoof in ipairs(spoofs) do
                if ni then
                    pcall(ni, hrp, "AssemblyLinearVelocity", spoof)
                else
                    pcall(
                        function()
                            hrp.AssemblyLinearVelocity = spoof
                        end
                    )
                end
                if sethiddenproperty then
                    pcall(sethiddenproperty, hrp, "AssemblyLinearVelocity", spoof)
                end
            end
        end
    )
    vdRS = RunService.RenderStepped:Connect(
        function()
            local hrp = getLocalRoot()
            if VDCFG.enabled and hrp and vdRealVel then
                hrp.AssemblyLinearVelocity = vdRealVel
            end
        end
    )
end

local function stopVelDesync()
    if vdHB then
        vdHB:Disconnect();
        vdHB = nil
    end
    if vdRS then
        vdRS:Disconnect();
        vdRS = nil
    end
    vdRealVel = nil;
    vdAngleAcc = 0;
    VDCFG.enabled = false
end

-- ─────────────────────────────────────────────────────────────
--  TRANSLOCATION CONFIG (fake pos)
-- ─────────────────────────────────────────────────────────────
local TLCFG = {
    enabled = false, frequency = 256, offsetDist = 999000000000, offsetMode = "ahead", offsetY = 0,
    fakeVel = true, fakeVelMag = 1e10, snapBack = true, jitter = true, jitterAmp = 1e11, layers = 5,
    noClip = true, antiFling = true, velZero = true, networkOwnerFix = true, massless = true,
    burstMode = false, burstCount = 10, burstInterval = 0.001, diagonal = false, diagonalAngle = 45,
    autoDodge = false, autoDodgeRadius = 60,
}

local translocConn, translocPreRender = nil, nil
local translocRealCF = nil
local translocAcc = 0
local translocWaveT = 0

local function getTranslocFakePos(realCF)
    local d = TLCFG.offsetDist
    local jmp = TLCFG.jitter and TLCFG.jitterAmp or 0
    local base = realCF.Position
    local ox, oy, oz = 0, 0, 0
    local m = TLCFG.offsetMode
    if m == "ahead" then
        local look = realCF.LookVector;
        ox = look.X * d;
        oz = look.Z * d;
        oy = TLCFG.offsetY
    elseif m == "behind" then
        local look = realCF.LookVector;
        ox = -look.X * d;
        oz = -look.Z * d;
        oy = TLCFG.offsetY
    elseif m == "above" then
        ox = (math.random() - 0.5) * jmp;
        oy = math.abs(d) + TLCFG.offsetY;
        oz = (math.random() - 0.5) * jmp
    elseif m == "below" then
        ox = (math.random() - 0.5) * jmp;
        oy = -math.abs(d) + TLCFG.offsetY;
        oz = (math.random() - 0.5) * jmp
    elseif m == "diagonal" then
        local ang = math.rad(TLCFG.diagonalAngle)
        ox = math.cos(ang) * d;
        oz = math.sin(ang) * d;
        oy = TLCFG.offsetY
    else
        ox = (math.random() - 0.5) * jmp;
        oy = TLCFG.offsetY;
        oz = (math.random() - 0.5) * jmp
    end
    return CFrame.new(base + Vector3.new(ox, oy, oz))
end

local translocTimer = 0

local function startTransloc()
    if translocConn then
        translocConn:Disconnect()
    end
    if translocPreRender then
        translocPreRender:Disconnect()
    end
    translocRealCF = nil;
    translocAcc = 0;
    translocTimer = 0
    translocConn = RunService.Heartbeat:Connect(
        function(dt)
            if not TLCFG.enabled then
                if translocConn then
                    translocConn:Disconnect();
                    translocConn = nil
                end
                return
            end
            local hrp = getLocalRoot()
            if not hrp then
                return
            end
            if TLCFG.noClip and LP.Character then
                applyNoClip(LP.Character)
            end
            if TLCFG.networkOwnerFix then
                setNetworkOwnerLocal(hrp)
            end
            translocRealCF = hrp.CFrame
            translocTimer = translocTimer + dt
            if translocTimer < (1 / TLCFG.frequency) then
                return
            end
            translocTimer = 0
            for _ = 1, TLCFG.layers do
                local fakeCF = getTranslocFakePos(translocRealCF)
                pcall(
                    function()
                        hrp.CFrame = fakeCF
                    end
                )
                if TLCFG.fakeVel then
                    local fv = (fakeCF.Position - translocRealCF.Position)
                    if fv.Magnitude > 0.01 then
                        fv = fv.Unit * TLCFG.fakeVelMag
                    end
                    pcall(
                        function()
                            hrp.AssemblyLinearVelocity = fv
                        end
                    )
                end
            end
            if TLCFG.velZero then
                pcall(
                    function()
                        hrp.AssemblyLinearVelocity = Vector3.zero
                    end
                )
            end
        end
    )
    translocPreRender = RunService.RenderStepped:Connect(
        function()
            local hrp = getLocalRoot()
            if TLCFG.enabled and hrp and translocRealCF then
                if TLCFG.snapBack then
                    pcall(
                        function()
                            hrp.CFrame = translocRealCF
                        end
                    )
                end
            end
        end
    )
end

local function stopTransloc()
    if translocConn then
        translocConn:Disconnect();
        translocConn = nil
    end
    if translocPreRender then
        translocPreRender:Disconnect();
        translocPreRender = nil
    end
    translocRealCF = nil;
    TLCFG.enabled = false
end

-- ─────────────────────────────────────────────────────────────
--  SLING BYPASS CONFIG
-- ─────────────────────────────────────────────────────────────
local SBCFG = {
    enabled = false, mode = "follow", targetMode = "closest", stickHeight = 2, attackRange = 1e15,
    shotCooldown = 0.01, hideAvatar = true, autoShoot = true, useTargetVel = true, orbitRadius = 5,
    orbitSpeed = 200, orbitHeight = 2, randomRadius = 10, stalkDist = 3, noClip = true,
    networkOwn = true, velZero = true,
}

local slingConn = nil
local slingOrbAng = 0
local slingLastShot = 0

local function tpTo(pos, vel)
    if not root then
        return
    end
    pcall(
        function()
            root.CFrame = CFrame.new(pos)
            if vel and SBCFG.useTargetVel then
                root.AssemblyLinearVelocity = vel
            end
            if SBCFG.velZero then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    )
end

local function doAutoShoot(target)
    if not SBCFG.autoShoot or not target then
        return
    end
    local now = tick()
    if now - slingLastShot < SBCFG.shotCooldown then
        return
    end
    local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    if (root.Position - hrp.Position).Magnitude > SBCFG.attackRange then
        return
    end
    slingLastShot = now
    aimAtTarget(root, hrp.Position)
    fireTool()
end

local function startSlingBypass()
    if slingConn then
        slingConn:Disconnect()
    end
    slingOrbAng = 0;
    slingLastShot = 0
    if hum then
        pcall(
            function()
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end
        )
    end
    slingConn = RunService.Heartbeat:Connect(
        function(dt)
            if not SBCFG.enabled then
                stopSlingBypass();
                return
            end
            if not root then
                return
            end
            if SBCFG.noClip and LP.Character then
                applyNoClip(LP.Character)
            end
            if SBCFG.networkOwn then
                setNetworkOwnerLocal(root)
            end
            local target = getTarget(SBCFG.targetMode)
            if not target or not target.Character then
                return
            end
            local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
            if not tHrp then
                return
            end
            local vel = tHrp.AssemblyLinearVelocity
            local m = SBCFG.mode
            if m == "follow" or m == "stalk" then
                local d = m == "stalk" and SBCFG.stalkDist or 0
                tpTo(tHrp.Position + Vector3.new(0, SBCFG.stickHeight + d, 0), vel)
                doAutoShoot(target)
            elseif m == "hover" then
                local above = tHrp.Position + Vector3.new(0, SBCFG.stickHeight + 10, 0)
                tpTo(above, vel)
                doAutoShoot(target)
            elseif m == "orbit target" then
                slingOrbAng = (slingOrbAng + math.rad(SBCFG.orbitSpeed) * dt) % (2 * math.pi)
                tpTo(
                    tHrp.Position + Vector3.new(
                        math.cos(slingOrbAng) * SBCFG.orbitRadius, SBCFG.orbitHeight,
                        math.sin(slingOrbAng) * SBCFG.orbitRadius
                    ), vel
                )
                doAutoShoot(target)
            elseif m == "random around" then
                local a = math.random() * 2 * math.pi
                tpTo(
                    tHrp.Position + Vector3.new(
                        math.cos(a) * SBCFG.randomRadius, SBCFG.stickHeight,
                        math.sin(a) * SBCFG.randomRadius
                    ), vel
                )
                doAutoShoot(target)
            end
        end
    )
end

local function stopSlingBypass()
    if slingConn then
        slingConn:Disconnect();
        slingConn = nil
    end
    SBCFG.enabled = false
    if hum then
        pcall(
            function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        )
    end
end

-- ─────────────────────────────────────────────────────────────
--  RIOT GODMODE CONFIG (micro-tp evasion)
-- ─────────────────────────────────────────────────────────────
local RGCFG = {
    enabled = false, speed = 0.03, evadeRange = 30, spinSpeed = 180, heightVariance = 10,
    groundSnap = false, minJump = 10, maxJump = 200, multiTp = false, multiTpCount = 3,
    multiTpDelay = 0.01,
}

local riotGMConn, riotGMTimer, riotGMAng = nil, 0, 0

local function startRiotGodmode()
    if riotGMConn then
        riotGMConn:Disconnect()
    end
    riotGMTimer = 0;
    riotGMAng = 0
    riotGMConn = RunService.Heartbeat:Connect(
        function(dt)
            if not RGCFG.enabled then
                stopRiotGodmode();
                return
            end
            local hrp = getLocalRoot()
            if not hrp then
                return
            end
            pcall(
                function()
                    root:SetNetworkOwner(LP)
                end
            )
            if LP.Character then
                applyNoClip(LP.Character)
            end
            riotGMTimer = riotGMTimer + dt
            if riotGMTimer < RGCFG.speed then
                return
            end
            riotGMTimer = 0
            local cur = hrp.Position
            local function pickPos(from)
                local a = math.random() * 2 * math.pi
                local d = RGCFG.minJump + math.random() * (RGCFG.maxJump - RGCFG.minJump)
                return from + Vector3.new(
                    math.cos(a) * d, math.random(-RGCFG.heightVariance, RGCFG.heightVariance),
                    math.sin(a) * d
                )
            end
            if not RGCFG.multiTp then
                pcall(
                    function()
                        hrp.CFrame = CFrame.new(pickPos(cur))
                    end
                )
            else
                for _ = 1, RGCFG.multiTpCount do
                    pcall(
                        function()
                            hrp.CFrame = CFrame.new(pickPos(hrp.Position))
                        end
                    )
                    task.wait(RGCFG.multiTpDelay)
                end
            end
            riotGMAng = riotGMAng + dt * math.rad(RGCFG.spinSpeed)
            pcall(
                function()
                    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, riotGMAng, 0)
                end
            )
        end
    )
end

local function stopRiotGodmode()
    if riotGMConn then
        riotGMConn:Disconnect();
        riotGMConn = nil
    end
    RGCFG.enabled = false
end

-- ─────────────────────────────────────────────────────────────
--  CHARACTER BINDING
-- ─────────────────────────────────────────────────────────────
local function bindChar(c)
    char = c
    root = c:WaitForChild("HumanoidRootPart", 10)
    hum = c:WaitForChild("Humanoid", 10)
    if VCFG.enabled or VCFG.hideEnabled then
        startVoid()
    end
    if OCFG.enabled then
        startOrbit()
    end
    if PDCFG.enabled then
        startPrediction()
    end
    if ABCFG.enabled then
        startAntiBait()
    end
    if AACFG.enabled then
        startAntiAim()
    end
    if TLCFG.enabled then
        startTransloc()
    end
    if VDCFG.enabled then
        startVelDesync()
    end
    if SBCFG.enabled then
        startSlingBypass()
    end
    if RGCFG.enabled then
        startRiotGodmode()
    end
end

if LP.Character then
    bindChar(LP.Character)
end
LP.CharacterAdded:Connect(
    function(c)
        task.wait(0.3);
        bindChar(c)
    end
)
LP.CharacterRemoving:Connect(
    function()
        killConn("void");
        killConn("orbit");
        killConn("pred")
        killConn("antiAim");
        killConn("antiBait")
        stopTransloc();
        stopVelDesync();
        stopSlingBypass();
        stopRiotGodmode()
        root = nil;
        hum = nil;
        char = nil
        antiBaitHistory = {}
    end
)

-- ─────────────────────────────────────────────────────────────
--  POSITION TRACKER — fixed position, matches UI palette
-- ─────────────────────────────────────────────────────────────
do
    local SG = Instance.new("ScreenGui")
    SG.Name = "HiatusTracker"
    SG.ResetOnSpawn = false
    SG.IgnoreGuiInset = true
    SG.DisplayOrder = 99998
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(
        function()
            SG.Parent = gethui()
        end
    )
    if not SG.Parent then
        SG.Parent = LP:WaitForChild("PlayerGui")
    end

    -- Preset theme colors pulled from library
    local T = {
        Background = Color3.fromRGB(20, 22, 24), Inline = Color3.fromRGB(24, 27, 29),
        Outline = Color3.fromRGB(29, 31, 34), Accent = Color3.fromRGB(179, 165, 255),
        Text = Color3.fromRGB(255, 255, 255), InactiveText = Color3.fromRGB(120, 120, 120),
    }

    local AX = {
        x = Color3.fromRGB(220, 65, 90), y = Color3.fromRGB(65, 195, 95),
        z = Color3.fromRGB(65, 125, 240),
    }

    -- original dimensions: 178 × 112 — not changed
    local W, H = 178, 112
    local card = Instance.new("Frame")
    card.Name = "HiatusTrackerCard"
    card.Size = UDim2.new(0, W, 0, H)
    card.Position = UDim2.new(0, 14, 1, -(H + 14))
    card.BackgroundColor3 = T.Background
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Active = false -- not interactive; no drag
    card.Parent = SG

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    -- outer stroke — 1px Outline, Border mode
    local stroke = Instance.new("UIStroke")
    stroke.Color = T.Outline
    stroke.Thickness = 1
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = card

    -- ── header bar: Inline bg, 34px, rounded top only ─────────
    -- 34px header leaves 78px for 3 rows at 23px stride (matches original row spacing)
    local hdr = Instance.new("Frame")
    hdr.Name = "Header"
    hdr.Size = UDim2.new(1, 0, 0, 34)
    hdr.BackgroundColor3 = T.Inline
    hdr.BorderSizePixel = 0
    hdr.ZIndex = 2
    hdr.Parent = card

    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 10)

    -- fill to square off the bottom of the header corner
    local hdrFill = Instance.new("Frame")
    hdrFill.Size = UDim2.new(1, 0, 0, 10)
    hdrFill.Position = UDim2.new(0, 0, 1, -10)
    hdrFill.BackgroundColor3 = T.Inline
    hdrFill.BorderSizePixel = 0
    hdrFill.ZIndex = 2
    hdrFill.Parent = hdr

    -- logo — matches Window Items["Logo"]: rbxassetid://87164893498141, 20×20 to fit header
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 20, 0, 20)
    logo.AnchorPoint = Vector2.new(0, 0.5)
    logo.Position = UDim2.new(0, 10, 0.5, 0)
    logo.BackgroundTransparency = 1
    logo.BorderSizePixel = 0
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Image = "rbxassetid://87164893498141"
    logo.ImageColor3 = T.Accent
    logo.ZIndex = 3
    logo.Parent = hdr

    -- title: "Hiatus.cc" — GothamBold 12px, x=36, vertically centred in header
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "Title"
    titleLbl.Size = UDim2.new(0, 90, 0, 14)
    titleLbl.Position = UDim2.new(0, 36, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.BorderSizePixel = 0
    titleLbl.Text = "Hiatus.cc"
    titleLbl.TextColor3 = T.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 3
    titleLbl.Parent = hdr

    -- subtitle: "position" — Gotham 9px, InactiveText
    local subLbl = Instance.new("TextLabel")
    subLbl.Name = "SubTitle"
    subLbl.Size = UDim2.new(0, 90, 0, 10)
    subLbl.Position = UDim2.new(0, 36, 0, 19)
    subLbl.BackgroundTransparency = 1
    subLbl.BorderSizePixel = 0
    subLbl.Text = "position"
    subLbl.TextColor3 = T.InactiveText
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 9
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 3
    subLbl.Parent = hdr

    -- separator line under header
    local sep = Instance.new("Frame")
    sep.Name = "Separator"
    sep.Size = UDim2.new(1, -24, 0, 1)
    sep.Position = UDim2.new(0, 12, 0, 34)
    sep.BackgroundColor3 = T.Outline
    sep.BorderSizePixel = 0
    sep.ZIndex = 2
    sep.Parent = card

    -- ── axis rows (x / y / z) — original row spacing: stride 23 ──
    local rows = {
        {label = "x", color = AX.x}, {label = "y", color = AX.y}, {label = "z", color = AX.z},
    }
    local valLabels = {}

    for i, row in ipairs(rows) do
        local rowY = 40 + (i - 1) * 23 -- original offset

        -- colored axis pill: 3×14, rounded
        local pill = Instance.new("Frame")
        pill.Size = UDim2.new(0, 3, 0, 14)
        pill.Position = UDim2.new(0, 14, 0, rowY + 3)
        pill.BackgroundColor3 = row.color
        pill.BorderSizePixel = 0
        pill.ZIndex = 2
        pill.Parent = card
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

        -- axis letter — colored to match pill
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 14, 0, 20)
        lbl.Position = UDim2.new(0, 22, 0, rowY)
        lbl.BackgroundTransparency = 1
        lbl.BorderSizePixel = 0
        lbl.Text = row.label
        lbl.TextColor3 = row.color
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 2
        lbl.Parent = card

        -- value — Code font, right-aligned, primary text color
        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -50, 0, 20)
        val.Position = UDim2.new(0, 40, 0, rowY)
        val.BackgroundTransparency = 1
        val.BorderSizePixel = 0
        val.Text = "0"
        val.TextColor3 = T.Text
        val.Font = Enum.Font.Code
        val.TextSize = 12
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.ZIndex = 2
        val.Parent = card
        valLabels[row.label] = val
    end

    -- ── update loop — no drag, card is fixed ──────────────────
    RunService.Heartbeat:Connect(
        function()
            local c = LP.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local p = hrp and hrp.Position
            valLabels["x"].Text = p and string.format("%.1f", p.X) or "—"
            valLabels["y"].Text = p and string.format("%.1f", p.Y) or "—"
            valLabels["z"].Text = p and string.format("%.1f", p.Z) or "—"
        end
    )
end

-- ─────────────────────────────────────────────────────────────
--  WINDOW + PAGES
-- ─────────────────────────────────────────────────────────────
local Window = Library:Window({Name = "Hiatus.cc", SubName = ""})

local PageVisuals = Window:Page({Name = "visuals"})
local PageMovement = Window:Page({Name = "movement"})
local PageCombat = Window:Page({Name = "combat"})
local PageDefense = Window:Page({Name = "defense"})
local PageTransloc = Window:Page({Name = "transloc"})

-- ─────────────────────────────────────────────────────────────
--  HELPERS
-- ─────────────────────────────────────────────────────────────
local function Slider(Section, name, flag, min, max, default, step, suffix, cb)
    return Section:Slider(
        {
            Name = name, Flag = flag, Min = min, Max = max, Default = default, Decimals = step,
            Suffix = suffix or "", Callback = cb
        }
    )
end

local function Toggle(Section, name, flag, default, cb)
    return Section:Toggle({Name = name, Flag = flag, Default = default, Callback = cb})
end

local function Dropdown(Section, name, flag, items, default, cb)
    return Section:Dropdown(
        {Name = name, Flag = flag, Items = items, Default = default, Callback = cb}
    )
end

-- ─────────────────────────────────────────────────────────────
--  PAGE: visuals (ESP — Hiatus native)
-- ─────────────────────────────────────────────────────────────
local BuildVisuals = function(Page)
    local Cfg = Library.Esp.Configuration
    local Box = Cfg.Box
    local Fill = Box.Fill
    local Outline = Box.Outline
    local Glow = Box.Glow
    local Health = Cfg.HealthBar
    local Refresh = function()
        Library.Esp:Refresh()
    end
    local Bind = function(T, K, Live)
        return function(V)
            T[K] = V;
            if not Live then
                Refresh()
            end
        end
    end
    local BindIdx = function(T, I)
        return function(V)
            T[I] = V;
            Refresh()
        end
    end
    local Picker = function(Parent, flag, default, cb)
        return Parent:Colorpicker({Flag = flag, Default = default, Callback = cb})
    end

    do -- player esp
        local S = Page:Section({Name = "player esp", Side = 1})
        Toggle(S, "enabled", "ESP/Enabled", false, Bind(Cfg, "Enabled", true))
        Toggle(S, "team check", "ESP/TeamCheck", false, Bind(Cfg.TeamCheck, "Enabled", true))
        Toggle(
            S, "team colors", "ESP/TeamColors", false, Bind(Cfg.TeamCheck, "UseTeamColors", true)
        )
        Toggle(
            S, "show local", "ESP/ShowLocal", false,
            function(v)
                Library.Esp.ShowLocal = v
            end
        )
        S:Divider()
        Slider(
            S, "max distance", "ESP/MaxDistance", 100, 10000, Cfg.MaxDistance, 50, " st",
            Bind(Cfg, "MaxDistance", true)
        )
        Slider(
            S, "update rate", "ESP/UpdateRate", 0, 200, Library.Esp.UpdateRate * 1000, 5, " ms",
            function(v)
                Library.Esp.UpdateRate = v / 1000
            end
        )
        Slider(
            S, "font size", "ESP/FontSize", 8, 20, Library.Esp.FontSize, 1, " px",
            function(v)
                Library.Esp.FontSize = v;
                Refresh()
            end
        )
    end

    do -- box
        local S = Page:Section({Name = "box", Side = 1})
        Dropdown(
            S, "style", "ESP/BoxStyle", {"dynamic", "static"}, Box.Style, Bind(Box, "Style", true)
        )
        Dropdown(S, "type", "ESP/BoxType", {"full", "corners"}, Box.Type, Bind(Box, "Type", true))
        local T = Toggle(S, "outline", "ESP/Outline", true, Bind(Outline, "Enabled"))
        Picker(T, "ESP/OutlineColor", Outline.Color, Bind(Outline, "Color"))
        Slider(
            S, "thickness", "ESP/OutlineThickness", 1, 5, Outline.Thickness, 1, " px",
            Bind(Outline, "Thickness")
        )
        Slider(
            S, "corner length", "ESP/CornerLength", 4, 40, Outline.CornerLength, 1, " px",
            Bind(Outline, "CornerLength")
        )
    end

    do -- fill
        local S = Page:Section({Name = "fill", Side = 1})
        local T = Toggle(S, "fill", "ESP/Fill", false, Bind(Fill, "Enabled"))
        Picker(T, "ESP/FillColor", Color3.fromRGB(100, 60, 220), Bind(Fill, "Color"))
        Slider(
            S, "top transparency", "ESP/FillTop", 0, 1, Fill.Transparency[1], 0.01, "",
            BindIdx(Fill.Transparency, 1)
        )
        Slider(
            S, "bottom transparency", "ESP/FillBottom", 0, 1, Fill.Transparency[2], 0.01, "",
            BindIdx(Fill.Transparency, 2)
        )
        S:Divider()
        Toggle(S, "gradient", "ESP/FillGradient", false, Bind(Fill.Gradient, "Enabled"))
        Picker(
            S:Label({Name = "gradient start"}), "ESP/FillGradStart", Color3.fromRGB(100, 60, 220),
            BindIdx(Fill.Gradient.Color, 1)
        )
        Picker(
            S:Label({Name = "gradient end"}), "ESP/FillGradEnd", Color3.fromRGB(50, 20, 140),
            BindIdx(Fill.Gradient.Color, 2)
        )
        Slider(
            S, "rotation", "ESP/FillRotation", -180, 180, Fill.Gradient.Rotation, 1, "°",
            Bind(Fill.Gradient, "Rotation")
        )
    end

    do -- glow
        local S = Page:Section({Name = "glow", Side = 2})
        local T = Toggle(S, "glow", "ESP/Glow", false, Bind(Glow, "Enabled"))
        Picker(T, "ESP/GlowColor", Color3.fromRGB(100, 60, 220), Bind(Glow, "Color"))
        Slider(
            S, "transparency", "ESP/GlowTransparency", 0, 1, 0.4, 0.01, "",
            Bind(Glow, "Transparency")
        )
        S:Divider()
        Toggle(S, "gradient", "ESP/GlowGradient", false, Bind(Glow.Gradient, "Enabled"))
        Picker(
            S:Label({Name = "gradient start"}), "ESP/GlowGradStart", Color3.fromRGB(100, 60, 220),
            BindIdx(Glow.Gradient.Color, 1)
        )
        Picker(
            S:Label({Name = "gradient end"}), "ESP/GlowGradEnd", Color3.fromRGB(50, 20, 140),
            BindIdx(Glow.Gradient.Color, 2)
        )
        Slider(
            S, "rotation", "ESP/GlowRotation", -180, 180, Glow.Gradient.Rotation, 1, "°",
            Bind(Glow.Gradient, "Rotation")
        )
    end

    do -- health bar
        local S = Page:Section({Name = "health bar", Side = 2})
        Toggle(S, "enabled", "ESP/Health", true, Bind(Health, "Enabled", true))
        Dropdown(
            S, "position", "ESP/HealthPos", {"left", "right", "top", "bottom"}, Health.Position,
            function(v)
                Health.Position = v;
                Library.Esp:Refresh()
            end
        )
        Toggle(S, "animated", "ESP/HealthAnim", false, Bind(Health, "Animated", true))
        Slider(
            S, "anim speed", "ESP/HealthAnimSpd", 0.1, 5, Health.AnimSpeed, 0.1, "x",
            Bind(Health, "AnimSpeed", true)
        )
        S:Divider()
        local Picker_ = function(parent, flag, default, cb)
            return parent:Colorpicker({Flag = flag, Default = default, Callback = cb})
        end
        Picker_(
            S:Label({Name = "high"}), "ESP/HealthHigh", Health.Color.High,
            BindIdx(Health.Color, "High")
        )
        Picker_(
            S:Label({Name = "medium"}), "ESP/HealthMedium", Health.Color.Medium,
            BindIdx(Health.Color, "Medium")
        )
        Picker_(
            S:Label({Name = "low"}), "ESP/HealthLow", Health.Color.Low, BindIdx(Health.Color, "Low")
        )
        S:Divider()
        local T2 = Toggle(
            S, "health text", "ESP/HealthText", false, Bind(Health.Text, "Enabled", true)
        )
        Picker_(T2, "ESP/HealthTextColor", Health.Text.Color, Bind(Health.Text, "Color"))
    end

    do -- labels
        local S = Page:Section({Name = "labels", Side = 2})
        local function PL(parent, flag, default, cb)
            return parent:Colorpicker({Flag = flag, Default = default, Callback = cb})
        end
        PL(
            Toggle(S, "name", "ESP/Name", true, Bind(Cfg.Name, "Enabled", true)), "ESP/NameColor",
            Cfg.Name.Color, Bind(Cfg.Name, "Color")
        )
        PL(
            Toggle(S, "distance", "ESP/Distance", true, Bind(Cfg.Distance, "Enabled", true)),
            "ESP/DistColor", Cfg.Distance.Color, Bind(Cfg.Distance, "Color")
        )
        PL(
            Toggle(S, "tool", "ESP/Tool", false, Bind(Cfg.Tool, "Enabled", true)), "ESP/ToolColor",
            Cfg.Tool.Color, Bind(Cfg.Tool, "Color")
        )
        Toggle(S, "flags", "ESP/Flags", false, Bind(Cfg.Flags, "Enabled", true))
        S:Divider()
        local Suffix = " st"
        Slider(
            S, "text transparency", "ESP/TextTrans", 0, 1, 0, 0.01, "",
            function(v)
                Cfg.Name.Transparency = v;
                Cfg.Distance.Transparency = v;
                Cfg.Tool.Transparency = v;
                Health.Text.Transparency = v;
                Refresh()
            end
        )
        S:Textbox(
            {
                Name = "distance suffix", Flag = "ESP/DistSuffix", Placeholder = "st",
                Default = "st", Finished = true,
                Callback = function(v)
                    Suffix = v ~= "" and (" " .. v) or ""
                end
            }
        )
        Cfg.Distance.Format = function(d)
            return d .. Suffix
        end
        S:Textbox(
            {
                Name = "no tool text", Flag = "ESP/NoToolTxt", Placeholder = "none",
                Default = "none", Finished = true,
                Callback = function(v)
                    Cfg.Tool.NoToolText = v ~= "" and v or "none"
                end
            }
        )
    end
end

BuildVisuals(PageVisuals)

-- ─────────────────────────────────────────────────────────────
--  PAGE: movement (void + void hide + orbit)
-- ─────────────────────────────────────────────────────────────
do
    local Page = PageMovement

    do -- void spam
        local S = Page:Section({Name = "void spam", Side = 1})
        Toggle(
            S, "enabled", "VOID/Enabled", false,
            function(v)
                VCFG.enabled = v
                if v then
                    startVoid()
                else
                    stopVoid()
                end
            end
        )
        Dropdown(
            S, "method", "VOID/Method",
            {"quantum", "drift", "chaos", "loop", "spiral", "orbit target"}, "quantum",
            function(v)
                VCFG.method = v
            end
        )
        Slider(
            S, "speed", "VOID/Speed", 1, 1000, 1, 1, " B/s",
            function(v)
                VCFG.speed = v * 1e12
            end
        )
        Slider(
            S, "chaos", "VOID/Chaos", 1, 100, 98, 1, "%",
            function(v)
                VCFG.chaos = v * 0.01
            end
        )
        Slider(
            S, "radius", "VOID/Radius", 1, 500, 200, 1, " B",
            function(v)
                VCFG.radius = v * 1e9
            end
        )
        S:Divider()
        Toggle(
            S, "anti-fling", "VOID/AntiFling", true,
            function(v)
                VCFG.antiFling = v
            end
        )
        Toggle(
            S, "stop on damage", "VOID/StopDmg", false,
            function(v)
                VCFG.stopOnDamage = v
            end
        )
        Toggle(
            S, "preserve y", "VOID/PreserveY", false,
            function(v)
                VCFG.preserveY = v
            end
        )
        Slider(
            S, "safe radius", "VOID/SafeRad", 0, 200, 0, 1, " st",
            function(v)
                VCFG.safeRadius = v
            end
        )
        S:Divider()
        Toggle(
            S, "duration limit", "VOID/DurEnable", false,
            function(v)
                VCFG.durationEnabled = v
            end
        )
        Slider(
            S, "duration", "VOID/Duration", 1, 300, 10, 1, " s",
            function(v)
                VCFG.duration = v
            end
        )
    end

    do -- void hide
        local S = Page:Section({Name = "void hide", Side = 1})
        Toggle(
            S, "enabled", "VHIDE/Enabled", false,
            function(v)
                VCFG.hideEnabled = v
                if v then
                    startVoid()
                else
                    stopVoid()
                end
            end
        )
        Slider(
            S, "hide x", "VHIDE/X", 1, 100, 1, 1, "e6",
            function(v)
                VCFG.hideX = v * 1e6
            end
        )
        Slider(
            S, "hide y", "VHIDE/Y", 1, 100, 90, 1, "e24",
            function(v)
                VCFG.hideY = v * 1e24
            end
        )
        Slider(
            S, "hide z", "VHIDE/Z", 1, 100, 1, 1, "e6",
            function(v)
                VCFG.hideZ = v * 1e6
            end
        )
    end

    do -- orbit
        local S = Page:Section({Name = "orbit", Side = 2})
        Toggle(
            S, "enabled", "ORBIT/Enabled", false,
            function(v)
                OCFG.enabled = v
                if v then
                    startOrbit()
                else
                    stopOrbit()
                end
            end
        )
        Dropdown(
            S, "mode", "ORBIT/Mode", {"circle", "figure 8", "ellipse", "bounce"}, "circle",
            function(v)
                OCFG.mode = v
            end
        )
        Dropdown(
            S, "target", "ORBIT/Target", {"closest", "random", "weakest", "strongest"}, "closest",
            function(v)
                OCFG.target = v
            end
        )
        Dropdown(
            S, "axis", "ORBIT/Axis", {"xz", "xy", "yz"}, "xz",
            function(v)
                OCFG.axis = v
            end
        )
        Slider(
            S, "speed", "ORBIT/Speed", 1, 720, 90, 1, " deg/s",
            function(v)
                OCFG.speed = v
            end
        )
        Slider(
            S, "distance", "ORBIT/Dist", 1, 50, 8, 1, " st",
            function(v)
                OCFG.dist = v
            end
        )
        Slider(
            S, "height", "ORBIT/Height", -20, 20, 0, 0.5, " st",
            function(v)
                OCFG.height = v
            end
        )
        Slider(
            S, "lerp", "ORBIT/Lerp", 0.01, 1, 0.3, 0.01, "",
            function(v)
                OCFG.lerp = v
            end
        )
        S:Divider()
        Toggle(
            S, "face target", "ORBIT/Face", true,
            function(v)
                OCFG.face = v
            end
        )
        Toggle(
            S, "predict", "ORBIT/Pred", false,
            function(v)
                OCFG.predict = v
            end
        )
        Toggle(
            S, "reverse", "ORBIT/Rev", false,
            function(v)
                OCFG.reverse = v
            end
        )
        Toggle(
            S, "height oscillate", "ORBIT/HOsc", false,
            function(v)
                OCFG.heightOsc = v
            end
        )
        Slider(
            S, "osc amplitude", "ORBIT/HOscAmp", 0.5, 20, 5, 0.5, " st",
            function(v)
                OCFG.heightOscAmp = v
            end
        )
        S:Divider()
        Toggle(
            S, "auto shoot", "ORBIT/AutoShoot", false,
            function(v)
                OCFG.autoShoot = v
            end
        )
        Slider(
            S, "attack range", "ORBIT/AttackRange", 1, 100, 10, 1, " st",
            function(v)
                OCFG.attackRange = v
            end
        )
        Slider(
            S, "shoot cooldown", "ORBIT/ShootCD", 0.01, 2, 0.05, 0.01, " s",
            function(v)
                OCFG.shootCooldown = v
            end
        )
    end
end

-- ─────────────────────────────────────────────────────────────
--  PAGE: combat (prediction + sling bypass + riot abuser)
-- ─────────────────────────────────────────────────────────────
do
    local Page = PageCombat

    do -- prediction dodge
        local S = Page:Section({Name = "prediction dodge", Side = 1})
        Toggle(
            S, "enabled", "PRED/Enabled", false,
            function(v)
                PDCFG.enabled = v
                if v then
                    startPrediction()
                else
                    stopPrediction()
                end
            end
        )
        Slider(
            S, "dodge distance", "PRED/DodgeDist", 20, 500, 160, 10, " st",
            function(v)
                PDCFG.dodgeDist = v
            end
        )
        Slider(
            S, "cooldown", "PRED/Cooldown", 0.001, 0.1, 0.008, 0.001, " s",
            function(v)
                PDCFG.cooldown = v
            end
        )
        Slider(
            S, "threat threshold", "PRED/Thresh", 10, 300, 150, 10, "",
            function(v)
                PDCFG.threshold = v
            end
        )
        Slider(
            S, "lead time", "PRED/Lead", 0.05, 0.5, 0.22, 0.01, " s",
            function(v)
                PDCFG.leadTime = v
            end
        )
        S:Divider()
        Toggle(
            S, "aim raycast", "PRED/Raycast", true,
            function(v)
                PDCFG.raycast = v
            end
        )
        Toggle(
            S, "backstep", "PRED/Backstep", true,
            function(v)
                PDCFG.backstep = v
            end
        )
        Toggle(
            S, "infinite range", "PRED/InfRange", true,
            function(v)
                PDCFG.infiniteRange = v
            end
        )
        Toggle(
            S, "adaptive cooldown", "PRED/Adaptive", true,
            function(v)
                PDCFG.adaptiveCooldown = v
            end
        )
        Slider(
            S, "shoot dot", "PRED/ShootDot", 0.3, 1, 0.60, 0.05, "",
            function(v)
                PDCFG.shootDot = v
            end
        )
    end

    do -- sling bypass
        local S = Page:Section({Name = "sling bypass", Side = 1})
        Toggle(
            S, "enabled", "SLING/Enabled", false,
            function(v)
                SBCFG.enabled = v
                if v then
                    startSlingBypass()
                else
                    stopSlingBypass()
                end
            end
        )
        Dropdown(
            S, "mode", "SLING/Mode", {"follow", "stalk", "hover", "orbit target", "random around"},
            "follow",
            function(v)
                SBCFG.mode = v
            end
        )
        Dropdown(
            S, "target", "SLING/Target", {"closest", "random", "weakest", "strongest"}, "closest",
            function(v)
                SBCFG.targetMode = v
            end
        )
        Slider(
            S, "stick height", "SLING/Height", 0, 20, 2, 0.5, " st",
            function(v)
                SBCFG.stickHeight = v
            end
        )
        Slider(
            S, "orbit radius", "SLING/OrbRad", 1, 50, 5, 1, " st",
            function(v)
                SBCFG.orbitRadius = v
            end
        )
        Slider(
            S, "orbit speed", "SLING/OrbSpd", 10, 1000, 200, 10, " deg/s",
            function(v)
                SBCFG.orbitSpeed = v
            end
        )
        S:Divider()
        Toggle(
            S, "auto shoot", "SLING/AutoShoot", true,
            function(v)
                SBCFG.autoShoot = v
            end
        )
        Toggle(
            S, "hide avatar", "SLING/HideAvatar", true,
            function(v)
                SBCFG.hideAvatar = v
            end
        )
        Toggle(
            S, "use target vel", "SLING/UseVel", true,
            function(v)
                SBCFG.useTargetVel = v
            end
        )
        Slider(
            S, "attack range", "SLING/Range", 1, 1000, 50, 5, " st",
            function(v)
                SBCFG.attackRange = v
            end
        )
        Slider(
            S, "shot cooldown", "SLING/ShotCD", 0.01, 2, 0.01, 0.01, " s",
            function(v)
                SBCFG.shotCooldown = v
            end
        )
    end

    do -- riot godmode
        local S = Page:Section({Name = "riot godmode", Side = 2})
        Toggle(
            S, "enabled", "RIOT/Enabled", false,
            function(v)
                RGCFG.enabled = v
                if v then
                    startRiotGodmode()
                else
                    stopRiotGodmode()
                end
            end
        )
        Slider(
            S, "tick speed", "RIOT/Speed", 0.005, 0.2, 0.03, 0.005, " s",
            function(v)
                RGCFG.speed = v
            end
        )
        Slider(
            S, "min jump", "RIOT/MinJump", 1, 100, 10, 1, " st",
            function(v)
                RGCFG.minJump = v
            end
        )
        Slider(
            S, "max jump", "RIOT/MaxJump", 10, 500, 200, 5, " st",
            function(v)
                RGCFG.maxJump = v
            end
        )
        Slider(
            S, "height variance", "RIOT/HeightVar", 0, 50, 10, 1, " st",
            function(v)
                RGCFG.heightVariance = v
            end
        )
        Slider(
            S, "spin speed", "RIOT/Spin", 0, 1080, 180, 10, " deg/s",
            function(v)
                RGCFG.spinSpeed = v
            end
        )
        S:Divider()
        Toggle(
            S, "multi tp", "RIOT/MultiTp", false,
            function(v)
                RGCFG.multiTp = v
            end
        )
        Slider(
            S, "multi tp count", "RIOT/MultiTpCount", 1, 10, 3, 1, "",
            function(v)
                RGCFG.multiTpCount = v
            end
        )
        Slider(
            S, "multi tp delay", "RIOT/MultiTpDelay", 0.001, 0.1, 0.01, 0.001, " s",
            function(v)
                RGCFG.multiTpDelay = v
            end
        )
    end
end

-- ─────────────────────────────────────────────────────────────
--  PAGE: defense (anti-bait + anti-aim + vel desync)
-- ─────────────────────────────────────────────────────────────
do
    local Page = PageDefense

    do -- anti-bait
        local S = Page:Section({Name = "anti-bait", Side = 1})
        Toggle(
            S, "enabled", "ABAIT/Enabled", false,
            function(v)
                ABCFG.enabled = v
                if v then
                    startAntiBait()
                else
                    stopAntiBait()
                end
            end
        )
        Slider(
            S, "dodge distance", "ABAIT/DodgeDist", 20, 500, 100, 10, " st",
            function(v)
                ABCFG.velDodgeDist = v
            end
        )
        Slider(
            S, "dodge cooldown", "ABAIT/Cooldown", 0.001, 0.1, 0.005, 0.001, " s",
            function(v)
                ABCFG.dodgeCooldown = v
            end
        )
        Dropdown(
            S, "dodge mode", "ABAIT/DodgeMode", {"perpendicular", "away"}, "perpendicular",
            function(v)
                ABCFG.dodgeMode = v
            end
        )
        Slider(
            S, "vel threshold", "ABAIT/VelThresh", 50, 1000, 200, 10, "",
            function(v)
                ABCFG.velThreshold = v
            end
        )
        S:Divider()
        Toggle(
            S, "gun prediction", "ABAIT/GunPred", true,
            function(v)
                ABCFG.gunPredEnabled = v
            end
        )
        Slider(
            S, "gun pred dot", "ABAIT/GunDot", 0.3, 1, 0.80, 0.05, "",
            function(v)
                ABCFG.gunPredDot = v
            end
        )
        Slider(
            S, "gun pred lead", "ABAIT/GunLead", 0.05, 0.5, 0.22, 0.01, " s",
            function(v)
                ABCFG.gunPredLead = v
            end
        )
        S:Divider()
        Toggle(
            S, "flicker detect", "ABAIT/Flicker", true, function(v) end
        ) -- wired via conns.antiBait loop
        Slider(
            S, "flicker window", "ABAIT/FlickWin", 0.1, 1, 0.3, 0.05, " s",
            function(v)
                ABCFG.flickerWindow = v
            end
        )
        Slider(
            S, "min tp count", "ABAIT/FlickMin", 1, 10, 2, 1, "",
            function(v)
                ABCFG.flickerMinTps = v
            end
        )
    end

    do -- anti-aim
        local S = Page:Section({Name = "anti-aim", Side = 1})
        Toggle(
            S, "enabled", "AA/Enabled", false,
            function(v)
                AACFG.enabled = v
                if v then
                    startAntiAim()
                else
                    stopAntiAim()
                end
            end
        )
        Dropdown(
            S, "mode", "AA/Mode",
            {"spin", "jitter", "static", "up", "down", "side", "random spin", "custom"},
            "random spin",
            function(v)
                AACFG.mode = v
            end
        )
        Slider(
            S, "speed", "AA/Speed", 100, 10000, 5000, 100, "",
            function(v)
                AACFG.speed = v
            end
        )
        Slider(
            S, "pitch angle", "AA/PitchAng", 0, 90, 45, 1, "°",
            function(v)
                AACFG.pitchAngle = v
            end
        )
        Slider(
            S, "yaw angle", "AA/YawAng", 0, 180, 45, 1, "°",
            function(v)
                AACFG.yawAngle = v
            end
        )
        Slider(
            S, "static yaw", "AA/StaticYaw", -180, 180, 90, 1, "°",
            function(v)
                AACFG.staticYaw = v
            end
        )
        Slider(
            S, "custom yaw", "AA/CustomYaw", -180, 180, 180, 1, "°",
            function(v)
                AACFG.customYaw = v
            end
        )
        Slider(
            S, "custom pitch", "AA/CustomPitch", -90, 90, 0, 1, "°",
            function(v)
                AACFG.customPitch = v
            end
        )
        S:Divider()
        Toggle(
            S, "desync mode", "AA/Desync", false,
            function(v)
                AACFG.desyncMode = v
            end
        )
        Slider(
            S, "desync offset", "AA/DesyncOff", -360, 360, 180, 5, "°",
            function(v)
                AACFG.desyncOffset = v
            end
        )
        Toggle(
            S, "roll", "AA/Roll", false,
            function(v)
                AACFG.rollEnabled = v
            end
        )
        Slider(
            S, "roll speed", "AA/RollSpd", 0, 720, 360, 10, " deg/s",
            function(v)
                AACFG.rollSpeed = v
            end
        )
        Toggle(
            S, "micro jitter", "AA/MicroJitter", false,
            function(v)
                AACFG.microJitter = v
            end
        )
        Slider(
            S, "jitter amp", "AA/MicroAmp", 1, 90, 5, 1, "°",
            function(v)
                AACFG.microJitterAmp = v
            end
        )
        S:Divider()
        Toggle(
            S, "no clip", "AA/NoClip", true,
            function(v)
                AACFG.noClip = v
            end
        )
        Toggle(
            S, "vel zero", "AA/VelZero", true,
            function(v)
                AACFG.velZero = v
            end
        )
        Toggle(
            S, "net owner", "AA/NetOwn", true,
            function(v)
                AACFG.networkOwn = v
            end
        )
    end

    do -- vel desync
        local S = Page:Section({Name = "vel desync", Side = 2})
        Toggle(
            S, "enabled", "VD/Enabled", false,
            function(v)
                VDCFG.enabled = v
                if v then
                    startVelDesync()
                else
                    stopVelDesync()
                end
            end
        )
        Slider(
            S, "intensity", "VD/Intensity", 1, 100, 50, 1, "%",
            function(v)
                VDCFG.intensity = v
            end
        )
        Slider(
            S, "speed", "VD/Speed", 1, 100, 10, 1, "",
            function(v)
                VDCFG.speed = v
            end
        )
        Slider(
            S, "angle", "VD/Angle", -180, 180, 90, 5, "°",
            function(v)
                VDCFG.angle = v
            end
        )
        Slider(
            S, "jitter", "VD/Jitter", 0, 180, 20, 5, "°",
            function(v)
                VDCFG.jitter = v
            end
        )
        S:Divider()
        Toggle(
            S, "flip direction", "VD/Flip", false,
            function(v)
                VDCFG.flip = v
            end
        )
        Toggle(
            S, "oscillate", "VD/Osc", false,
            function(v)
                VDCFG.oscillate = v
            end
        )
        Slider(
            S, "osc freq", "VD/OscFreq", 0.1, 10, 2, 0.1, " Hz",
            function(v)
                VDCFG.oscillateFreq = v
            end
        )
        Slider(
            S, "osc amp", "VD/OscAmp", 1, 180, 30, 1, "°",
            function(v)
                VDCFG.oscillateAmp = v
            end
        )
        Toggle(
            S, "spike mode", "VD/Spike", false,
            function(v)
                VDCFG.spikeMode = v
            end
        )
        Slider(
            S, "spike mag", "VD/SpikeMag", 1000, 500000, 50000, 1000, "",
            function(v)
                VDCFG.spikeMag = v
            end
        )
        Slider(
            S, "spike interval", "VD/SpikeInt", 0.1, 2, 0.5, 0.05, " s",
            function(v)
                VDCFG.spikeInterval = v
            end
        )
        S:Divider()
        Toggle(
            S, "multi vector", "VD/MultiVec", false,
            function(v)
                VDCFG.multiVector = v
            end
        )
        Slider(
            S, "vector count", "VD/VecCount", 1, 8, 3, 1, "",
            function(v)
                VDCFG.vectorCount = v
            end
        )
        Toggle(
            S, "counter vel", "VD/CounterVel", false,
            function(v)
                VDCFG.counterVel = v
            end
        )
        Toggle(
            S, "noise", "VD/Noise", false,
            function(v)
                VDCFG.noiseVel = v
            end
        )
        S:Divider()
        Toggle(
            S, "no clip", "VD/NoClip", true,
            function(v)
                VDCFG.noClip = v
            end
        )
        Toggle(
            S, "net owner", "VD/NetOwn", true,
            function(v)
                VDCFG.networkOwn = v
            end
        )
    end
end

-- ─────────────────────────────────────────────────────────────
--  PAGE: transloc (fake-pos translocation)
-- ─────────────────────────────────────────────────────────────
do
    local Page = PageTransloc

    do
        local S = Page:Section({Name = "translocation", Side = 1})
        Toggle(
            S, "enabled", "TL/Enabled", false,
            function(v)
                TLCFG.enabled = v
                if v then
                    startTransloc()
                else
                    stopTransloc()
                end
            end
        )
        Slider(
            S, "frequency", "TL/Freq", 1, 500, 256, 1, " Hz",
            function(v)
                TLCFG.frequency = v
            end
        )
        Slider(
            S, "offset dist", "TL/Dist", 1, 1000, 999, 1, "e9",
            function(v)
                TLCFG.offsetDist = v * 1e9
            end
        )
        Dropdown(
            S, "offset mode", "TL/Mode",
            {"ahead", "behind", "above", "below", "diagonal", "random"}, "ahead",
            function(v)
                TLCFG.offsetMode = v
            end
        )
        Slider(
            S, "offset y", "TL/OffY", -100, 100, 0, 1, " st",
            function(v)
                TLCFG.offsetY = v
            end
        )
        Slider(
            S, "diagonal angle", "TL/DiagAng", -180, 180, 45, 5, "°",
            function(v)
                TLCFG.diagonalAngle = v
            end
        )
        Slider(
            S, "layers", "TL/Layers", 1, 20, 5, 1, "",
            function(v)
                TLCFG.layers = v
            end
        )
        S:Divider()
        Toggle(
            S, "fake velocity", "TL/FakeVel", true,
            function(v)
                TLCFG.fakeVel = v
            end
        )
        Slider(
            S, "fake vel mag", "TL/FakeVelMag", 1, 100, 10, 1, "e9",
            function(v)
                TLCFG.fakeVelMag = v * 1e9
            end
        )
        Toggle(
            S, "snap back", "TL/Snap", true,
            function(v)
                TLCFG.snapBack = v
            end
        )
        Toggle(
            S, "jitter", "TL/Jitter", true,
            function(v)
                TLCFG.jitter = v
            end
        )
        Slider(
            S, "jitter amp", "TL/JitterAmp", 1, 100, 100, 1, "e9",
            function(v)
                TLCFG.jitterAmp = v * 1e9
            end
        )
        S:Divider()
        Toggle(
            S, "burst mode", "TL/Burst", false,
            function(v)
                TLCFG.burstMode = v
            end
        )
        Slider(
            S, "burst count", "TL/BurstCount", 1, 50, 10, 1, "",
            function(v)
                TLCFG.burstCount = v
            end
        )
        Slider(
            S, "burst interval", "TL/BurstInt", 0.001, 0.1, 0.001, 0.001, " s",
            function(v)
                TLCFG.burstInterval = v
            end
        )
    end

    do
        local S = Page:Section({Name = "transloc options", Side = 2})
        Toggle(
            S, "no clip", "TL/NoClip", true,
            function(v)
                TLCFG.noClip = v
            end
        )
        Toggle(
            S, "anti-fling", "TL/AntiFl", true,
            function(v)
                TLCFG.antiFling = v
            end
        )
        Toggle(
            S, "vel zero", "TL/VelZero", true,
            function(v)
                TLCFG.velZero = v
            end
        )
        Toggle(
            S, "massless", "TL/Mass", true,
            function(v)
                TLCFG.massless = v
            end
        )
        Toggle(
            S, "net owner fix", "TL/NetOwn", true,
            function(v)
                TLCFG.networkOwnerFix = v
            end
        )
        S:Divider()
        Toggle(
            S, "auto dodge nearby", "TL/AutoDodge", false,
            function(v)
                TLCFG.autoDodge = v
            end
        )
        Slider(
            S, "auto dodge radius", "TL/DodgeRad", 10, 500, 60, 5, " st",
            function(v)
                TLCFG.autoDodgeRadius = v
            end
        )
    end
end

-- ─────────────────────────────────────────────────────────────
--  BOOT
-- ─────────────────────────────────────────────────────────────
Window:Init()
Library.MainWindow = Window
getgenv().Library = Library
Library:Notification({Name = "hiatus.cc", Description = "loaded and ready", Duration = 3})
return Library
