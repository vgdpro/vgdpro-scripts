local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,cm.cost,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_ABYSSAL_DARK_NIGHT) and vgf.con.RideOnRCircle(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.SoulBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end