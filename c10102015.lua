--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.Rule(c)
	vgd.RideUp(c)
	vgd.CardTrigger(c,nil)
	vgd.SpellActivate(c,m,nil,cm.op,0,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)

end