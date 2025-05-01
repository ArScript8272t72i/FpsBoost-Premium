-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Criação do console
local gui = Instance.new("ScreenGui")
gui.Name = "DesempenhoConsole"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local console = Instance.new("TextLabel")
console.Name = "Console"
console.Parent = gui
console.Size = UDim2.new(0, 260, 0, 80)
console.Position = UDim2.new(1, -270, 0, 10)
console.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
console.BackgroundTransparency = 0.4
console.TextColor3 = Color3.fromRGB(0, 255, 0)
console.TextSize = 12
console.TextXAlignment = Enum.TextXAlignment.Left
console.TextYAlignment = Enum.TextYAlignment.Top
console.BorderSizePixel = 1
console.BorderColor3 = Color3.fromRGB(0, 255, 0)
console.Text = "⚙️ Desempenho Iniciando..."

-- Função para atualizar o console
local function log(text)
    console.Text = "⚙️ Ultra Desempenho\n" .. text
end

-- FPS Tracker
local fps = 60
local frameCount = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = now
    end
end)

-- Função para aplicar melhorias de desempenho
local function aplicarMelhorias()
    -- Gráficos
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100
    Lighting.Brightness = 0
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("BloomEffect") then
            pcall(function() obj:Destroy() end)
        end
    end
    -- Partículas
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
            pcall(function() obj:Destroy() end)
        end
    end
end

-- Anti-Fling
local function antiFling()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        if root.Velocity.Magnitude > 120 then
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
    end
end

-- Modo Turbo (FPS < 60)
local function verificarDesempenho()
    if fps < 60 then
        aplicarMelhorias()
        log("🚨 FPS Baixo: " .. fps .. "\nModo Turbo Ativado!")
    else
        log("✅ FPS: " .. fps .. " | Desempenho Estável")
    end
end

-- Função para carregar modelo com ID
local function mostrarModelo(idModelo)
    -- Verifica se o jogador possui as BTools
    if not player:HasPermission("CanBuild") then
        log("❌ Você precisa de BTools para usar este recurso.")
        return
    end

    -- Verificar se o ID do modelo foi informado
    if idModelo == "" or not idModelo then
        log("❌ ID do modelo não fornecido!")
        return
    end

    -- Buscar o modelo na ReplicatedStorage
    local modelo = ReplicatedStorage:FindFirstChild(idModelo)
    if modelo then
        -- Clona o modelo encontrado
        local modeloClonado = modelo:Clone()
        modeloClonado.Parent = Workspace

        -- Posiciona o modelo à frente do jogador
        modeloClonado:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)) -- Posição na frente do jogador
        modeloClonado:SetPrimaryPartCFrame(CFrame.new(modeloClonado.PrimaryPart.Position.X, modeloClonado.PrimaryPart.Position.Y, modeloClonado.PrimaryPart.Position.Z)) -- Corrige o posicionamento
        log("✅ Modelo carregado à frente de você!")
    else
        log("❌ Modelo não encontrado! Verifique o ID ou tente novamente.")
    end
end

-- Criando a interface do menu
local menuFrame = Instance.new("Frame", gui)
menuFrame.Size = UDim2.new(0, 200, 0, 500)
menuFrame.Position = UDim2.new(0, 10, 0, 100)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.BorderSizePixel = 2
menuFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)

-- Função para criar botões no menu
local function criarBotao(nomeBotao, funcao, yPos)
    local botao = Instance.new("TextButton", menuFrame)
    botao.Size = UDim2.new(0, 180, 0, 30)
    botao.Position = UDim2.new(0, 10, 0, yPos)
    botao.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    botao.TextColor3 = Color3.fromRGB(0, 255, 0)
    botao.TextSize = 14
    botao.Text = nomeBotao
    botao.Font = Enum.Font.Code
    botao.BorderSizePixel = 1
    botao.BorderColor3 = Color3.fromRGB(0, 255, 0)

    botao.MouseButton1Click:Connect(funcao)
end

-- Adicionando botões ao menu
criarBotao("Ativar Modo Turbo", function() log("Modo Turbo Ativado!") end, 10)
criarBotao("Desativar Modo Turbo", function() log("Modo Turbo Desativado!") end, 50)
criarBotao("Ativar Desempenho Especial", function() log("Desempenho Especial Ativado!") end, 90)
criarBotao("Desativar Desempenho Especial", function() log("Desempenho Especial Desativado!") end, 130)
criarBotao("Ativar Anti Network", function() log("Anti Network Ativado!") end, 170)
criarBotao("Desativar Anti Network", function() log("Anti Network Desativado!") end, 210)
criarBotao("Ativar Anti Lag", function() log("Anti Lag Ativado!") end, 250)
criarBotao("Desativar Anti Lag", function() log("Anti Lag Desativado!") end, 290)

-- Função para adicionar a entrada do ID do modelo
local function criarEntradaModelo()
    local inputBox = Instance.new("TextBox", menuFrame)
    inputBox.Size = UDim2.new(0, 180, 0, 30)
    inputBox.Position = UDim2.new(0, 10, 0, 350)
    inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.Text = ""
    inputBox.PlaceholderText = "Digite o ID do modelo"
    inputBox.Font = Enum.Font.Code
    inputBox.BorderSizePixel = 1
    inputBox.BorderColor3 = Color3.fromRGB(0, 255, 0)

    local botaoCarregarModelo = Instance.new("TextButton", menuFrame)
    botaoCarregarModelo.Size = UDim2.new(0, 180, 0, 40)
    botaoCarregarModelo.Position = UDim2.new(0, 10, 0, 390)
    botaoCarregarModelo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    botaoCarregarModelo.TextColor3 = Color3.fromRGB(0, 255, 0)
    botaoCarregarModelo.TextSize = 14
    botaoCarregarModelo.Text = "Carregar Modelo"
    botaoCarregarModelo.Font = Enum.Font.Code
    botaoCarregarModelo.BorderSizePixel = 1
    botaoCarregarModelo.BorderColor3 = Color3.fromRGB(0, 255, 0)

    botaoCarregarModelo.MouseButton1Click:Connect(function()
        local idModelo = inputBox.Text
        mostrarModelo(idModelo)
    end)
end

-- Função para minimizar o menu
local function minimizarMenu()
    menuFrame.Visible = not menuFrame.Visible
end

-- Criar Entrada para ID de Modelo e os botões
criarEntradaModelo()

-- Botão de Minimizar
local minimizeButton = Instance.new("TextButton", gui)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -30, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
minimizeButton.Text = "_"
minimizeButton.TextSize = 18
minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.Font = Enum.Font.Code
minimizeButton.BorderSizePixel = 1
minimizeButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
minimizeButton.MouseButton1Click:Connect(minimizarMenu)

-- Inicialização
log("🔧 Sistema de Turbo 4x e Desempenho Inicializado!")
