local library = loadstring(game:HttpGet("https://pastebin.com/raw/tqKTJQAA", true))();
local run = game:service("RunService");
local runcon;players=game:service("Players");
player=players.LocalPlayer;camera=workspace.CurrentCamera;
local uis=game:service("UserInputService");
local curc;
local mouse=player:GetMouse();
local toggles={abk=Enum.UserInputType.MouseButton2;iag=false;};local traced={};local tsp=Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2 + 400);local gs=game:GetService("GuiService"):GetGuiInset();local sc=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2);local mousemoverel = mousemoverel or Input.MoveMouse;local hookfunction = hookfunction or detour_function or replaceclosure;local getnamecallmethod=getnamecallmethod or get_namecall_method;
local combat = library:CreateWindow('Aimbot');
local visuals = library:CreateWindow('Visuals');
visuals:Section('ESP');
visuals:Toggle('Tracers', {location = toggles,flag = "tracers"})
visuals:Toggle('Name ESP' ,{location = toggles ,flag = "nESP"});
visuals:Toggle('Box ESP' ,{location = toggles ,flag = "hESP"});
combat:Section('Aimbot')
combat:Toggle('Aimbot',{location=toggles,flag='aimbot'});
combat:Bind('Aimbot Hotkey', {location=toggles, flag='abk', kbonly=false, default=Enum.UserInputType.MouseButton2},
function(k,b)
    toggles.iag=b;
end);
combat:Dropdown('Aimpart', {location=toggles,flag='abp', list={"Head","UpperTorso","LowerTorso","HumanoidRootPart"}});
combat:Toggle('Draw FOV circle', {location=toggles, flag='showfov'})
combat:Toggle('Filled FOV circle', {location=toggles, flag='filled'})
combat:Slider('FOV', {location=toggles, flag='fov', precise=false, default=50, min=50, max=500});
function createline()
	local a=Drawing.new("Line");a.Thickness=1.5;a.Transparency=1;a.Visible=true;a.Color=Color3.fromRGB(0,240,90);
    a.From=tsp;
    return a;
end;
function createname(text)
    local a=Drawing.new("Text");a.Transparency=1;a.Visible=true;a.Color=Color3.fromRGB(0,240,90);a.Text=text;a.Size=15;
    return a;   
end;
function createcircle()
    local a=Drawing.new('Circle');a.Transparency=0.3;a.Thickness=1.5;a.Visible=true;a.Color=Color3.fromRGB(0,240,90);a.Filled=false;a.Radius=toggles.fov;
    return a;
end;
function createsquare()
    local a=Drawing.new('Square');a.Transparency=1;a.Thickness=1.5;a.Visible=true;a.Color=Color3.fromRGB(0,240,90);a.Filled=false;
    return a;
end;
curc=createcircle();
function isInTeam(char)
	if player and players:GetPlayerFromCharacter(char) and players:GetPlayerFromCharacter(char).Team and player.Team then
		if player.FriendlyFire.Value then
			return false;
		else
			return (player.Team==players:GetPlayerFromCharacter(char).Team);
		end;	
	end;
end;
local gc = function()
	local nearest = math.huge
	local nearplr;
	for i,v in pairs(players:GetPlayers()) do
		if v ~= player and v.Character and not isInTeam(v.Character) and v.Character:FindFirstChild(toggles.abp) then
			local pos = camera:WorldToScreenPoint(v.Character[toggles.abp].Position)
			local diff = math.sqrt((pos.X - sc.X)^2 + (pos.Y+gs.Y - sc.Y)^2)
			if diff < nearest and diff < toggles.fov then
				nearest=diff;
				nearplr=v;
			end
		end;
	end;
	return nearplr
end;
local getrel = function(x, y)
	local newy;
	local newy;
	if x > sc.X then
		newx = -(sc.X - x)
		newx = newx/5
	else
		newx = x - sc.X
		newx = newx/5
	end;
	if y > sc.Y then
		newy = -(sc.Y - y)
		newy = newy/5
	else
		newy = y - sc.Y
		newy = newy/5
	end;
	return newx, newy
end;

run.Stepped:Connect(function()
    spawn(function()
        for i,v in pairs(players:GetChildren()) do
            if v.Character and v.Character:FindFirstChild(toggles.abp) and (not isInTeam(v.Character)) and (toggles.tracers or toggles.nESP or toggles.hESP) then
                if not traced[v.Name] then
                    traced[v.Name]={v.Character};    
                end;  
                local vector, onScreen= camera:WorldToScreenPoint(v.Character[toggles.abp].Position)
                if toggles.tracers then
                    if traced[v.Name][2] then
                        traced[v.Name][2].Visible=(onScreen and toggles.tracers);traced[v.Name][2].To=Vector2.new(vector.X, vector.Y+gs.Y);	
                    else
                        traced[v.Name][2]=createline();traced[v.Name][2].Visible=(onScreen and toggles.tracers);traced[v.Name][2].To=Vector2.new(vector.X, vector.Y+gs.Y);
                    end;
                end;
                if toggles.nESP then    
                    if traced[v.Name][3] then
                        traced[v.Name][3].Visible=(onScreen and toggles.nESP);traced[v.Name][3].Position=Vector2.new(vector.X, vector.Y+(gs.Y/2));	
                    else
                        traced[v.Name][3]=createname(v.Name);traced[v.Name][3].Visible=(onScreen and toggles.nESP);traced[v.Name][3].Position=Vector2.new(vector.X, vector.Y+(gs.Y/2));
                    end;   
				end;
				if toggles.hESP then
					if traced[v.Name][4] then
                        traced[v.Name][4].Visible=(onScreen and toggles.hESP);traced[v.Name][4].Size=Vector2.new(1400/vector.Z,1400/vector.Z);traced[v.Name][4].Position=Vector2.new((vector.X)-traced[v.Name][4].Size.X/2, (vector.Y+(gs.Y))-traced[v.Name][4].Size.Y/2);
                    else
                        traced[v.Name][4]=createsquare();traced[v.Name][4].Visible=(onScreen and toggles.hESP);traced[v.Name][4].Size=Vector2.new(1400/vector.Z,1400/vector.Z);traced[v.Name][4].Position=Vector2.new((vector.X)-traced[v.Name][4].Size.X/2, (vector.Y+(gs.Y))-traced[v.Name][4].Size.Y/2);
                    end; 
				end		
            else
                if traced[v.Name] then
                    if traced[v.Name][2] then
                        traced[v.Name][2]:Remove();traced[v.Name][2]=nil;
                    end;   
                    if traced[v.Name][3] then
                        traced[v.Name][3]:Remove();traced[v.Name][3]=nil;
					end
					if traced[v.Name][4] then
                        traced[v.Name][4]:Remove();traced[v.Name][4]=nil;
                    end
                end;   
            end;    
        end;       
    end);
    spawn(function()
        if toggles.showfov then
            curc.Visible=true;curc.Position = Vector2.new(mouse.X, mouse.Y+gs.Y);curc.Radius=toggles.fov;
        else
            curc.Visible=false;
        end;    
    end);
    spawn(function()
        if toggles.filled then
            toggles.showfov = true
            curc.Filled = true
        else
            curc.Filled = false
        end 
    end)
    spawn(function()
        if toggles.aimbot and toggles.iag then
            if gc()~=nil and gc().Character:FindFirstChild(toggles.abp) then
                local pos=camera:WorldToScreenPoint(gc().Character[toggles.abp].Position)
                local x,y=getrel(pos.X, pos.Y+gs.Y)
                mousemoverel(x,y)
            end;
        end;    
    end);   
end);    
local fr;
players.PlayerRemoving:Connect(function(p)
    if traced[p.Name] then 
        if traced[p.Name][2] then 
            traced[p.Name][2]:Remove();traced[p.Name][2]=nil;
        end;
        if traced[p.Name][3] then
             traced[p.Name][3]:Remove();traced[p.Name][3]=nil;
            end;
            if traced[p.Name][4] then 
                traced[p.Name][4]:Remove();traced[p.Name][4]=nil;
            end;traced[p.Name]=nil;
        end;
    end);
