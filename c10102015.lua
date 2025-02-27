--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.Order(c,m,vgf.op.SoulCharge(2))
end