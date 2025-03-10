local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,cm.cost,vgf.con.IsR,nil,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not vgf.CheckPrison(tp) then return end
	local g=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,tp,Card.IsRearguard,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.SendtoPrison(g,tp)
	if vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,3,nil) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end