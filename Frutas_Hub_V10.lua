-- FRUTAS HUB V10 - FARM + MINIGAME + ABERTURA + VENDA
-- Use somente onde voce tem permissao para automatizar.
local Players=game:GetService('Players')
local CoreGui=game:GetService('CoreGui')
local VIM=game:GetService('VirtualInputManager')
local player=Players.LocalPlayer
local pg=player:WaitForChild('PlayerGui')
if type(_G.FrutasHubStop)=='function' then pcall(_G.FrutasHubStop) end
local parent=pg
if type(gethui)=='function' then local ok,r=pcall(gethui);if ok and r then parent=r end else pcall(function()parent=CoreGui end)end
for _,p in ipairs({pg,CoreGui,parent})do pcall(function()for _,n in ipairs({'FrutasHubV5','FrutasHubV6','FrutasHubV7','FrutasHubV10','FrutasHubAbrirV8','FrutasHubAbrirV9','TesteCaixaV7'})do local old=p:FindFirstChild(n);if old then old:Destroy()end end end)end
local gui=Instance.new('ScreenGui');gui.Name='FrutasHubV10';gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=999999;gui.Parent=parent
local function criar(t,props,p)local o=Instance.new(t);for k,v in pairs(props)do o[k]=v end;o.Parent=p;return o end
local function arredondar(o)criar('UICorner',{CornerRadius=UDim.new(0,8)},o)end
local function botao(p,texto,x,y,w,h,cor)local b=criar('TextButton',{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=cor or Color3.fromRGB(55,65,90),Text=texto,TextColor3=Color3.new(1,1,1),TextSize=12,Font=Enum.Font.GothamBold},p);arredondar(b);return b end
local painel=criar('Frame',{Size=UDim2.fromOffset(270,510),Position=UDim2.new(.5,-135,.5,-255),BackgroundColor3=Color3.fromRGB(24,27,40),Active=true,Draggable=true},gui);arredondar(painel)
criar('TextLabel',{Position=UDim2.fromOffset(8,4),Size=UDim2.fromOffset(220,28),BackgroundTransparency=1,Text='🍎 FRUTAS HUB V10',TextColor3=Color3.new(1,1,1),TextSize=16,Font=Enum.Font.GothamBold},painel)
local fechar=botao(painel,'X',235,5,29,27,Color3.fromRGB(190,55,65))
local abrir=botao(gui,'🍎',12,180,48,48,Color3.fromRGB(45,110,215));abrir.Visible=false;abrir.Active=true;abrir.Draggable=true
fechar.MouseButton1Click:Connect(function()painel.Visible=false;abrir.Visible=true end)
abrir.MouseButton1Click:Connect(function()painel.Visible=true;abrir.Visible=false end)
local status=criar('TextLabel',{Position=UDim2.fromOffset(8,34),Size=UDim2.fromOffset(254,30),BackgroundTransparency=1,Text='Status: Desligado',TextColor3=Color3.fromRGB(155,235,180),TextSize=11,TextWrapped=true},painel)
local lista=criar('ScrollingFrame',{Position=UDim2.fromOffset(8,66),Size=UDim2.fromOffset(254,106),BackgroundColor3=Color3.fromRGB(35,39,54),ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0)},painel);arredondar(lista)
local layout=criar('UIListLayout',{Padding=UDim.new(0,3)},lista)
local raridades={{'Comum','CaixaComum'},{'Incomum','CaixaIncomum'},{'Rara','CaixaRara'},{'Epica','CaixaEpica'},{'Lendaria','CaixaLendaria'},{'Mitica','CaixaMitica'},{'Secreta','CaixaSecreta'},{'Especial','CaixaEspecial'},{'Admin','CaixaAdmin'}}
local selecionadas={}
for _,item in ipairs(raridades)do local nome,interno=item[1],item[2];local b=criar('TextButton',{Size=UDim2.new(1,-6,0,26),BackgroundColor3=Color3.fromRGB(48,52,70),Text='☐ '..nome,TextColor3=Color3.new(1,1,1),TextSize=12},lista);arredondar(b);b.MouseButton1Click:Connect(function()selecionadas[interno]=not selecionadas[interno];local marcado=selecionadas[interno];b.Text=(marcado and '☑ ' or '☐ ')..nome;b.BackgroundColor3=marcado and Color3.fromRGB(35,125,80)or Color3.fromRGB(48,52,70)end)end
layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()lista.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+5)end)
local iniciar=botao(painel,'▶ INICIAR FARM',8,179,254,32,Color3.fromRGB(30,150,90))
local velocidade=28
local velTexto=criar('TextLabel',{Position=UDim2.fromOffset(8,215),Size=UDim2.fromOffset(254,18),BackgroundTransparency=1,Text='🏃 Velocidade: 28',TextColor3=Color3.new(1,1,1),TextSize=12},painel)
local velMenos=botao(painel,'-2',37,235,65,25);local velMais=botao(painel,'+2',165,235,65,25)
local function atualizarVel()velTexto.Text='🏃 Velocidade: '..velocidade end
velMenos.MouseButton1Click:Connect(function()velocidade=math.max(16,velocidade-2);atualizarVel()end)
velMais.MouseButton1Click:Connect(function()velocidade=math.min(40,velocidade+2);atualizarVel()end)
local ajusteX,ajusteY=0,35
local ajusteTexto=criar('TextLabel',{Position=UDim2.fromOffset(8,264),Size=UDim2.fromOffset(254,19),BackgroundTransparency=1,Text='🎯 Clique X: 0 | Y: +35',TextColor3=Color3.new(1,1,1),TextSize=12},painel)
local esquerda=botao(painel,'◀',18,286,45,25);local direita=botao(painel,'▶',76,286,45,25);local cima=botao(painel,'▲',150,286,45,25);local baixo=botao(painel,'▼',208,286,45,25)
local function atualizarClique()ajusteTexto.Text=string.format('🎯 Clique X: %+d | Y: %+d',ajusteX,ajusteY)end
esquerda.MouseButton1Click:Connect(function()ajusteX=ajusteX-10;atualizarClique()end)
direita.MouseButton1Click:Connect(function()ajusteX=ajusteX+10;atualizarClique()end)
cima.MouseButton1Click:Connect(function()ajusteY=ajusteY-10;atualizarClique()end)
baixo.MouseButton1Click:Connect(function()ajusteY=ajusteY+10;atualizarClique()end)
local info=criar('TextLabel',{Position=UDim2.fromOffset(8,314),Size=UDim2.fromOffset(254,25),BackgroundTransparency=1,Text='Minigame: aguardando',TextColor3=Color3.fromRGB(190,200,220),TextSize=11,TextWrapped=true},painel)
local autoAbrir=false;local autoVender=false
local toggleAbrir=botao(painel,'📦 AUTO ABRIR: OFF',8,343,254,30)
local toggleVender=botao(painel,'💰 AUTO VENDER: OFF',8,377,254,30)
local abrirAgora=botao(painel,'📦 ABRIR AGORA',8,411,123,30,Color3.fromRGB(45,110,170))
local venderAgora=botao(painel,'💰 VENDER AGORA',139,411,123,30,Color3.fromRGB(45,110,170))
local aviso=criar('TextLabel',{Position=UDim2.fromOffset(8,444),Size=UDim2.fromOffset(254,57),BackgroundTransparency=1,Text='Auto abrir: ao atingir 125 caixas. Auto vender: ao atingir 125 frutas. Favoritas preservadas pela opcao do jogo.',TextColor3=Color3.fromRGB(190,200,220),TextSize=10,TextWrapped=true},painel)
local ligado=false;local executando=true;local ocupado=false;local velocidadesOriginais={};local ultimoUso=0;local pedido=nil
local function personagem()local char=player.Character;if not char then return end;return char,char:FindFirstChildOfClass('Humanoid'),char:FindFirstChild('HumanoidRootPart')end
local function ajustarVelocidade()local _,hum=personagem();if not hum then return end;if velocidadesOriginais[hum]==nil then velocidadesOriginais[hum]=hum.WalkSpeed end;hum.WalkSpeed=velocidade end
local function restaurar()for hum,v in pairs(velocidadesOriginais)do pcall(function()if hum.Parent then hum.WalkSpeed=v end end)end;velocidadesOriginais={}end
local function ferramenta()local char,hum=personagem();if not char or not hum then return end;local equipada=char:FindFirstChildOfClass('Tool');if equipada then return equipada end;local mochila=player:FindFirstChild('Backpack');if not mochila then return end;local primeira;for _,tool in ipairs(mochila:GetChildren())do if tool:IsA('Tool')then primeira=primeira or tool;local nome=tool.Name:lower();if nome:find('mao')or nome:find('mão')or nome:find('hand')or nome:find('pegar')then hum:EquipTool(tool);return tool end end end;if primeira then hum:EquipTool(primeira);return primeira end end
local function parte(obj)if obj:IsA('BasePart')then return obj end;if obj:IsA('Model')then return obj.PrimaryPart or obj:FindFirstChildWhichIsA('BasePart',true)end end
local function procurar()local _,_,root=personagem();if not root then return end;local pasta=workspace:FindFirstChild('CaixasAtivas');if not pasta then return end;local melhor,menor=nil,math.huge;for _,obj in ipairs(pasta:GetDescendants())do if selecionadas[obj.Name]then local p=parte(obj);if p then local d=(root.Position-p.Position).Magnitude;if d<menor then melhor,menor=p,d end end end end;return melhor,menor end
local function toque(x,y,hold)if not executando then error('Hub desligado')end;VIM:SendMouseButtonEvent(x,y,0,true,game,0);task.wait(hold or .12);VIM:SendMouseButtonEvent(x,y,0,false,game,0)end
local function clicarMinigame(b)if not b or not b.Parent or not b.Visible then return false end;local pos=b.AbsolutePosition;local tam=b.AbsoluteSize;return pcall(function()toque(pos.X+tam.X/2+ajusteX,pos.Y+tam.Y/2+ajusteY,.045)end)end
local function botoesVisiveis(numeros)local encontrados={};for _,obj in ipairs(numeros:GetDescendants())do if obj:IsA('TextButton')and obj.Name:match('^N%d+$')and obj.Visible and obj.AbsoluteSize.X>0 and obj.AbsoluteSize.Y>0 then table.insert(encontrados,obj)end end;table.sort(encontrados,function(a,b)return tonumber(a.Name:match('%d+'))<tonumber(b.Name:match('%d+'))end);return encontrados end
local function minigame()local mg=pg:FindFirstChild('MinigameCaixaGui');if not mg or not mg.Enabled then info.Text='Minigame: aguardando';return false end;local numeros=mg:FindFirstChild('Numeros');if not numeros then return false end;local encontrados=botoesVisiveis(numeros);info.Text='Minigame: '..#encontrados..' botoes visiveis';for _,b in ipairs(encontrados)do if not ligado or ocupado or not mg.Enabled then break end;if b.Parent and b.Visible then clicarMinigame(b);task.wait(.035)end end;return true end
local function ativarMao()local tool=ferramenta();if not tool then return end;if os.clock()-ultimoUso<.8 then return end;ultimoUso=os.clock();pcall(function()tool:Activate()end)end
local function caminho(root,...)local obj=root;for _,nome in ipairs({...})do if not obj then error('Nao encontrado: '..nome)end;obj=obj:WaitForChild(nome,5);if not obj then error('Nao encontrado: '..nome)end end;return obj end
local function visivel(obj)if not obj or not obj.Visible then return false end;local p=obj.Parent;while p do if p:IsA('GuiObject')and not p.Visible then return false end;if p:IsA('ScreenGui')and not p.Enabled then return false end;p=p.Parent end;return true end
local function esperar(fn,tempo)local inicio=os.clock();while executando and os.clock()-inicio<tempo do local ok,res=pcall(fn);if ok and res then return res end;task.wait(.2)end;return nil end
local function clicarCalibrado(obj,ox,oy)if not obj then error('Botao ausente')end;local p,s=obj.AbsolutePosition,obj.AbsoluteSize;toque(p.X+s.X/2+ox,p.Y+s.Y/2+oy)end
local function quantidadeLabel(nome)local inv=pg:FindFirstChild('BackpackGui');inv=inv and inv:FindFirstChild('Backpack');inv=inv and inv:FindFirstChild('Inventory');local top=inv and inv:FindFirstChild('TopbarMochila');local etiquetas=top and top:FindFirstChild('Etiquetas');local item=etiquetas and etiquetas:FindFirstChild(nome);local valor=item and item:FindFirstChild('Valor');if not valor then return nil end;local a,b=tostring(valor.Text):match('(%d+)%s*/%s*(%d+)');return tonumber(a),tonumber(b)end
local function mochilaObjetos()local bot=caminho(pg,'TopbarStandard','Holders','Left','Inventory','IconButton','Menu','IconSpot','ClickRegion');local inv=caminho(pg,'BackpackGui','Backpack','Inventory');return bot,inv end
local function abrirMochila()local bot,inv=mochilaObjetos();if not inv.Visible then clicarCalibrado(bot,50,60)end;if not esperar(function()return inv.Visible end,5)then error('Mochila nao abriu')end;task.wait(.5);return inv end
local function fecharMochila(inv)local tela=workspace.CurrentCamera.ViewportSize;toque(tela.X*.85+20,tela.Y*.75);if not esperar(function()return not inv.Visible end,5)then error('Mochila nao fechou')end;task.wait(.5)end
local function qtdSlot(slot)local prev=slot:FindFirstChild('Preview3D',true);local qtd=prev and prev:FindFirstChild('Quantidade',true);if qtd and qtd:IsA('TextLabel')then return tonumber(qtd.Text:match('%d+'))or 1 end;return 1 end
local function caixasGrid(grid)local slots={};local total=0;for _,slot in ipairs(grid:GetChildren())do if slot:IsA('GuiButton')and slot.Visible then local nome=slot:FindFirstChild('ToolName',true);if nome and nome:IsA('TextLabel')and nome.Text:lower():find('caixa',1,true)then local qtd=qtdSlot(slot);total=total+qtd;table.insert(slots,{slot=slot,nome=nome.Text,quantidade=qtd})end end end;table.sort(slots,function(a,b)local na,nb=tonumber(a.slot.Name),tonumber(b.slot.Name);if na and nb then return na<nb end;return a.slot.Name<b.slot.Name end);return slots[1],total end
local function painelAbertura()local g=pg:FindFirstChild('AbrirCaixaGui');return g and g:FindFirstChild('Painel')end
local function resultadoAbertura()local g=pg:FindFirstChild('AbrirVariasGui');local f=g and g:FindFirstChild('Frame');return f and f:FindFirstChild('Ok')end
local function abrirCaixasTodas()
 local rodadas=0
 while executando and rodadas<100 do
  status.Text='📦 Procurando caixas...'
  local inv=abrirMochila();local aba=caminho(inv,'AbasMochila','Aba_caixas');clicarCalibrado(aba,40,60);task.wait(.8)
  local grid=caminho(inv,'ScrollingFrame','UIGridFrame');local caixa,totalAnterior=caixasGrid(grid)
  if not caixa then status.Text='✅ Caixas esgotadas';fecharMochila(inv);return end
  status.Text='📦 '..caixa.nome..' x'..caixa.quantidade
  clicarCalibrado(caixa.slot,50,60);task.wait(.8);fecharMochila(inv)
  local tela=workspace.CurrentCamera.ViewportSize;toque(tela.X*.5,tela.Y*.7)
  local painelAbrir=esperar(function()local p=painelAbertura();if visivel(p)then return p end end,7)
  if not painelAbrir then error('Confirmacao ABRIR CAIXA nao apareceu')end
  if caixa.quantidade==1 then
   local sim=painelAbrir:FindFirstChild('Sim');if not visivel(sim)then error('SIM nao encontrado')end
   clicarCalibrado(sim,30,60)
   if not esperar(function()return not visivel(painelAbrir)end,12)then error('Abertura individual nao terminou')end
   task.wait(2)
  else
   local varias=painelAbrir:FindFirstChild('Varias');if not visivel(varias)then error('ABRIR NX nao encontrado')end
   clicarCalibrado(varias,70,60)
   local resultado=esperar(function()local b=resultadoAbertura();if visivel(b)then return b end end,12)
   if not resultado then error('PULAR/OK nao apareceu')end
   local pular=esperar(function()return visivel(resultado)and resultado.Text:upper():find('PULAR',1,true)end,6)
   if pular then clicarCalibrado(resultado,60,75)end
   local okFinal=esperar(function()return visivel(resultado)and resultado.Text:upper():find('OK',1,true)end,12)
   if not okFinal then error('OK nao apareceu')end
   clicarCalibrado(resultado,60,75)
   if not esperar(function()return not visivel(resultado)end,8)then error('Resultado nao fechou')end
  end
  status.Text='⏳ Atualizando inventario...'
  local atualizou=esperar(function()local _,total=caixasGrid(grid);return total<totalAnterior end,8)
  if not atualizou then task.wait(1);local inv2=abrirMochila();clicarCalibrado(caminho(inv2,'AbasMochila','Aba_caixas'),40,60);task.wait(.6);local _,total=caixasGrid(grid);if total>=totalAnterior then error('Caixas nao diminuiram; interrompido')end;fecharMochila(inv2)end
  if not esperar(function()return not visivel(painelAbertura())and not visivel(resultadoAbertura())end,8)then error('Janela anterior continua aberta')end
  rodadas=rodadas+1;task.wait(1.2)
 end
 if rodadas>=100 then error('Limite de seguranca: 100 rodadas')end
end
local function encontrarOpcaoVendedor(guiV,texto)
 for _,obj in ipairs(guiV:GetDescendants())do
  if obj:IsA('TextButton')and visivel(obj)then
   if tostring(obj.Text):lower():find(texto,1,true)then return obj end
   for _,child in ipairs(obj:GetDescendants())do if (child:IsA('TextLabel')or child:IsA('TextButton'))and tostring(child.Text):lower():find(texto,1,true)then return obj end end
  end
 end
 return nil
end
local function venderFrutas()
 status.Text='💰 Abrindo vendedor...'
 local botaoVender=caminho(pg,'BotoesTopoGui','Botoes','Vender','Conteudo','Botao')
 clicarCalibrado(botaoVender,60,60);task.wait(.6)
 local npc=caminho(workspace,'VendedorNPC','HumanoidRootPart','PromptVendedor')
 if type(fireproximityprompt)~='function'then error('Executor sem fireproximityprompt')end
 fireproximityprompt(npc)
 local vendedor=esperar(function()return pg:FindFirstChild('VendedorGui')end,7)
 if not vendedor then error('VendedorGui nao apareceu')end
 local vender=esperar(function()return encontrarOpcaoVendedor(vendedor,'quero vender todas')end,8)
 if not vender then error('Opcao vender todas nao apareceu')end
 status.Text='💰 Vendendo frutas nao favoritas...';clicarCalibrado(vender,60,60)
 local fechado=esperar(function()return encontrarOpcaoVendedor(vendedor,'fechado!')end,8)
 if not fechado then error('Botao Fechado! nao apareceu')end
 clicarCalibrado(fechado,60,60);task.wait(1)
 status.Text='✅ Venda concluida'
end
local function pararMovimento()local _,hum,root=personagem();if hum and root then hum:MoveTo(root.Position)end end
local function fazerAcao(acao)
 if ocupado or not executando then return false end
 ocupado=true;pararMovimento();restaurar()
 local ok,erro=pcall(function()if acao=='abrir'then abrirCaixasTodas()elseif acao=='vender'then venderFrutas()end end)
 if not ok then status.Text='❌ '..acao..': '..tostring(erro);warn('[FrutasHubV10] '..tostring(erro))end
 ocupado=false
 return ok
end
local function pedidoManual(acao)if ocupado then status.Text='⏳ Aguarde a tarefa atual';return end;pedido=acao end
abrirAgora.MouseButton1Click:Connect(function()pedidoManual('abrir')end)
venderAgora.MouseButton1Click:Connect(function()pedidoManual('vender')end)
toggleAbrir.MouseButton1Click:Connect(function()autoAbrir=not autoAbrir;toggleAbrir.Text='📦 AUTO ABRIR: '..(autoAbrir and 'ON' or 'OFF');toggleAbrir.BackgroundColor3=autoAbrir and Color3.fromRGB(35,125,80)or Color3.fromRGB(55,65,90)end)
toggleVender.MouseButton1Click:Connect(function()autoVender=not autoVender;toggleVender.Text='💰 AUTO VENDER: '..(autoVender and 'ON' or 'OFF');toggleVender.BackgroundColor3=autoVender and Color3.fromRGB(35,125,80)or Color3.fromRGB(55,65,90)end)
iniciar.MouseButton1Click:Connect(function()
 ligado=not ligado
 if ligado then local tem=false;for _,v in pairs(selecionadas)do if v then tem=true;break end end;if not tem then ligado=false;status.Text='Selecione uma raridade!';return end end
 iniciar.Text=ligado and '■ PARAR FARM' or '▶ INICIAR FARM';iniciar.BackgroundColor3=ligado and Color3.fromRGB(190,65,65)or Color3.fromRGB(30,150,90)
 if not ligado then restaurar();pararMovimento();status.Text='Status: Farm desligado'end
end)
local ultimoAutoAbrir=0;local ultimoAutoVender=0
-- Executor unico para evitar cliques concorrentes
 task.spawn(function()
 while executando and gui.Parent do
  if not ocupado then
   if pedido then local acao=pedido;pedido=nil;fazerAcao(acao)
   elseif ligado then
    local qtdCaixas,capCaixas=quantidadeLabel('Etiqueta_QtdCaixas')
    local qtdFrutas,capFrutas=quantidadeLabel('Etiqueta_QtdCamisas')
    if autoVender and qtdFrutas and capFrutas and qtdFrutas>=capFrutas and os.clock()-ultimoAutoVender>12 then
     ultimoAutoVender=os.clock();fazerAcao('vender')
    elseif autoAbrir and qtdCaixas and capCaixas and qtdCaixas>=capCaixas and os.clock()-ultimoAutoAbrir>12 then
     ultimoAutoAbrir=os.clock();fazerAcao('abrir')
    else
     local _,hum,root=personagem()
     if hum and root and hum.Health>0 then
      ajustarVelocidade()
      if minigame()then hum:MoveTo(root.Position);status.Text='Resolvendo minigame...'
      else ferramenta();local caixa,d=procurar();if caixa then if d>1.5 then hum:MoveTo(caixa.Position);status.Text='Indo ate caixa: '..math.floor(d)..' studs' else hum:MoveTo(root.Position);ativarMao();status.Text='Ativando mao...'end else status.Text='Nenhuma caixa encontrada'end end
     end
    end
   end
  end
  task.wait(.10)
 end
 end)
_G.FrutasHubStop=function()ligado=false;executando=false;pedido=nil;restaurar();pararMovimento();gui:Destroy()end
