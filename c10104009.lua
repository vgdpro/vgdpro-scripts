--意愿的少女 亚丽杭德拉
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c, m,nil,nil,EVENT_TO_G_CIRCLE,nil,vgf.cost.Discard(1))
end
