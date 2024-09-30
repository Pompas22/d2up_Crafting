local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
inProgress = {}

vSERVER = {}
Tunnel.bindInterface(GetCurrentResourceName(), vSERVER)


function vSERVER.craftar(data)
	local src = source
	local user_id = vRP.getUserId(src)
	local podefabricar = true
	if user_id then
		for e,g in pairs(cfg.craftings[data.tipo].itens[data.index+1].required) do
			if vRP.getInventoryItemAmount(user_id,e) < g then
				podefabricar = false
				TriggerClientEvent("Notify",src,"negado","Você não tem "..g.."x "..e)
			end
		end
		if podefabricar then
			if not inProgress[src] then
				for k,v in pairs(cfg.craftings[data.tipo].itens[data.index+1].required) do
					vRP.tryGetInventoryItem(user_id,k,v)
				end
				TriggerClientEvent("progress",src,cfg.craftings[data.tipo].itens[data.index+1].tempo*1000,"fazendo")
				vRPclient._playAnim(src,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
				inProgress[src] = true
				TriggerClientEvent("F6Cancel",src,true)
				SetTimeout(cfg.craftings[data.tipo].itens[data.index+1].tempo*1000,function()
					vRPclient._stopAnim(src,false)
					vRP.giveInventoryItem(user_id,cfg.craftings[data.tipo].itens[data.index+1].result,cfg.craftings[data.tipo].itens[data.index+1].resultqtd)
					TriggerClientEvent("Notify",src,"sucesso","Você fabricou "..cfg.craftings[data.tipo].itens[data.index+1].resultqtd.."x "..cfg.craftings[data.tipo].itens[data.index+1].result)
					inProgress[src] = false
					TriggerClientEvent("F6Cancel",src,false)
				end)

			else
				TriggerClientEvent("Notify",src,"negado","Termine a produção em progresso para iniciar outra")
			end
		end
	end
end

function vSERVER.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if not perm then return true end
	if type(perm) == "table" then
		for _,dataPerm in pairs(perm) do
			if vRP.hasPermission(user_id,dataPerm) then
				return true
			end
		end
		return false
	end
	return vRP.hasPermission(user_id,perm)
end
