local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
    vgd.AbilityAct(c,m,LOCATION_MZONE,cm.operation,vgf.Rest(),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterCondition(e) and vgf.GetMatchingGroupCount(cm.filter,tp,LOCATION_ORDER,0,nil)<=1
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not vgf.CheckPrison(tp) then return end
	local g=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,tp,Card.IsType,tp,0,LOCATION_DROP,1,1,nil,TYPE_MONSTER)
	vgf.SendtoPrison(g,tp)
end