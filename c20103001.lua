local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.cost.CounterBlast(1),vgf.con.IsV)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op1,vgf.cost.EnergyBlast(4),cm.con)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter,1,0)(e,tp,eg,ep,ev,re,r,rp)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,10000)
	end
end
function cm.filter(c)
	return c:IsCode(m)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsV(e) and Duel.GetAttackTarget():IsVanguard()end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_RMONSTER,e,tp,cm.filter,tp,LOCATION_CIRCLE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		g:AddCard(c)
        vgf.AtkUp(c,g,10000,nil)
    end
end