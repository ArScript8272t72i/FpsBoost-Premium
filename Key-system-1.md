-- RAIZ Library UI Key System com Execução Protegida

-- 🔐 Key verdadeira (oculta)
local function getHiddenKey()
    local keys = {
        "12345678",
        "68337621", -- <- key verdadeira
        "99999999",
        "87654321"
    }
    return keys[2]
end

local function verificarKey(input)
    return input == getHiddenKey()
end

-- 🛡️ Anti-Crack simples
local function antiCrack()
    if not game or not loadstring then
        while true do end -- trava
    end

    local ok, _ = pcall(function()
        return game:HttpGet("https://www.roblox.com/")
    end)
    if not ok then
        while true do end
    end
end

antiCrack()

-- 🎨 Criar Interface Bonita com Borda
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "KeyMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 160)
Frame.Position = UDim2.new(0.5, -150, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderColor3 = Color3.fromRGB(0, 170, 255)
Frame.BorderSizePixel = 4

local Title = Instance.new("TextLabel", Frame)
Title.Text = "🔐 Digite sua Key"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local TextBox = Instance.new("TextBox", Frame)
TextBox.PlaceholderText = "Digite aqui..."
TextBox.Size = UDim2.new(0.8, 0, 0, 30)
TextBox.Position = UDim2.new(0.1, 0, 0.4, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 18
TextBox.BorderColor3 = Color3.fromRGB(0, 170, 255)
TextBox.BorderSizePixel = 2

local Button = Instance.new("TextButton", Frame)
Button.Text = "✔️ Validar"
Button.Size = UDim2.new(0.5, 0, 0, 30)
Button.Position = UDim2.new(0.25, 0, 0.75, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 18
Button.BorderSizePixel = 0

-- ✅ Quando clicar no botão
Button.MouseButton1Click:Connect(function()
    local entrada = TextBox.Text
    if verificarKey(entrada) then
        print("✅ Key correta!")

        -- 🔄 Remove o menu
        ScreenGui:Destroy()

        -- 🧠 Executa o script protegido
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ArScript8272t72i/FpsBoost-Premium/refs/heads/main/FpsBoostAntipremiunModerado.md"))()
    else
        Button.Text = "❌ Inválida"
        Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        wait(1.2)
        Button.Text = "✔️ Validar"
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)
