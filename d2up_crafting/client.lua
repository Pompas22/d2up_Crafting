local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vSERVER = Tunnel.getInterface(GetCurrentResourceName())

onmenu = false


function closeMenu()
	SetNuiFocus(false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ hidemenu = true })
end


RegisterNUICallback('fechar',function (data)
	closeMenu()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("produzir",function(data,cb)
	vSERVER.craftar(data)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ MENU ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local timdistance = 1000
		for k,v in pairs(cfg.craftings) do
			local ped = PlayerPedId()
			local pedcds = GetEntityCoords(ped)
			local distance = #(pedcds - v.coords)
			
			if distance <= 15 and not onmenu then
				timdistance = 1
				DrawMarker(27, v.coords.x, v.coords.y, v.coords.z-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 255, 255, 255, 150, 0, 1, 0, 1)	
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						if vSERVER.checkPermission(v.perm) then
							SetNuiFocus(true,true)
							TransitionToBlurred(1000)
							SendNUIMessage({ showmenu = true,data = {craftings = v.itens,qtd = #v.itens,tipo = k} })
						end
					end
				end
			end
		end
		Citizen.Wait(timdistance)
	end
end)

-- [ FUNÇÃO DO TEXTO 3D ] --
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(2)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
	local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 50)
end