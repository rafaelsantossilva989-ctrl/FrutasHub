-- FRUTAS HUB V22 - Farm, prioridades, abertura inteligente, venda e anti-Spartabox
-- V22: espera o encerramento da abertura individual antes de iniciar outra pilha.
local Players=game:GetService('Players')
local CoreGui=game:GetService('CoreGui')
local VIM=game:GetService('VirtualInputManager')
local player=Players.LocalPlayer
local pg=player:WaitForChild('PlayerGui')
if _G.FrutasHubStop then pcall(_G.FrutasHubStop) end
local parent=pg
if type(gethui)=='function' then local ok,p=pcall(gethui);if ok and p then parent=p end else pcall(function()parent=CoreGui end) end
for _,place in ipairs({pg,CoreGui,parent}) do pcall(function() for _,name in ipairs({'FrutasHubV5','FrutasHubV6','FrutasHubV7','FrutasHubV10','FrutasHubV11','FrutasHubV12','FrutasHubV13','FrutasHubV14','FrutasHubV15','FrutasHubV16','FrutasHubV19','FrutasHubV20','FrutasHubV21','FrutasHubV22','FrutasHubAbrirV8','FrutasHubAbrirV9'}) do local x=place:FindFirstChild(name);if x then x:Destroy() end end end) end
local gui=Instance.new('ScreenGui');gui.Name='FrutasHubV22';gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=999999;gui.Parent=parent
local running=true;local farm=false;local autoOpen=false;local autoSell=false;local anti=false;local busy=false;local velocity=28;local adjX=0;local adjY=35;local originals={};local lastUse=0
local order={{'Comum','CaixaComum'},{'Incomum','CaixaIncomum'},{'Rara','CaixaRara'},{'Epica','CaixaEpica'},{'Lendaria','CaixaLendaria'},{'Mitica','CaixaMitica'},{'Secreta','CaixaSecreta'},{'Especial','CaixaEspecial'},{'Admin','CaixaAdmin'}}
local selected={};local priorityIndex=1
local function make(t,props,parentObj) local o=Instance.new(t);for k,v in pairs(props) do o[k]=v end;o.Parent=parentObj;return o end
local function corner(o)make('UICorner',{CornerRadius=UDim.new(0,10)},o)end
local function stroke(o,c)make('UIStroke',{Color=c or Color3.fromRGB(72,91,126),Thickness=1,Transparency=.35},o)end
local function button(p,txt,x,y,w,h,color) local o=make('TextButton',{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=color or Color3.fromRGB(55,65,90),Text=txt,TextColor3=Color3.new(1,1,1),TextSize=12,Font=Enum.Font.GothamBold,TextWrapped=true},p);corner(o);stroke(o);return o end
local panel=make('Frame',{Size=UDim2.fromOffset(290,560),Position=UDim2.new(.5,-145,.5,-280),BackgroundColor3=Color3.fromRGB(15,21,34),Active=true,Draggable=true},gui);corner(panel);stroke(panel,Color3.fromRGB(76,124,194))
make('TextLabel',{Position=UDim2.fromOffset(8,4),Size=UDim2.fromOffset(235,28),BackgroundTransparency=1,Text='🍎 FRUTAS HUB  •  V20',TextColor3=Color3.new(1,1,1),TextSize=17,Font=Enum.Font.GothamBold},panel)
local close=button(panel,'X',255,5,28,27,Color3.fromRGB(190,55,65));local bubble=button(gui,'🍎',12,180,48,48,Color3.fromRGB(45,110,215));bubble.Visible=false;bubble.Active=true;bubble.Draggable=true
close.MouseButton1Click:Connect(function()panel.Visible=false;bubble.Visible=true end)
local status=make('TextLabel',{Position=UDim2.fromOffset(8,34),Size=UDim2.fromOffset(274,36),BackgroundTransparency=1,Text='● Pronto para iniciar',TextColor3=Color3.fromRGB(155,235,180),TextSize=11,TextWrapped=true},panel)
local list=make('ScrollingFrame',{Position=UDim2.fromOffset(8,74),Size=UDim2.fromOffset(274,149),BackgroundColor3=Color3.fromRGB(25,34,53),ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0)},panel);corner(list)
local layout=make('UIListLayout',{Padding=UDim.new(0,3)},list)
local function drawOrder()
 for _,child in ipairs(list:GetChildren()) do if child:IsA('TextButton') then child:Destroy() end end
 for i,item in ipairs(order) do
  local name,key=item[1],item[2];local mark=selected[key] and '☑' or '☐'
  local b=button(list,mark..' '..i..'. '..name,0,0,260,26,i==priorityIndex and Color3.fromRGB(75,87,130) or selected[key] and Color3.fromRGB(35,125,80) or Color3.fromRGB(48,52,70));b.Size=UDim2.new(1,-6,0,26)
  b.MouseButton1Click:Connect(function()selected[key]=not selected[key];priorityIndex=i;drawOrder() end)
 end
 list.CanvasSize=UDim2.fromOffset(0,#order*29+5)
end
drawOrder()
local up=button(panel,'↑ PRIORIDADE',8,230,133,28);local down=button(panel,'↓ PRIORIDADE',149,230,133,28)
local function movePriority(d) local j=priorityIndex+d;if j<1 or j>#order then return end;order[priorityIndex],order[j]=order[j],order[priorityIndex];priorityIndex=j;drawOrder() end
up.MouseButton1Click:Connect(function()movePriority(-1)end);down.MouseButton1Click:Connect(function()movePriority(1)end)
local farmBtn=button(panel,'▶ FARM OFF',8,267,133,31,Color3.fromRGB(35,135,80));local openBtn=button(panel,'📦 AUTO ABRIR OFF',149,267,133,31)
local sellBtn=button(panel,'💰 AUTO VENDER OFF',8,304,133,31);local antiBtn=button(panel,'👹 ANTI-BOSS OFF',149,304,133,31)
local openNow=button(panel,'📦 ABRIR AGORA',8,341,133,31);local sellNow=button(panel,'💰 VENDER AGORA',149,341,133,31)
local velText=make('TextLabel',{Position=UDim2.fromOffset(8,381),Size=UDim2.fromOffset(274,19),BackgroundTransparency=1,Text='🏃 Velocidade: 28',TextColor3=Color3.new(1,1,1),TextSize=12},panel)
local minus=button(panel,'-2',8,403,65,25);local plus=button(panel,'+2',217,403,65,25)
minus.MouseButton1Click:Connect(function()velocity=math.max(16,velocity-2);velText.Text='🏃 Velocidade: '..velocity end)
plus.MouseButton1Click:Connect(function()velocity=math.min(40,velocity+2);velText.Text='🏃 Velocidade: '..velocity end)
local adjustText=make('TextLabel',{Position=UDim2.fromOffset(8,434),Size=UDim2.fromOffset(274,18),BackgroundTransparency=1,Text='🎯 Minigame X: 0 | Y: +35',TextColor3=Color3.new(1,1,1),TextSize=11},panel)
local left=button(panel,'◀',8,457,62,26);local right=button(panel,'▶',78,457,62,26);local above=button(panel,'▲',150,457,62,26);local below=button(panel,'▼',220,457,62,26)
local function refreshAdj()adjustText.Text=string.format('🎯 Minigame X: %+d | Y: %+d',adjX,adjY)end
left.MouseButton1Click:Connect(function()adjX=adjX-10;refreshAdj()end);right.MouseButton1Click:Connect(function()adjX=adjX+10;refreshAdj()end);above.MouseButton1Click:Connect(function()adjY=adjY-10;refreshAdj()end);below.MouseButton1Click:Connect(function()adjY=adjY+10;refreshAdj()end)
local testTextures=button(panel,'🔵 TESTAR TEXTURAS',8,521,274,30,Color3.fromRGB(35,105,175))
local info=make('TextLabel',{Position=UDim2.fromOffset(8,487),Size=UDim2.fromOffset(274,26),BackgroundTransparency=1,Text='⚡ Minigame turbo • aguardando',TextColor3=Color3.fromRGB(190,200,220),TextSize=11,TextWrapped=true},panel)

-- V19: Seletor de modos. Pratico = somente STEAL, selecao de raridade e regulagens.
local mode='SELECAO'
local modePanel=make('Frame',{Size=UDim2.fromOffset(290,245),Position=UDim2.new(.5,-145,.5,-122),BackgroundColor3=Color3.fromRGB(15,21,34),Active=true,Draggable=true},gui)
corner(modePanel);stroke(modePanel,Color3.fromRGB(76,124,194))
make('TextLabel',{Position=UDim2.fromOffset(10,12),Size=UDim2.fromOffset(270,40),BackgroundTransparency=1,Text='🍎 FRUTAS HUB V19',TextColor3=Color3.new(1,1,1),TextSize=21,Font=Enum.Font.GothamBold},modePanel)
make('TextLabel',{Position=UDim2.fromOffset(10,53),Size=UDim2.fromOffset(270,25),BackgroundTransparency=1,Text='ESCOLHA COMO QUER JOGAR',TextColor3=Color3.fromRGB(170,193,226),TextSize=12,Font=Enum.Font.Gotham},modePanel)
local chooseAfk=button(modePanel,'🌙 MODO AFK  •  COMPLETO',14,94,262,54,Color3.fromRGB(48,93,165))
local choosePratico=button(modePanel,'⚡ MODO PRÁTICO  •  STEAL',14,158,262,54,Color3.fromRGB(33,130,105))
local practical=make('Frame',{Size=UDim2.fromOffset(290,460),Position=UDim2.new(.5,-145,.5,-230),BackgroundColor3=Color3.fromRGB(15,21,34),Active=true,Draggable=true,Visible=false},gui)
corner(practical);stroke(practical,Color3.fromRGB(65,170,147))
make('TextLabel',{Position=UDim2.fromOffset(8,7),Size=UDim2.fromOffset(230,26),BackgroundTransparency=1,Text='⚡ FRUTAS HUB  •  STEAL',TextColor3=Color3.new(1,1,1),TextSize=16,Font=Enum.Font.GothamBold},practical)
local pracClose=button(practical,'X',255,5,28,27,Color3.fromRGB(190,55,65))
local pracStatus=make('TextLabel',{Position=UDim2.fromOffset(8,39),Size=UDim2.fromOffset(274,32),BackgroundTransparency=1,Text='Selecione as caixas e ative STEAL',TextColor3=Color3.fromRGB(165,230,190),TextSize=11,TextWrapped=true},practical)
local pracList=make('ScrollingFrame',{Position=UDim2.fromOffset(8,75),Size=UDim2.fromOffset(274,158),BackgroundColor3=Color3.fromRGB(25,34,53),ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0)},practical);corner(pracList)
make('UIListLayout',{Padding=UDim.new(0,3)},pracList)
local drawPractical
local function refreshPractical()
 for _,c in ipairs(pracList:GetChildren()) do if c:IsA('TextButton') then c:Destroy()end end
 for i,entry in ipairs(order) do
  local key=entry[2]
  local b=button(pracList,(selected[key] and '☑ ' or '☐ ')..i..'. '..entry[1],0,0,255,27,selected[key] and Color3.fromRGB(32,120,87) or Color3.fromRGB(43,53,76))
  b.Size=UDim2.new(1,-6,0,27)
  b.MouseButton1Click:Connect(function()selected[key]=not selected[key];priorityIndex=i;drawOrder();refreshPractical()end)
 end
 pracList.CanvasSize=UDim2.fromOffset(0,#order*30+5)
end
drawPractical=refreshPractical
refreshPractical()
local pracUp=button(practical,'↑ PRIORIDADE',8,241,133,27)
local pracDown=button(practical,'↓ PRIORIDADE',149,241,133,27)
pracUp.MouseButton1Click:Connect(function()movePriority(-1);refreshPractical()end)
pracDown.MouseButton1Click:Connect(function()movePriority(1);refreshPractical()end)
local pracFarm=button(practical,'▶ STEAL OFF',8,277,274,38,Color3.fromRGB(35,135,80))
local pracSpeed=make('TextLabel',{Position=UDim2.fromOffset(8,320),Size=UDim2.fromOffset(274,21),BackgroundTransparency=1,Text='🏃 Velocidade: 28',TextColor3=Color3.new(1,1,1),TextSize=12},practical)
local pracMinus=button(practical,'−2',8,346,75,28)
local pracPlus=button(practical,'+2',207,346,75,28)
local pracAdjust=make('TextLabel',{Position=UDim2.fromOffset(8,379),Size=UDim2.fromOffset(274,20),BackgroundTransparency=1,Text='🎯 Minigame X: 0 | Y: +35',TextColor3=Color3.new(1,1,1),TextSize=11},practical)
local pLeft=button(practical,'◀',8,405,62,28)
local pRight=button(practical,'▶',78,405,62,28)
local pUp=button(practical,'▲',150,405,62,28)
local pDown=button(practical,'▼',220,405,62,28)
local backAfk=button(panel,'⇄ MODOS',177,5,72,27,Color3.fromRGB(40,92,140))
local backPrac=button(practical,'⇄',218,5,30,27,Color3.fromRGB(40,92,140))
local function showMode(m)
 mode=m
 if m=='SELECAO' then farm=false;farmBtn.Text='▶ FARM OFF' end
 modePanel.Visible=(m=='SELECAO')
 panel.Visible=(m=='AFK')
 practical.Visible=(m=='PRATICO')
 bubble.Visible=false
 if m=='PRATICO' then
  autoOpen=false;autoSell=false;anti=false
  openBtn.Text='📦 AUTO ABRIR OFF';sellBtn.Text='💰 AUTO VENDER OFF';antiBtn.Text='👹 ANTI-BOSS OFF'
  refreshPractical()
 end
end
chooseAfk.MouseButton1Click:Connect(function()showMode('AFK')end)
choosePratico.MouseButton1Click:Connect(function()showMode('PRATICO')end)
backAfk.MouseButton1Click:Connect(function()showMode('SELECAO')end)
backPrac.MouseButton1Click:Connect(function()showMode('SELECAO')end)
pracClose.MouseButton1Click:Connect(function()practical.Visible=false;bubble.Visible=true end)
-- O botao flutuante abre o painel do modo selecionado.

bubble.MouseButton1Click:Connect(function()panel.Visible=(mode=='AFK');practical.Visible=(mode=='PRATICO');modePanel.Visible=(mode=='SELECAO');bubble.Visible=false end)
pracMinus.MouseButton1Click:Connect(function()velocity=math.max(16,velocity-2)end)
pracPlus.MouseButton1Click:Connect(function()velocity=math.min(40,velocity+2)end)
pLeft.MouseButton1Click:Connect(function()adjX=adjX-10;refreshAdj()end)
pRight.MouseButton1Click:Connect(function()adjX=adjX+10;refreshAdj()end)
pUp.MouseButton1Click:Connect(function()adjY=adjY-10;refreshAdj()end)
pDown.MouseButton1Click:Connect(function()adjY=adjY+10;refreshAdj()end)
task.spawn(function()
 while running and gui.Parent do
  pracFarm.Text=farm and '■ STEAL ON' or '▶ STEAL OFF'
  pracSpeed.Text='🏃 Velocidade: '..velocity
  pracAdjust.Text=string.format('🎯 Minigame X: %+d | Y: %+d',adjX,adjY)
  pracStatus.Text=status.Text
  task.wait(.25)
 end
end)
panel.Visible=false

local function character()local c=player.Character;if not c then return end;return c,c:FindFirstChildOfClass('Humanoid'),c:FindFirstChild('HumanoidRootPart')end
local function restore()for hum,speed in pairs(originals) do pcall(function()if hum.Parent then hum.WalkSpeed=speed end end)end end
local function moveStop()local _,hum,root=character();if hum and root then pcall(function()hum:MoveTo(root.Position)end)end end
local function tool()local c,hum=character();if not c or not hum then return end;local equipped=c:FindFirstChildOfClass('Tool');if equipped then return equipped end;local bp=player:FindFirstChild('Backpack');if not bp then return end;local first
 for _,t in ipairs(bp:GetChildren()) do if t:IsA('Tool') then first=first or t;local n=t.Name:lower();if n:find('mao') or n:find('mão') or n:find('hand') or n:find('pegar') then hum:EquipTool(t);return t end end end
 if first then hum:EquipTool(first);return first end
end
local function part(o)if o:IsA('BasePart')then return o end;if o:IsA('Model')then return o.PrimaryPart or o:FindFirstChildWhichIsA('BasePart',true)end end
local function target()local _,_,root=character();if not root then return end;local folder=workspace:FindFirstChild('CaixasAtivas');if not folder then return end
 -- Prioridade primeiro; distancia apenas desempata dentro da mesma raridade
 for _,entry in ipairs(order) do local key=entry[2];if selected[key] then local best,dist=nil,math.huge;for _,obj in ipairs(folder:GetDescendants()) do if obj.Name==key then local p=part(obj);if p then local d=(root.Position-p.Position).Magnitude;if d<dist then best,dist=p,d end end end end;if best then return best,dist,key end end end
end
local function tapXY(x,y,delay)if not running then error('Hub encerrado')end;VIM:SendMouseButtonEvent(x,y,0,true,game,0);task.wait(delay or .12);VIM:SendMouseButtonEvent(x,y,0,false,game,0)end
local function tapGui(b,dx,dy,delay)if not b or not b.Parent then error('Botao ausente')end;local p,s=b.AbsolutePosition,b.AbsoluteSize;tapXY(p.X+s.X/2+(dx or 0),p.Y+s.Y/2+(dy or 0),delay)end
local function visible(o)if not o or not o:IsA('GuiObject') or not o.Visible then return false end;local p=o.Parent;while p do if p:IsA('GuiObject') and not p.Visible then return false end;if p:IsA('ScreenGui') and not p.Enabled then return false end;p=p.Parent end;return true end
local function waitFor(fn,seconds)local start=os.clock();while running and os.clock()-start<(seconds or 5) do local ok,val=pcall(fn);if ok and val then return val end;task.wait(.07)end end
local function path(root,...)local o=root;for _,n in ipairs({...}) do if not o then return nil end;o=o:FindFirstChild(n) end;return o end
local function minigame()local mg=pg:FindFirstChild('MinigameCaixaGui');if not mg or not mg.Enabled then info.Text='⚡ Minigame turbo • aguardando';return false end;local nums=mg:FindFirstChild('Numeros');if not nums then return false end;local buttons={};for _,b in ipairs(nums:GetDescendants()) do if b:IsA('TextButton') and b.Name:match('^N%d+$') and visible(b) and b.AbsoluteSize.X>0 then table.insert(buttons,b) end end;table.sort(buttons,function(a,b)return tonumber(a.Name:match('%d+'))<tonumber(b.Name:match('%d+'))end);info.Text='Minigame: '..#buttons..' botoes';for _,b in ipairs(buttons) do if not farm or busy or not mg.Enabled then break end;if visible(b) then pcall(tapGui,b,adjX,adjY,.008);task.wait(.0087)end end;return true end
local function activate()local t=tool();if t and os.clock()-lastUse>=.8 then lastUse=os.clock();pcall(function()t:Activate()end)end end
local inv=path(pg,'BackpackGui','Backpack','Inventory')
local function inventoryNodes()local i=path(pg,'BackpackGui','Backpack','Inventory');if not i then error('Inventario nao encontrado')end;local icon=path(pg,'TopbarStandard','Holders','Left','Inventory','IconButton','Menu','IconSpot','ClickRegion');local tab=path(i,'AbasMochila','Aba_caixas');local grid=path(i,'ScrollingFrame','UIGridFrame');if not icon or not tab or not grid then error('Elementos da mochila nao encontrados')end;return i,icon,tab,grid end
local function openInventory()local i,icon,tab,grid=inventoryNodes();if not i.Visible then tapGui(icon,50,60,.065)end;if not waitFor(function()return i.Visible end,5)then error('Mochila nao abriu')end;task.wait(.12);tapGui(tab,40,60,.065);task.wait(.18);return i,grid end
local function closeInventory(i)local screen=workspace.CurrentCamera.ViewportSize;tapXY(screen.X*.85+20,screen.Y*.75,.065);if not waitFor(function()return not i.Visible end,5)then error('Mochila nao fechou')end;task.wait(.15)end
local function slotCount(slot)local preview=slot:FindFirstChild('Preview3D',true);local amount=preview and preview:FindFirstChild('Quantidade',true);if amount and amount:IsA('TextLabel')then return tonumber(amount.Text:match('%d+'))or 1 end;return 1 end
local function boxSlots(grid)local found={};for _,s in ipairs(grid:GetChildren())do if s:IsA('GuiButton') and s.Visible then local label=s:FindFirstChild('ToolName',true);if label and label:IsA('TextLabel')and label.Text:lower():find('caixa',1,true)then table.insert(found,{slot=s,name=label.Text,count=slotCount(s)})end end end;table.sort(found,function(a,b)local x,y=tonumber(a.slot.Name),tonumber(b.slot.Name);if x and y then return x<y end;return a.slot.Name<b.slot.Name end);return found end
local function panelOpen()return path(pg,'AbrirCaixaGui','Painel')end
local function resultButton()return path(pg,'AbrirVariasGui','Frame','Ok')end
local function noPopups()return not visible(panelOpen()) and not visible(resultButton())end
local function openPrompt()local size=workspace.CurrentCamera.ViewportSize;tapXY(size.X*.5,size.Y*.7);local p=waitFor(function()local v=panelOpen();if visible(v)then return v end end,7);if not p then error('ABRIR CAIXA nao apareceu')end;return p end
-- Espera o ciclo real terminar. Nao presume que a caixa terminou apenas
-- porque o popup de confirmacao sumiu (principalmente para 1 caixa).
-- Para uma caixa unica, a confirmacao desaparecer NAO significa que a animacao acabou.
-- Exige que todas as interfaces de abertura estejam fechadas de modo continuo.
local function singleUiActive()
 local confirm=panelOpen()
 local result=resultButton()
 local mg=pg:FindFirstChild('MinigameCaixaGui')
 local many=pg:FindFirstChild('AbrirVariasGui')
 local single=pg:FindFirstChild('AbrirCaixaGui')
 if visible(confirm) or visible(result) then return true end
 if mg and mg:IsA('ScreenGui') and mg.Enabled then return true end
 -- Nao basta ScreenGui.Enabled, pois pode ficar habilitado sem painel visivel.
 for _,screen in ipairs({many,single}) do
  if screen then
   for _,node in ipairs(screen:GetDescendants()) do
    if node:IsA('GuiObject') and node.Name:lower():find('resultado',1,true) and visible(node) then return true end
   end
  end
 end
 return false
end
local function waitSingleFinished()
 local started=os.clock()
 local clearSince=nil
 -- A animacao pode continuar mesmo apos a confirmacao sumir.
 -- Aguarda pelo menos 4 segundos e 2.5 segundos consecutivos sem UI ativa.
 while running and os.clock()-started<35 do
  if singleUiActive() then
   clearSince=nil
  else
   clearSince=clearSince or os.clock()
   if os.clock()-started>=4 and os.clock()-clearSince>=2.5 then
    task.wait(.45)
    if not singleUiActive() then return true end
    clearSince=nil
   end
  end
  task.wait(.12)
 end
 return false
end
local function performOpening(count)
 local p=openPrompt()
 if count==1 then
  local sim=p:FindFirstChild('Sim');if not visible(sim)then error('SIM nao encontrado')end
  tapGui(sim,30,60)
  if not waitFor(function()return not visible(p)end,12)then error('Confirmacao individual nao fechou')end
  status.Text='📦 Aguardando animacao 1x desaparecer por completo...'
  if not waitSingleFinished() then error('Caixa individual nao terminou; interrompendo para evitar cliques errados')end
 else
  local multi=p:FindFirstChild('Varias');if not visible(multi)then error('ABRIR NX nao encontrado')end
  tapGui(multi,70,60)
  local result=waitFor(function()local b=resultButton();if visible(b)then return b end end,15)
  if not result then error('PULAR/OK nao apareceu')end
  -- PULAR so depois que a tela de resultado estabilizar; evita toque antecipado.
  if result.Text:upper():find('PULAR',1,true) then
   task.wait(.75)
   if visible(result) and result.Text:upper():find('PULAR',1,true) then tapGui(result,60,65,.13)end
  end
  if not waitFor(function()return visible(result) and result.Text:upper():find('OK',1,true)end,18)then error('OK nao apareceu')end
  task.wait(.22)
  if not visible(result) or not result.Text:upper():find('OK',1,true) then error('OK mudou antes do clique')end
  tapGui(result,60,65,.13)
  if not waitFor(function()return not visible(result)end,12)then error('Resultado nao fechou')end
  task.wait(.3)
 end
 if not waitFor(noPopups,10)then error('Janela anterior continua aberta')end
end
local function getTotal(grid)local n=0;for _,s in ipairs(boxSlots(grid))do n=n+s.count end;return n end
local function openAll()
 local rounds=0;local unchanged=0;local previousSignature=nil
 while running do
  status.Text='📦 Procurando caixas...'
  local i,grid=openInventory();local boxes=boxSlots(grid);if #boxes==0 then status.Text='📦 Sem caixas para abrir';return end
  local signature=table.concat((function()local t={};for _,b in ipairs(boxes)do t[#t+1]=b.name..':'..b.count end;return t end)(),'|')
  if signature==previousSignature then unchanged=unchanged+1 else unchanged=0 end
  previousSignature=signature
  if unchanged>=3 then error('Inventario nao mudou apos 3 tentativas; evitando loop AFK')end
  local chosen=boxes[1];local name=chosen.name
  tapGui(chosen.slot,50,60,.085);task.wait(.28);closeInventory(i)
  -- Enquanto a mesma pilha estiver equipada, nao reabre a mochila.
  local remaining=chosen.count
  while running and remaining>0 do
   local take=math.min(10,remaining)
   status.Text='📦 '..name..' | Abrindo '..take..' de '..remaining
   performOpening(remaining)
   remaining=remaining-take;rounds=rounds+1
   if rounds>=125 then error('Limite de seguranca: 125 rodadas')end
   task.wait(.45)
  end
  -- Confere o inventario depois da pilha, antes de escolher outro tipo.
  local _,checkGrid=openInventory();local after=boxSlots(checkGrid)
  local same=false
  for _,b in ipairs(after)do if b.name==name then same=true;break end end
  if same then
   -- Nao continuar indefinidamente se o jogo nao consumiu as caixas.
   status.Text='⚠️ Ainda ha caixas desse tipo; conferindo...'
  end
  task.wait(.2)
  -- O proximo ciclo selecionara o primeiro slot atualizado.
 end
end
local function clickSeller()
 local sellTop=path(pg,'BotoesTopoGui','Botoes','Vender','Conteudo','Botao')
 if not sellTop then error('Botao VENDER nao encontrado')end
 status.Text='💰 Abrindo vendedor...';tapGui(sellTop,60,60);task.wait(.8)
 local npc=workspace:FindFirstChild('VendedorNPC');local root=npc and npc:FindFirstChild('HumanoidRootPart');local prompt=root and root:FindFirstChild('PromptVendedor')
 if not prompt then error('PromptVendedor nao encontrado')end
 if type(fireproximityprompt)~='function'then error('fireproximityprompt indisponivel')end
 fireproximityprompt(prompt)
 local opt=waitFor(function()local o=path(pg,'VendedorGui','Opcoes','Opcao1');if o and visible(o) and o.Text:lower():find('quero vender todas',1,true)then return o end end,8)
 if not opt then error('Opcao Quero vender todas nao encontrada')end
 status.Text='💰 Vendendo frutas...';tapGui(opt,60,60)
 local done=waitFor(function()local o=path(pg,'VendedorGui','Opcoes','Opcao1');if o and visible(o) and o.Text:lower():find('fechado',1,true)then return o end end,8)
 if not done then error('Confirmacao Fechado nao encontrada')end
 tapGui(done,60,60);status.Text='💰 Venda enviada!'
end
local function labelValue(name)local v=path(pg,'BackpackGui','Backpack','Inventory','TopbarMochila','Etiquetas',name,'Valor');if not v then return end;local a,b=v.Text:match('(%d+)%s*/%s*(%d+)');return tonumber(a),tonumber(b)end
local function full(name)local a,b=labelValue(name);return a and b and b>0 and a>=b end
local function job(fn)
 if busy or not running then return false end
 busy=true;moveStop()
 local ok,err=pcall(fn)
 if not ok then status.Text='❌ '..tostring(err);warn('[FrutasHubV22]',err)end
 busy=false
 return ok
end
local function toggleFarm()
 farm=not farm
 if farm then local any=false;for _,v in pairs(selected)do if v then any=true;break end end;if not any then farm=false;status.Text='Selecione uma raridade primeiro!'end end
 farmBtn.Text=farm and '■ FARM ON' or '▶ FARM OFF';if not farm then restore();moveStop()end
end
farmBtn.MouseButton1Click:Connect(toggleFarm)
pracFarm.MouseButton1Click:Connect(toggleFarm)
openBtn.MouseButton1Click:Connect(function()autoOpen=not autoOpen;openBtn.Text=autoOpen and '📦 AUTO ABRIR ON' or '📦 AUTO ABRIR OFF'end)
sellBtn.MouseButton1Click:Connect(function()autoSell=not autoSell;sellBtn.Text=autoSell and '💰 AUTO VENDER ON' or '💰 AUTO VENDER OFF'end)
antiBtn.MouseButton1Click:Connect(function()anti=not anti;antiBtn.Text=anti and '👹 ANTI-BOSS ON' or '👹 ANTI-BOSS OFF'end)
openNow.MouseButton1Click:Connect(function()task.spawn(function()job(openAll)end)end)
sellNow.MouseButton1Click:Connect(function()task.spawn(function()job(clickSeller)end)end)
-- Farm original, respeitando pausa durante tarefas de GUI.
task.spawn(function()
 while running and gui.Parent do
  if farm and not busy then
   local _,hum,root=character()
   if hum and root and hum.Health>0 then
    if originals[hum]==nil then originals[hum]=hum.WalkSpeed end
    hum.WalkSpeed=velocity
    if minigame()then hum:MoveTo(root.Position);status.Text='🎯 Resolvendo minigame...'
    else tool();local box,dist,key=target();if box then if dist>1.5 then hum:MoveTo(box.Position);status.Text='📦 '..key..' | '..math.floor(dist)..' studs' else hum:MoveTo(root.Position);activate();status.Text='✋ Pegando caixa...'end else status.Text='📦 Nenhuma caixa encontrada' end end
   end
  end
  task.wait(.1)
 end
end)
-- Inventario cheio: prioriza vender frutas para liberar espaco, depois abrir caixas.
task.spawn(function()
 while running and gui.Parent do
  if not busy then
   if autoSell and full('Etiqueta_QtdCamisas')then job(clickSeller)
   elseif autoOpen and full('Etiqueta_QtdCaixas')then job(openAll)end
  end
  task.wait(2)
 end
end)
-- Anti-Spartabox V18: clique periodico a cada 60 segundos, sem deteccao de posicao.
local function tapTextures()
 tapXY(331,68)
end
testTextures.MouseButton1Click:Connect(function()
 if busy then status.Text='⏳ Aguarde outra tarefa terminar' return end
 task.spawn(function()
  status.Text='🔵 Testando clique TEXTURAS (331,68)...'
  local _,_,root=character()
  local old=root and root.Position
  local ok,err=pcall(tapTextures)
  if not ok then status.Text='❌ Erro: '..tostring(err) return end
  task.wait(2)
  local _,_,newroot=character()
  if old and newroot and (newroot.Position-old).Magnitude>25 then
   status.Text='✅ TEXTURAS funcionou!'
  else
   status.Text='⚠️ Clique enviado, sem teleporte detectado'
  end
 end)
end)
-- O cronometro comeca ao ligar o Anti-Boss. O primeiro clique ocorre apos 60 s.
-- Caso uma tarefa de GUI esteja em andamento, aguarda liberar para nao conflitar.
local antiEnabledAt=nil
local antiNextClick=nil
antiBtn.MouseButton1Click:Connect(function()
 if anti then
  antiEnabledAt=os.clock()
  antiNextClick=antiEnabledAt+60
  status.Text='👹 Anti-Boss: TEXTURAS a cada 60 segundos'
 else
  antiEnabledAt=nil
  antiNextClick=nil
 end
end)
task.spawn(function()
 while running and gui.Parent do
  if anti then
   if not antiNextClick then antiNextClick=os.clock()+60 end
   if os.clock()>=antiNextClick and not busy then
    busy=true
    moveStop()
    status.Text='🔵 Anti-Boss: clicando TEXTURAS (60 s)...'
    local ok,err=pcall(tapTextures)
    if ok then
     status.Text='✅ Anti-Boss: clique TEXTURAS enviado!'
    else
     status.Text='❌ Anti-Boss: '..tostring(err)
    end
    antiNextClick=os.clock()+60
    busy=false
   end
  else
   antiNextClick=nil
  end
  task.wait(.2)
 end
end)
_G.FrutasHubStop=function()
 running=false;farm=false;autoOpen=false;autoSell=false;anti=false;restore();moveStop();if gui.Parent then gui:Destroy()end
end
