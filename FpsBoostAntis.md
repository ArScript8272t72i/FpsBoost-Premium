-- LocalScript | StarterPlayer > StarterPlayerScripts

-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local NetworkServer = game:GetService("NetworkServer")

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

-- Otimizações básicas
local function aplicarMelhorias()
	-- Gráficos
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100
	Lighting.Brightness = 0

	-- Garantindo que a neblina e efeitos sejam removidos
	Lighting.FogStart = 0
	Lighting.FogColor = Color3.fromRGB(255, 255, 255)
	Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

	-- Removendo efeitos de iluminação
	for _, obj in ipairs(Lighting:GetChildren()) do
		if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("BloomEffect") then
			pcall(function() obj:Destroy() end)
		end
	end

	-- Remoção de partículas simples
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
			pcall(function() obj:Destroy() end)
		end
	end
end

-- Anti Network Baixa (Monitora a qualidade da rede)
local function monitorarConexao()
	local connectionQuality = player.NetworkServer
	if connectionQuality then
		local ping = player.Ping
		if ping > 200 then  -- Se o ping for maior que 200ms, ativa otimizações
			log("🚨 Rede Lenta Detectada! Ping: " .. ping .. "ms\nModo Rede Baixa Ativado!")
			aplicarMelhorias()  -- Ativa as melhorias automaticamente
		else
			log("✅ Rede Estável | Ping: " .. ping .. "ms")
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

-- Loop contínuo a cada 0.3 segundos
task.spawn(function()
	while true do
		verificarDesempenho()
		monitorarConexao()  -- Verifica a qualidade da rede
		antiFling()
		task.wait(0.3)
	end
end)

-- Inicial
aplicarMelhorias()
log("🔧 Otimizações Aplicadas!")
