local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,vgf.op.SoulCharge(1),nil,cm.con)
	vgd.AbilityAct(c,m,LOCATION_SOUL,cm.op,cm.cost)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.filter.IsV(Duel.GetAttackTarget())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.Retire(e:GetHandler())(e,tp,eg,ep,ev,re,r,rp,chk) end
	vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.Retire(e:GetHandler())(e,tp,eg,ep,ev,re,r,rp,chk)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,vgf.filter.IsV,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.AtkUp(c,g,10000)
end