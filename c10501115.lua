local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.Order(c,m,cm.op,vgf.cost.CounterBlast(1))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
	local c=e:GetHandler()
    local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,tp,nil,tp,LOCATION_CIRCLE,0,1,1,nil)
    vgf.AtkUp(c,g,5000)
end