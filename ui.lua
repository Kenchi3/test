--[[
    Fluent UI Library (Windows 11 Style) - Module
    Fixed: Changed Font to Gotham (Roblox Standard)
]]

local FluentLibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- // WINDOWS 11 THEME PALETTE // --
local Theme = {
    Background = Color3.fromRGB(32, 32, 32),
    Sidebar = Color3.fromRGB(25, 25, 25),
    ElementBG = Color3.fromRGB(45, 45, 45),
    HoverBG = Color3.fromRGB(55, 55, 55),
    Accent = Color3.fromRGB(0, 120, 212),
    AccentLight = Color3.fromRGB(85, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Placeholder = Color3.fromRGB(120, 120, 120),
    Border = Color3.fromRGB(60, 60, 60),
    Red = Color3.fromRGB(255, 70, 70)
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
    local dragging, dragInput, mousePos, framePos = false
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
    if CoreGui:FindFirstChild("FluentHub_Win11") then CoreGui:FindFirstChild("FluentHub_Win11"):Destroy() end

    local ScreenGui = Create("ScreenGui", {
        Name = "FluentHub_Win11",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })

    local MainFrame = Create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 720, 0, 480),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Create("UIStroke", {Color = Theme.Border, Thickness = 1}),
        
        Create("Frame", {
            Name = "Sidebar",
            Size = UDim2.new(0, 200, 1, 0),
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("Frame", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundColor3 = Theme.Sidebar,
                BorderSizePixel = 0
            }),
            Create("UIPadding", {PaddingTop = UDim.new(0, 40)}),
            Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
        }),

        Create("Frame", {
            Name = "TitleBar",
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = 0,
            BorderSizePixel = 0
        }, {
            Create("TextLabel", {
                Name = "TitleText",
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                Text = "  " .. (title or "Windows 11 Hub"),
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham, -- Fixed Font
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1
            }),
            Create("TextButton", {
                Name = "Close",
                Size = UDim2.new(0, 46, 1, 0),
                Position = UDim2.new(1, -46, 0, 0),
                BackgroundTransparency = 1,
                Text = "✕",
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham, -- Fixed Font
                TextSize = 14,
                BackgroundColor3 = Theme.Red
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 0)})
            })
        }),

        Create("Frame", {
            Name = "ContentArea",
            Position = UDim2.new(0, 200, 0, 32),
            Size = UDim2.new(1, -200, 1, -32),
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
                Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)}),
                Create("UIListLayout", {Padding = UDim.new(0, 15), SortOrder = Enum.SortOrder.LayoutOrder})
            })
        })
    })

    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = CoreGui
    
    MakeDraggable(MainFrame, MainFrame.TitleBar)
    
    local CloseBtn = MainFrame.TitleBar.Close
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Red, BackgroundTransparency = 0}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local WindowData = {
        GUI = ScreenGui,
        Frame = MainFrame,
        Sidebar = MainFrame.Sidebar,
        Container = MainFrame.ContentArea.Container,
        Tabs = {}
    }

    function WindowData:Notify(title, desc, duration)
        duration = duration or 5
        local Notify = Create("Frame", {
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -15, 1, -15),
            Size = UDim2.new(0, 350, 0, 0),
            BackgroundColor3 = Theme.ElementBG,
            Parent = ScreenGui
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Create("UIStroke", {Color = Theme.Border}),
            Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 10)}),
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
        
        Notify.Size = UDim2.new(0, 350, 0, 0)
        TweenService:Create(Notify, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 350, 0, 80)}):Play()
        
        task.delay(duration, function()
            TweenService:Create(Notify, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 0)}):Play()
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
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "    " .. name,
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham, -- Fixed Font
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = Theme.HoverBG,
        AutoButtonColor = false,
        Parent = WindowData.Sidebar
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 4)})
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
        Create("UIListLayout", {Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder})
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
        BackgroundColor3 = Theme.ElementBG,
        BorderSizePixel = 0,
        Parent = TabData.Page
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        Create("UIStroke", {Color = Theme.Border}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 30), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15)}),
        Create("UIListLayout", {Padding = UDim.new(0, 10)}),
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 15, 0, 8),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBold, -- Fixed Font
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    })
end

-- // ELEMENTS // --

function FluentLibrary:CreateButton(Parent, text, callback)
    local Btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.Accent,
        Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 14, -- Fixed Font
        AutoButtonColor = false,
        BackgroundTransparency = 0,
        Parent = Parent
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 4)})
    })
    Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.AccentLight}):Play() end)
    Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play() end)
    Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
end

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
            Font = Enum.Font.Gotham, TextSize = 14, -- Fixed Font
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        }),
        Create("TextButton", {
            Name = "Switch",
            Size = UDim2.new(0, 44, 0, 20),
            Position = UDim2.new(1, -44, 0.5, -10),
            BackgroundColor3 = Theme.Border,
            AutoButtonColor = false,
            Text = "",
            Parent = Parent -- Corrected parent
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("Frame", {
                Name = "Dot",
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, 4, 0.5, -6),
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel = 0
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
        })
    })
    
    -- Reparent Switch because Create function puts children into Frame
    Frame.Switch.Parent = Frame

    local Switch = Frame.Switch
    local Dot = Switch.Dot

    local function Update()
        if val then
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -6)}):Play()
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Border}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.5, -6)}):Play()
        end
        if callback then callback(val) end
    end

    Switch.MouseButton1Click:Connect(function() val = not val Update() end)
    Update()
end

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
            Font = Enum.Font.Gotham, TextSize = 14, -- Fixed Font
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        }),
        Create("TextLabel", {
            Name = "Val",
            Size = UDim2.new(0, 50, 0, 20),
            Position = UDim2.new(1, -50, 0, 0),
            Text = tostring(val), TextColor3 = Theme.Accent,
            Font = Enum.Font.GothamBold, TextSize = 14, -- Fixed Font
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Right
        }),
        Create("TextButton", {
            Name = "Track",
            Position = UDim2.new(0, 0, 1, -10),
            Size = UDim2.new(1, 0, 0, 4),
            BackgroundColor3 = Theme.Border,
            Text = "", AutoButtonColor = false,
            BackgroundTransparency = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("Frame", {
                Name = "Fill",
                Size = UDim2.new((val-min)/(max-min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
        })
    })

    local Track = Frame.Track
    local Fill = Track.Fill

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn
            conn = RunService.RenderStepped:Connect(function()
                if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() return end
                local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * rel)
                Fill.Size = UDim2.new(rel, 0, 1, 0)
                Frame.Val.Text = tostring(val)
                if callback then callback(val) end
            end)
        end
    end)
end

function FluentLibrary:CreateInput(Parent, text, placeholder, callback)
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1, Parent = Parent
    }, {
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Text = text, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14, -- Fixed Font
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        }),
        Create("TextBox", {
            Position = UDim2.new(0, 0, 0, 25),
            Size = UDim2.new(1, 0, 0, 30),
            PlaceholderText = placeholder or "...",
            Text = "", TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14, -- Fixed Font
            PlaceholderColor3 = Theme.Placeholder,
            BackgroundColor3 = Theme.Sidebar,
            BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        })
    })
    Frame.TextBox.FocusLost:Connect(function() if callback then callback(Frame.TextBox.Text) end end)
end

function FluentLibrary:CreateParagraph(Parent, text)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = text, TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham, TextSize = 13, -- Fixed Font
        BackgroundTransparency = 1, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Parent
    })
end

function FluentLibrary:CreateDropdown(Parent, text, list, default, callback)
    local val = default or list[1]
    local open = false
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = Parent,
        ClipsDescendants = true
    }, {
        Create("TextButton", {
            Name = "Main",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Theme.Sidebar,
            Text = "  "..text..": "..val,
            TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, -- Fixed Font
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        }),
        Create("Frame", {
            Name = "List",
            Position = UDim2.new(0, 0, 0, 35),
            Size = UDim2.new(1, 0, 0, #list * 30),
            BackgroundColor3 = Theme.ElementBG,
            Visible = false, BorderSizePixel = 0
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Create("UIListLayout", {Padding = UDim.new(0, 2)})
        })
    })

    Frame.Main.MouseButton1Click:Connect(function()
        open = not open
        Frame.Size = open and UDim2.new(1, 0, 0, 35 + #list * 30) or UDim2.new(1, 0, 0, 30)
        Frame.List.Visible = open
    end)

    for _, v in pairs(list) do
        local Item = Create("TextButton", {
            Text = "  "..v, Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Theme.ElementBG,
            TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, -- Fixed Font
            AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Frame.List
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 4)})
        })
        Item.MouseButton1Click:Connect(function()
            val = v
            Frame.Main.Text = "  "..text..": "..v
            open = false
            Frame.Size = UDim2.new(1, 0, 0, 30)
            Frame.List.Visible = false
            if callback then callback(v) end
        end)
    end
end

return FluentLibrary
