local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.Order(c,m,cm.op,vgf.cost.SoulBlast(1),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not vgf.CheckPrison(tp) then return end
	local g=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,1-tp,nil,tp,0,LOCATION_HAND,1,1,nil)
	vgf.SendtoPrison(g,tp)
	if vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,3,nil) then
		Duel.BreakEffect()
		local sg=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_CIRCLE,0,1,1,nil)
		vgf.AtkUp(c,sg,5000)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)>=4
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end