--意愿的少女 亚丽杭德拉
dofile("script/VgFuncLib.lua")
dofile("script/VgD.Lua")
dofile("script/VgDefinition.Lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.CardToG(c,m,nil,vgf.DisCardCost(1))
end
