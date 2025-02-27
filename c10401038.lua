local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.cost.SoulBlast(1),vgf.con.IsR,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.AtkUp(c,c,2000)
	local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,cm.filter,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.SendtoPrison(g,tp)
end
function cm.filter(c)
	return Card.IsSequence(c,0,4)
end