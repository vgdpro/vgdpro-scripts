local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.operation,vgf.op.Rest(),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and vgf.GetMatchingGroupCount(cm.filter,tp,LOCATION_ORDER,0,nil)<=1
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not vgf.CheckPrison(tp) then return end
	local g=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,tp,Card.IsType,tp,0,LOCATION_DROP,1,1,nil,TYPE_UNIT)
	vgf.SendtoPrison(g,tp)
end