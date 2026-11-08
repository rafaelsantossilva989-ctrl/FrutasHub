-- FRUTAS HUB V11 - Farm, prioridades, abertura inteligente, venda e anti-Spartabox
-- Primeira versao integrada: teste cada modo separadamente.
local Players=game:GetService('Players')
local CoreGui=game:GetService('CoreGui')
local VIM=game:GetService('VirtualInputManager')
local player=Players.LocalPlayer
local pg=player:WaitForChild('PlayerGui')
if _G.FrutasHubStop then pcall(_G.FrutasHubStop) end
local parent=pg
if type(gethui)=='function' then local ok,p=pcall(gethui);if ok and p then parent=p end else pcall(function()parent=CoreGui end) end
for _,place in ipairs({pg,CoreGui,parent}) do pcall(function() for _,name in ipairs({'FrutasHubV5','FrutasHubV6','FrutasHubV7','FrutasHubV10','FrutasHubV11','FrutasHubAbrirV8','FrutasHubAbrirV9'}) do local x=place:FindFirstChild(name);if x then x:Destroy() end end end) end
local gui=Instance.new('ScreenGui');gui.Name='FrutasHubV11';gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=999999;gui.Parent=parent
local running=true;local farm=false;local autoOpen=false;local autoSell=false;local anti=false;local busy=false;local velocity=28;local adjX=0;local adjY=35;local originals={};local lastUse=0
local order={{'Comum','CaixaComum'},{'Incomum','CaixaIncomum'},{'Rara','CaixaRara'},{'Epica','CaixaEpica'},{'Lendaria','CaixaLendaria'},{'Mitica','CaixaMitica'},{'Secreta','CaixaSecreta'},{'Especial','CaixaEspecial'},{'Admin','CaixaAdmin'}}
local selected={};local priorityIndex=1
local function make(t,props,parentObj) local o=Instance.new(t);for k,v in pairs(props) do o[k]=v end;o.Parent=parentObj;return o end
local function corner(o)make('UICorner',{CornerRadius=UDim.new(0,8)},o)end
local function button(p,txt,x,y,w,h,color) local o=make('TextButton',{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=color or Color3.fromRGB(55,65,90),Text=txt,TextColor3=Color3.new(1,1,1),TextSize=12,Font=Enum.Font.GothamBold,TextWrapped=true},p);corner(o);return o end
local panel=make('Frame',{Size=UDim2.fromOffset(290,520),Position=UDim2.new(.5,-145,.5,-260),BackgroundColor3=Color3.fromRGB(24,27,40),Active=true,Draggable=true},gui);corner(panel)
make('TextLabel',{Position=UDim2.fromOffset(8,4),Size=UDim2.fromOffset(235,28),BackgroundTransparency=1,Text='🍎 FRUTAS HUB V11',TextColor3=Color3.new(1,1,1),TextSize=17,Font=Enum.Font.GothamBold},panel)
local close=button(panel,'X',255,5,28,27,Color3.fromRGB(190,55,65));local bubble=button(gui,'🍎',12,180,48,48,Color3.fromRGB(45,110,215));bubble.Visible=false;bubble.Active=true;bubble.Draggable=true
close.MouseButton1Click:Connect(function()panel.Visible=false;bubble.Visible=true end);bubble.MouseButton1Click:Connect(function()panel.Visible=true;bubble.Visible=false end)
local status=make('TextLabel',{Position=UDim2.fromOffset(8,34),Size=UDim2.fromOffset(274,36),BackgroundTransparency=1,Text='Status: pronto',TextColor3=Color3.fromRGB(155,235,180),TextSize=11,TextWrapped=true},panel)
local list=make('ScrollingFrame',{Position=UDim2.fromOffset(8,74),Size=UDim2.fromOffset(274,149),BackgroundColor3=Color3.fromRGB(35,39,54),ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0)},panel);corner(list)
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
local info=make('TextLabel',{Position=UDim2.fromOffset(8,487),Size=UDim2.fromOffset(274,26),BackgroundTransparency=1,Text='Minigame: aguardando',TextColor3=Color3.fromRGB(190,200,220),TextSize=11,TextWrapped=true},panel)
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
local function waitFor(fn,seconds)local start=os.clock();while running and os.clock()-start<(seconds or 5) do local ok,val=pcall(fn);if ok and val then return val end;task.wait(.18)end end
local function path(root,...)local o=root;for _,n in ipairs({...}) do if not o then return nil end;o=o:FindFirstChild(n) end;return o end
local function minigame()local mg=pg:FindFirstChild('MinigameCaixaGui');if not mg or not mg.Enabled then info.Text='Minigame: aguardando';return false end;local nums=mg:FindFirstChild('Numeros');if not nums then return false end;local buttons={};for _,b in ipairs(nums:GetDescendants()) do if b:IsA('TextButton') and b.Name:match('^N%d+$') and visible(b) and b.AbsoluteSize.X>0 then table.insert(buttons,b) end end;table.sort(buttons,function(a,b)return tonumber(a.Name:match('%d+'))<tonumber(b.Name:match('%d+'))end);info.Text='Minigame: '..#buttons..' botoes';for _,b in ipairs(buttons) do if not farm or busy or not mg.Enabled then break end;if visible(b) then pcall(tapGui,b,adjX,adjY,.045);task.wait(.035)end end;return true end
local function activate()local t=tool();if t and os.clock()-lastUse>=.8 then lastUse=os.clock();pcall(function()t:Activate()end)end end
local inv=path(pg,'BackpackGui','Backpack','Inventory')
local function inventoryNodes()local i=path(pg,'BackpackGui','Backpack','Inventory');if not i then error('Inventario nao encontrado')end;local icon=path(pg,'TopbarStandard','Holders','Left','Inventory','IconButton','Menu','IconSpot','ClickRegion');local tab=path(i,'AbasMochila','Aba_caixas');local grid=path(i,'ScrollingFrame','UIGridFrame');if not icon or not tab or not grid then error('Elementos da mochila nao encontrados')end;return i,icon,tab,grid end
local function openInventory()local i,icon,tab,grid=inventoryNodes();if not i.Visible then tapGui(icon,50,60)end;if not waitFor(function()return i.Visible end,5)then error('Mochila nao abriu')end;task.wait(.4);tapGui(tab,40,60);task.wait(.65);return i,grid end
local function closeInventory(i)local screen=workspace.CurrentCamera.ViewportSize;tapXY(screen.X*.85+20,screen.Y*.75);if not waitFor(function()return not i.Visible end,5)then error('Mochila nao fechou')end;task.wait(.4)end
local function slotCount(slot)local preview=slot:FindFirstChild('Preview3D',true);local amount=preview and preview:FindFirstChild('Quantidade',true);if amount and amount:IsA('TextLabel')then return tonumber(amount.Text:match('%d+'))or 1 end;return 1 end
local function boxSlots(grid)local found={};for _,s in ipairs(grid:GetChildren())do if s:IsA('GuiButton') and s.Visible then local label=s:FindFirstChild('ToolName',true);if label and label:IsA('TextLabel')and label.Text:lower():find('caixa',1,true)then table.insert(found,{slot=s,name=label.Text,count=slotCount(s)})end end end;table.sort(found,function(a,b)local x,y=tonumber(a.slot.Name),tonumber(b.slot.Name);if x and y then return x<y end;return a.slot.Name<b.slot.Name end);return found end
local function panelOpen()return path(pg,'AbrirCaixaGui','Painel')end
local function resultButton()return path(pg,'AbrirVariasGui','Frame','Ok')end
local function noPopups()return not visible(panelOpen()) and not visible(resultButton())end
local function openPrompt()local size=workspace.CurrentCamera.ViewportSize;tapXY(size.X*.5,size.Y*.7);local p=waitFor(function()local v=panelOpen();if visible(v)then return v end end,7);if not p then error('ABRIR CAIXA nao apareceu')end;return p end
local function performOpening(count)
 local p=openPrompt()
 if count==1 then
  local sim=p:FindFirstChild('Sim');if not visible(sim)then error('SIM nao encontrado')end
  tapGui(sim,30,60)
  if not waitFor(function()return not visible(p)end,12)then error('Abertura individual nao terminou')end
  task.wait(2)
 else
  local multi=p:FindFirstChild('Varias');if not visible(multi)then error('ABRIR NX nao encontrado')end
  tapGui(multi,70,60)
  local result=waitFor(function()local b=resultButton();if visible(b)then return b end end,12)
  if not result then error('PULAR/OK nao apareceu')end
  local skip=waitFor(function()return visible(result) and result.Text:upper():find('PULAR',1,true)end,6)
  if skip then tapGui(result,60,75)end
  if not waitFor(function()return visible(result) and result.Text:upper():find('OK',1,true)end,12)then error('OK nao apareceu')end
  tapGui(result,60,75)
  if not waitFor(function()return not visible(result)end,8)then error('Resultado nao fechou')end
 end
 if not waitFor(noPopups,8)then error('Janela anterior continua aberta')end
end
local function getTotal(grid)local n=0;for _,s in ipairs(boxSlots(grid))do n=n+s.count end;return n end
local function openAll()
 local rounds=0
 while running do
  status.Text='📦 Procurando caixas...'
  local i,grid=openInventory();local boxes=boxSlots(grid);if #boxes==0 then status.Text='📦 Sem caixas para abrir';return end
  local chosen=boxes[1];local name=chosen.name
  tapGui(chosen.slot,50,60);task.wait(.8);closeInventory(i)
  -- Enquanto a mesma pilha estiver equipada, nao reabre a mochila.
  local remaining=chosen.count
  while running and remaining>0 do
   local take=math.min(10,remaining)
   status.Text='📦 '..name..' | Abrindo '..take..' de '..remaining
   performOpening(remaining)
   remaining=remaining-take;rounds=rounds+1
   if rounds>=125 then error('Limite de seguranca: 125 rodadas')end
   task.wait(1.1)
  end
  -- Confere o inventario depois da pilha, antes de escolher outro tipo.
  local _,checkGrid=openInventory();local after=boxSlots(checkGrid)
  local same=false
  for _,b in ipairs(after)do if b.name==name then same=true;break end end
  if same then
   -- Nao continuar indefinidamente se o jogo nao consumiu as caixas.
   status.Text='⚠️ Ainda ha caixas desse tipo; conferindo...'
  end
  task.wait(.5)
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
 if not ok then status.Text='❌ '..tostring(err);warn('[FrutasHubV11]',err)end
 busy=false
 return ok
end
farmBtn.MouseButton1Click:Connect(function()
 farm=not farm
 if farm then local any=false;for _,v in pairs(selected)do if v then any=true;break end end;if not any then farm=false;status.Text='Selecione uma raridade primeiro!'end end
 farmBtn.Text=farm and '■ FARM ON' or '▶ FARM OFF';if not farm then restore();moveStop()end
end)
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
-- Anti-Spartabox: exige que o jogador tenha SAIDO da regiao da base,
-- detecta movimento rapido / deslocamento, e somente entao reconhece retorno estavel.
local base=Vector3.new(-507.24,133.10,-158.23)
local armed=false;local launch=false;local lastPos=nil;local lastTick=os.clock();local stableSince=nil;local cooldown=0
local function textureButton()
 -- Procura um botao com texto TEXTURAS na GUI, sem adivinhar um caminho.
 local best
 for _,o in ipairs(pg:GetDescendants())do
  if (o:IsA('TextButton') or o:IsA('ImageButton')) and visible(o) then
   local text=o:IsA('TextButton') and o.Text or ''
   if text:upper():find('TEXTURAS',1,true) then best=o;break end
   for _,c in ipairs(o:GetDescendants())do if c:IsA('TextLabel') and c.Text:upper():find('TEXTURAS',1,true)then best=o;break end end
   if best then break end
  end
 end
 return best
end
task.spawn(function()
 while running and gui.Parent do
  if anti and not busy then
   local _,hum,root=character()
   if hum and root and hum.Health>0 then
    local now=os.clock();local pos=root.Position;local dist=(pos-base).Magnitude
    local dt=math.max(.1,now-lastTick);local speed=lastPos and (pos-lastPos).Magnitude/dt or 0
    if dist>70 then armed=true end
    if armed and (speed>85 or root.AssemblyLinearVelocity.Magnitude>85)then launch=true end
    if armed and launch and dist<14 and now>cooldown then
     local slow=root.AssemblyLinearVelocity.Magnitude<7 and speed<7
     if slow then stableSince=stableSince or now else stableSince=nil end
     if stableSince and now-stableSince>1.3 then
      local btn=textureButton()
      if btn then
       status.Text='👹 Voltou a base! TEXTURAS...'
       busy=true;moveStop();local ok,err=pcall(function()tapGui(btn,0,0)end);busy=false
       if not ok then status.Text='❌ TEXTURAS: '..tostring(err)end
       cooldown=now+15;armed=false;launch=false;stableSince=nil
      else status.Text='⚠️ Botao TEXTURAS nao encontrado';cooldown=now+5 end
     end
    else stableSince=nil end
    lastPos=pos;lastTick=now
   end
  else lastPos=nil;lastTick=os.clock()end
  task.wait(.35)
 end
end)
_G.FrutasHubStop=function()
 running=false;farm=false;autoOpen=false;autoSell=false;anti=false;restore();moveStop();if gui.Parent then gui:Destroy()end
end
