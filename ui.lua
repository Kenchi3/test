--[[
    Fluent UI Library (Rewritten based on dawid-scripts/Fluent structure)
    Style: Windows 11
    API Compatibility: Similar to dawid-scripts/Fluent
]]

local Fluent = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- // WINDOWS 11 THEME // --
local Theme = {
    Background = Color3.fromRGB(25, 25, 25),
    Surface = Color3.fromRGB(32, 32, 32), -- Sidebar / Cards
    SurfaceHover = Color3.fromRGB(45, 45, 45),
    Element = Color3.fromRGB(38, 38, 38),
    
    Accent = Color3.fromRGB(0, 120, 212),
    AccentHover = Color3.fromRGB(24, 134, 224),
    
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(60, 60, 60)
}

-- // UTILITIES // --
local function Create(instance, properties, children)
    local inst = Instance.new(instance)
    for prop, val in pairs(properties) do inst[prop] = val end
    if children then for _, child in pairs(children) do child.Parent = inst end end
    return inst
end

local function Ripple(button)
    -- Simple hover effect replacement since ripple is complex for single file
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SurfaceHover}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Surface}):Play()
    end)
end

-- // WINDOW CLASS // --
function Fluent:CreateWindow(Config)
    local Window = {}
    Window.Name = Config.Name or "Fluent"
    Window.Tabs = {}
    
    -- UI Construction
    local ScreenGui = Create("ScreenGui", {
        Name = "FluentWin11_" .. tostring(math.random(1000,9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = CoreGui
    })
    
    local MainFrame = Create("Frame", {
        Size = UDim2.new(0, 800, 0, 500),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = Theme.Background,
        Parent = ScreenGui
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Create("UIStroke", {Color = Theme.Border}),
        
        -- Sidebar
        Create("Frame", {
            Name = "Sidebar",
            Size = UDim2.new(0, 200, 1, 0),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("Frame", {Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, 0), BackgroundColor3 = Theme.Surface}), -- Mask
            Create("UIPadding", {PaddingTop = UDim.new(0, 50)}),
            Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
        }),
        
        -- Title Bar
        Create("Frame", {
            Name = "TitleBar",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0
        }, {
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                Text = "  " .. Window.Name,
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("TextButton", {
                Name = "Close",
                Size = UDim2.new(0, 40, 1, 0),
                Position = UDim2.new(1, -40, 0, 0),
                BackgroundTransparency = 1,
                Text = "✕",
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            })
        }),
        
        -- Content Container
        Create("Frame", {
            Name = "Content",
            Position = UDim2.new(0, 200, 0, 40),
            Size = UDim2.new(1, -200, 1, -40),
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1
        })
    })

    -- Draggable
    local dragging, dragInput, mousePos, framePos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; mousePos = input.Position; framePos = MainFrame.Position
        end
    end)
    MainFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    -- Close Button
    MainFrame.TitleBar.Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    MainFrame.TitleBar.Close.MouseEnter:Connect(function() TweenService:Create(MainFrame.TitleBar.Close, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end)
    MainFrame.TitleBar.Close.MouseLeave:Connect(function() TweenService:Create(MainFrame.TitleBar.Close, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end)

    Window.UI = ScreenGui
    Window.Frame = MainFrame
    Window.Sidebar = MainFrame.Sidebar
    Window.Content = MainFrame.Content
    
    -- Notification System
    function Window:Notify(Config)
        local Notify = Create("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -15, 1, -15),
            Size = UDim2.new(0, 350, 0, 0),
            BackgroundColor3 = Theme.Surface,
            Parent = ScreenGui
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Create("UIStroke", {Color = Theme.Border}),
            Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)}),
            Create("UIListLayout", {}),
            Create("TextLabel", {Text = Config.Title or "Notification", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 15, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}),
            Create("TextLabel", {Text = Config.Content or "", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 14, Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left})
        })
        
        TweenService:Create(Notify, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 350, 0, 85)}):Play()
        task.delay(Config.Duration or 5, function()
            TweenService:Create(Notify, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 0)}):Play()
            task.wait(0.3); Notify:Destroy()
        end)
    end

    -- Modal System
    function Window:Dialog(Config)
        local Overlay = Create("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.6, ZIndex = 100, Parent = ScreenGui})
        local Modal = Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 400, 0, 0),
            BackgroundColor3 = Theme.Surface, ZIndex = 101, Parent = Overlay
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {Color = Theme.Border}),
            Create("UIPadding", {PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)}),
            Create("UIListLayout", {Padding = UDim.new(0, 10)}),
            Create("TextLabel", {Text = Config.Title or "Dialog", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 18, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}),
            Create("TextLabel", {Text = Config.Content or "", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 14, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}),
            Create("Frame", {Name = "Btns", Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1}, {
                Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 10)})
            })
        })
        
        -- Buttons
        for _, BtnConfig in pairs(Config.Buttons or {}) do
            local Style = BtnConfig.Style or "Secondary"
            local Btn = Create("TextButton", {
                Size = UDim2.new(0, 80, 1, 0),
                BackgroundColor3 = Style == "Primary" and Theme.Accent or Theme.Background,
                Text = BtnConfig.Text, TextColor3 = Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 14,
                Parent = Modal.Btns
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Create("UIStroke", {Color = Style == "Primary" and Theme.Accent or Theme.Border})})
            
            Btn.MouseButton1Click:Connect(function()
                if BtnConfig.Callback then BtnConfig.Callback() end
                TweenService:Create(Modal, TweenInfo.new(0.2), {Size = UDim2.new(0, 400, 0, 0)}):Play()
                task.wait(0.2); Overlay:Destroy()
            end)
        end
        
        TweenService:Create(Modal, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 400, 0, 150)}):Play()
    end

    return Window
end

-- // TAB CLASS // --
function Fluent:AddTab(Window, Name)
    local Tab = {}
    Tab.Name = Name
    Tab.Sections = {}
    
    -- Tab Button
    local TabBtn = Create("TextButton", {
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "    " .. Name,
        TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = Theme.Surface,
        Parent = Window.Sidebar
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    
    -- Page Container
    local Page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = Window.Content
    }, {
        Create("UIPadding", {PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 15)}),
        Create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder})
    })

    -- Logic
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Window.Tabs) do
            v.Button.BackgroundTransparency = 1
            v.Button.TextColor3 = Theme.SubText
            v.Page.Visible = false
        end
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.Text
        Page.Visible = true
    end)
    
    Ripple(TabBtn)
    
    table.insert(Window.Tabs, {Button = TabBtn, Page = Page})
    
    -- Auto-select if first tab
    if #Window.Tabs == 1 then
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.Text
        Page.Visible = true
    end
    
    Tab.Parent = Page
    Tab.Window = Window
    return Tab
end

-- // SECTION CLASS // --
function Fluent:AddSection(Tab, Name)
    local Section = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Surface,
        Parent = Tab.Parent
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Create("UIStroke", {Color = Theme.Border}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 30), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)}),
        Create("UIListLayout", {Padding = UDim.new(0, 10)}),
        Create("TextLabel", {Text = Name, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 16, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 15, 0, 8), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left})
    })
    return Section
end

-- // ELEMENTS // --

function Fluent:AddButton(Parent, Config)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Accent,
        Text = Config.Name or "Button",
        TextColor3 = Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 14,
        Parent = Parent
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    
    Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.AccentHover}):Play() end)
    Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play() end)
    Button.MouseButton1Click:Connect(function() if Config.Callback then Config.Callback() end end)
    return Button
end

function Fluent:AddToggle(Parent, Config)
    local State = Config.Default or false
    local Toggle = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = Parent
    }, {
        Create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Text = Config.Name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}),
        Create("TextButton", {Name = "Switch", Size = UDim2.new(0, 44, 0, 22), Position = UDim2.new(1, -44, 0.5, -11), BackgroundColor3 = Theme.Border, Text = ""}, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("Frame", {Name = "Dot", Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
        })
    })
    
    local function Update()
        if State then
            TweenService:Create(Toggle.Switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
            TweenService:Create(Toggle.Switch.Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
        else
            TweenService:Create(Toggle.Switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Border}):Play()
            TweenService:Create(Toggle.Switch.Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
        end
        if Config.Callback then Config.Callback(State) end
    end
    
    Toggle.Switch.MouseButton1Click:Connect(function() State = not State Update() end)
    Update()
end

function Fluent:AddSlider(Parent, Config)
    local Val = Config.Default or Config.Min or 0
    local Slider = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Parent = Parent
    }, {
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 20), Text = Config.Name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}),
        Create("TextLabel", {Name = "Val", Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -40, 0, 0), Text = tostring(Val), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, BackgroundTransparency = 1}),
        Create("Frame", {Name = "Track", Position = UDim2.new(0, 0, 1, -18), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = Theme.Border}, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("Frame", {Name = "Fill", Size = UDim2.new((Val-(Config.Min or 0))/((Config.Max or 100)-(Config.Min or 0)), 0, 1, 0), BackgroundColor3 = Theme.Accent}, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})}),
            Create("TextButton", {Name = "Hit", Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.5, -10), BackgroundTransparency = 1, Text = ""})
        })
    })
    
    Slider.Track.Hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn; conn = RunService.RenderStepped:Connect(function()
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() return end
                local rel = math.clamp((input.Position.X - Slider.Track.AbsolutePosition.X) / Slider.Track.AbsoluteSize.X, 0, 1)
                Val = math.floor((Config.Min or 0) + ((Config.Max or 100) - (Config.Min or 0)) * rel)
                Slider.Track.Fill.Size = UDim2.new(rel, 0, 1, 0)
                Slider.Val.Text = tostring(Val)
                if Config.Callback then Config.Callback(Val) end
            end)
        end
    end)
end

function Fluent:AddDropdown(Parent, Config)
    local List = Config.Options or {}
    local Current = Config.Default or List[1]
    local Open = false
    
    local Drop = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = Parent, ClipsDescendants = false, ZIndex = 50
    }, {
        Create("TextButton", {Name = "Main", Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Background, Text = "  "..Config.Name..": "..Current, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 50}, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Create("UIStroke", {Color = Theme.Border}),
            Create("TextLabel", {Text = "▾", Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -25, 0, 0), TextColor3 = Theme.SubText, BackgroundTransparency = 1})
        }),
        Create("Frame", {Name = "List", Position = UDim2.new(0, 0, 0, 42), Size = UDim2.new(1, 0, 0, #List * 34), BackgroundColor3 = Theme.Surface, Visible = false, ZIndex = 60}, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Create("UIStroke", {Color = Theme.Border}),
            Create("UIListLayout", {Padding = UDim.new(0, 2)})
        })
    })
    
    Drop.Main.MouseButton1Click:Connect(function() Open = not Open Drop.List.Visible = Open end)
    
    for _, v in pairs(List) do
        local Item = Create("TextButton", {
            Text = "  "..v, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.Surface, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 61, Parent = Drop.List
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
        Item.MouseButton1Click:Connect(function()
            Current = v; Drop.Main.Text = "  "..Config.Name..": "..v; Open = false; Drop.List.Visible = false
            if Config.Callback then Config.Callback(v) end
        end)
    end
end

function Fluent:AddInput(Parent, Config)
    local Input = Create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Parent = Parent}, {
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 20), Text = Config.Name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}),
        Create("TextBox", {
            Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 32), PlaceholderText = Config.Placeholder, Text = "", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14,
            PlaceholderColor3 = Theme.SubText, BackgroundColor3 = Theme.Background
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Create("UIStroke", {Color = Theme.Border})})
    })
    Input.TextBox.FocusLost:Connect(function() if Config.Callback then Config.Callback(Input.TextBox.Text) end end)
end

function Fluent:AddKeybind(Parent, Config)
    local Binding = false
    local Key = Config.Default or Enum.KeyCode.Unknown
    local Bind = Create("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = Parent}, {
        Create("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Text = Config.Name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left}),
        Create("TextButton", {Name = "Btn", Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -70, 0, 0), BackgroundColor3 = Theme.Background, Text = Key.Name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14}, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)}), Create("UIStroke", {Color = Theme.Border})
        })
    })
    
    Bind.Btn.MouseButton1Click:Connect(function()
        Binding = true
        Bind.Btn.Text = "..."
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if Binding then
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                Key = input.KeyCode
                Bind.Btn.Text = Key.Name
                Binding = false
                if Config.Callback then Config.Callback(Key) end
            end
        elseif not gp and input.KeyCode == Key then
            if Config.Callback then Config.Callback(Key) end
        end
    end)
end

return Fluent