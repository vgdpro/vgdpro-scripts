--殷切的愿望 哈那耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c, m,nil,nil,EVENT_TO_G_CIRCLE,nil,vgf.DisCardCost(1))
end