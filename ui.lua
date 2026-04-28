--[[
    Fluent UI Library (Windows 11 Style) - V3
    Features: Modal Dialogs, Secondary Buttons, Refined Inputs, Sidebar Navigation
]]

local FluentLibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- // THEME (Accurate to Modern Fluent UI) // --
local Theme = {
    Background = Color3.fromRGB(32, 32, 32), -- Main Window BG
    Sidebar = Color3.fromRGB(25, 25, 25), -- Darker Sidebar
    Card = Color3.fromRGB(44, 44, 44), -- Surface / Card Background
    CardHover = Color3.fromRGB(55, 55, 55),
    
    Accent = Color3.fromRGB(0, 120, 212), -- Standard Blue
    AccentHover = Color3.fromRGB(20, 140, 230),
    AccentPress = Color3.fromRGB(0, 90, 170),
    
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Placeholder = Color3.fromRGB(120, 120, 120),
    
    Border = Color3.fromRGB(60, 60, 60), -- Subtle Grey Border
    InputBorder = Color3.fromRGB(80, 80, 80), -- Lighter border for inputs
}

local function Create(instance, properties, children)
    local inst = Instance.new(instance)
    for prop, val in pairs(properties) do
        inst[prop] = val
    end
    if children then
        for _, child in pairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, mousePos, framePos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- // WINDOW // --
function FluentLibrary:CreateWindow(title)
    if CoreGui:FindFirstChild("FluentUI_V3") then CoreGui:FindFirstChild("FluentUI_V3"):Destroy() end

    local ScreenGui = Create("ScreenGui", {
        Name = "FluentUI_V3",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })

    -- Main Window
    local MainFrame = Create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 800, 0, 500),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
        
        -- Sidebar
        Create("Frame", {
            Name = "Sidebar",
            Size = UDim2.new(0, 220, 1, 0),
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("Frame", { -- Mask right
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundColor3 = Theme.Sidebar,
                BorderSizePixel = 0
            }),
            Create("UIPadding", {PaddingTop = UDim.new(0, 50)}),
            Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
        }),

        -- Title Bar
        Create("Frame", {
            Name = "TitleBar",
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        }, {
            Create("TextLabel", {
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                Text = "  " .. (title or "Task Manager"),
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("TextButton", {
                Name = "Close",
                Size = UDim2.new(0, 46, 1, 0),
                Position = UDim2.new(1, -46, 0, 0),
                BackgroundTransparency = 1,
                Text = "✕",
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            })
        }),

        -- Content
        Create("Frame", {
            Name = "ContentArea",
            Position = UDim2.new(0, 220, 0, 38),
            Size = UDim2.new(1, -220, 1, -38),
            BackgroundColor3 = Theme.Background,
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        }, {
            Create("ScrollingFrame", {
                Name = "Container",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 6,
                ScrollBarImageColor3 = Theme.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y
            }, {
                Create("UIPadding", {PaddingTop = UDim.new(0, 25), PaddingLeft = UDim.new(0, 30), PaddingRight = UDim.new(0, 30), PaddingBottom = UDim.new(0, 25)}),
                Create("UIListLayout", {Padding = UDim.new(0, 20), SortOrder = Enum.SortOrder.LayoutOrder})
            })
        })
    })

    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = CoreGui
    
    MakeDraggable(MainFrame, MainFrame.TitleBar)
    
    -- Close Logic
    local CloseBtn = MainFrame.TitleBar.Close
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70), BackgroundTransparency = 0}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local WindowData = {
        GUI = ScreenGui,
        Frame = MainFrame,
        Sidebar = MainFrame.Sidebar,
        Container = MainFrame.ContentArea.Container,
        Tabs = {}
    }
    
    -- // MODAL SYSTEM (New Feature) // --
    function WindowData:Modal(config)
        -- Background Overlay
        local Overlay = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.6,
            ZIndex = 100,
            Parent = ScreenGui
        })
        
        -- Modal Box
        local ModalFrame = Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 400, 0, 0), -- Auto Y
            BackgroundColor3 = Theme.Card,
            BorderSizePixel = 0,
            ZIndex = 101,
            Parent = Overlay
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {Color = Theme.Border}),
            Create("UIPadding", {PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20)}),
            Create("UIListLayout", {Padding = UDim.new(0, 15), SortOrder = Enum.SortOrder.LayoutOrder}),
            -- Title
            Create("TextLabel", {
                Text = config.Title or "Dialog",
                TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 18,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            }),
            -- Content
            Create("TextLabel", {
                Text = config.Content or "Are you sure?",
                TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 14,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left
            }),
            -- Buttons Container
            Create("Frame", {
                Name = "Btns",
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1
            }, {
                Create("UIListLayout", {Padding = UDim.new(0, 10), FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right})
            })
        })
        
        -- Add Buttons
        for _, btnData in pairs(config.Buttons or {}) do
            local style = btnData.Style or "Secondary" -- Default to Secondary
            local Btn = Create("TextButton", {
                Size = UDim2.new(0, 100, 0, 32),
                BackgroundColor3 = style == "Primary" and Theme.Accent or Theme.Background,
                Text = btnData.Text or "OK",
                TextColor3 = Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 14,
                AutoButtonColor = false,
                BackgroundTransparency = 0
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                Create("UIStroke", {Color = style == "Primary" and Theme.Accent or Theme.Border, Thickness = 1})
            })
            Btn.Parent = ModalFrame.Btns
            
            Btn.MouseButton1Click:Connect(function()
                if btnData.Callback then btnData.Callback() end
                TweenService:Create(ModalFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 400, 0, 0)}):Play()
                TweenService:Create(Overlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                task.wait(0.2)
                Overlay:Destroy()
            end)
        end
        
        -- Animate In
        TweenService:Create(ModalFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 180)}):Play()
    end

    function WindowData:Notify(title, desc, duration)
        duration = duration or 5
        local Notify = Create("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.new(0, 360, 0, 0),
            BackgroundColor3 = Theme.Card,
            Parent = ScreenGui
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Create("UIStroke", {Color = Theme.Border}),
            Create("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 12)}),
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}),
            Create("TextLabel", {
                Text = title, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 15,
                Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("TextLabel", {
                Text = desc, TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 13,
                Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left
            })
        })
        
        TweenService:Create(Notify, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 360, 0, 85)}):Play()
        task.delay(duration, function()
            TweenService:Create(Notify, TweenInfo.new(0.3), {Size = UDim2.new(0, 360, 0, 0)}):Play()
            task.wait(0.3)
            Notify:Destroy()
        end)
    end

    return WindowData
end

-- // TAB // --
function FluentLibrary:CreateTab(WindowData, name)
    local TabBtn = Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "    " .. name,
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = Theme.Card,
        AutoButtonColor = false,
        Parent = WindowData.Sidebar
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    })

    local Page = Create("ScrollingFrame", {
        Name = name.."_Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        Visible = false,
        Parent = WindowData.Container
    }, {
        Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
    })

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(WindowData.Tabs) do
            v.Btn.BackgroundTransparency = 1
            v.Btn.TextColor3 = Theme.SubText
            v.Page.Visible = false
        end
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.Text
        Page.Visible = true
    end)

    TabBtn.MouseEnter:Connect(function() 
        if TabBtn.BackgroundTransparency == 1 then TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play() end
    end)
    TabBtn.MouseLeave:Connect(function() 
        if TabBtn.BackgroundTransparency == 1 then TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Theme.SubText}):Play() end
    end)

    table.insert(WindowData.Tabs, {Btn = TabBtn, Page = Page})

    if #WindowData.Tabs == 1 then
        TabBtn.BackgroundTransparency = 0
        TabBtn.TextColor3 = Theme.Text
        Page.Visible = true
    end

    return {Page = Page}
end

-- // SECTION // --
function FluentLibrary:CreateSection(TabData, name)
    return Create("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0,
        Parent = TabData.Page
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 35), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 15)}),
        Create("UIListLayout", {Padding = UDim.new(0, 12)}),
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 20, 0, 10),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
end

-- // ELEMENTS // --

-- Button (Supports Primary & Secondary)
function FluentLibrary:CreateButton(Parent, text, style, callback)
    -- style: "Primary" (Blue) or "Secondary" (Grey Border)
    local isPrimary = style == "Primary" or style == nil
    
    local Btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = isPrimary and Theme.Accent or Theme.Background,
        Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.GothamSemibold, TextSize = 14,
        AutoButtonColor = false,
        BackgroundTransparency = 0,
        Parent = Parent
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Create("UIStroke", {Color = isPrimary and Theme.Accent or Theme.InputBorder, Thickness = 1})
    })
    
    Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = isPrimary and Theme.AccentHover or Theme.CardHover}):Play() end)
    Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = isPrimary and Theme.Accent or Theme.Background}):Play() end)
    Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

-- Toggle (Pill)
function FluentLibrary:CreateToggle(Parent, text, default, callback)
    local val = default or false
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = Parent
    }, {
        Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Text = text, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        }),
        Create("TextButton", {
            Name = "Switch",
            Size = UDim2.new(0, 44, 0, 22),
            Position = UDim2.new(1, -44, 0.5, -11),
            BackgroundColor3 = Theme.Border,
            AutoButtonColor = false,
            Text = "",
            Parent = Parent
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("Frame", {
                Name = "Dot",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
        })
    })
    
    Frame.Switch.Parent = Frame
    local Switch = Frame.Switch
    local Dot = Switch.Dot

    local function Update()
        if val then
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Border}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
        end
        if callback then callback(val) end
    end

    Switch.MouseButton1Click:Connect(function() val = not val Update() end)
    Update()
end

-- Slider
function FluentLibrary:CreateSlider(Parent, text, min, max, default, callback)
    local val = default or min
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = Parent
    }, {
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Text = text, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        }),
        Create("TextLabel", {
            Name = "Val",
            Size = UDim2.new(0, 50, 0, 20),
            Position = UDim2.new(1, -50, 0, 0),
            Text = tostring(val), TextColor3 = Theme.Accent,
            Font = Enum.Font.GothamBold, TextSize = 14,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right
        }),
        Create("Frame", {
            Name = "Track",
            Position = UDim2.new(0, 0, 1, -18),
            Size = UDim2.new(1, 0, 0, 4),
            BackgroundColor3 = Theme.Border,
            BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("Frame", {
                Name = "Fill",
                Size = UDim2.new((val-min)/(max-min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            }),
            Create("TextButton", {
                Name = "Input",
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0.5, -10),
                BackgroundTransparency = 1,
                Text = ""
            })
        })
    })

    local Track = Frame.Track
    local Fill = Track.Fill
    local Input = Track.Input

    local function UpdateSlider(input)
        local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * rel)
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        Frame.Val.Text = tostring(val)
        if callback then callback(val) end
    end

    Input.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            UpdateSlider(input)
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() return end
                UpdateSlider(input)
            end)
        end
    end)
end

-- Dropdown (Modal Style Dropdown)
function FluentLibrary:CreateDropdown(Parent, text, list, default, callback)
    local val = default or list[1]
    local open = false
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        Parent = Parent,
        ClipsDescendants = false,
        ZIndex = 10
    }, {
        Create("TextButton", {
            Name = "Main",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.Background,
            Text = "  "..text..": "..val,
            TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex = 10
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Create("UIStroke", {Color = Theme.InputBorder}),
            Create("TextLabel", {
                Text = "▾", Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -25, 0, 0),
                TextColor3 = Theme.SubText, BackgroundTransparency = 1, TextSize = 14
            })
        }),
        Create("Frame", {
            Name = "List",
            Position = UDim2.new(0, 0, 0, 42),
            Size = UDim2.new(1, 0, 0, #list * 36),
            BackgroundColor3 = Theme.Card,
            Visible = false,
            BorderSizePixel = 0,
            ZIndex = 15
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Create("UIStroke", {Color = Theme.InputBorder}),
            Create("UIListLayout", {Padding = UDim.new(0, 2)})
        })
    })
    
    Frame.List.ZIndex = 15
    Frame.Main.ZIndex = 10

    Frame.Main.MouseButton1Click:Connect(function()
        open = not open
        Frame.List.Visible = open
    end)

    for _, v in pairs(list) do
        local Item = Create("TextButton", {
            Text = "  "..v, Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Theme.Card,
            TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14,
            AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Frame.List,
            ZIndex = 16
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        })
        Item.MouseEnter:Connect(function() TweenService:Create(Item, TweenInfo.new(0.1), {BackgroundColor3 = Theme.CardHover}):Play() end)
        Item.MouseLeave:Connect(function() TweenService:Create(Item, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Card}):Play() end)
        
        Item.MouseButton1Click:Connect(function()
            val = v
            Frame.Main.Text = "  "..text..": "..v
            open = false
            Frame.List.Visible = false
            if callback then callback(v) end
        end)
    end
end

-- Input
function FluentLibrary:CreateInput(Parent, text, placeholder, callback)
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1, Parent = Parent
    }, {
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Text = text, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14,
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        }),
        Create("TextBox", {
            Position = UDim2.new(0, 0, 0, 25),
            Size = UDim2.new(1, 0, 0, 34),
            PlaceholderText = placeholder or "...",
            Text = "", TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14,
            PlaceholderColor3 = Theme.Placeholder,
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Create("UIStroke", {Color = Theme.InputBorder})
        })
    })
    Frame.TextBox.FocusLost:Connect(function() if callback then callback(Frame.TextBox.Text) end end)
end

return FluentLibrary