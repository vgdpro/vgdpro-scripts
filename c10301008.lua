--殷切的愿望 哈那耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c, m,nil,nil,EVENT_TO_G_CIRCLE,nil,vgf.cost.Discard(1))
end