dofile("script/VgFuncLib.lua")
dofile("script/VgD.Lua")
dofile("script/VgDefinition.Lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
end