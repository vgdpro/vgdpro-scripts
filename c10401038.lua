local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAct(c,m,LOCATION_MZONE,cm.op,vgf.OverlayCost(1),vgf.RMonsterCondition,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.AtkUp(c,c,2000)
	local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
	vgf.SendtoPrison(g,tp)
end
function cm.filter(c)
	return vgf.IsSequence(c,0,4)
end