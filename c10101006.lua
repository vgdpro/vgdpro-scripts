--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.OverDress(c,10101009)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,nil,cm.condition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=vgf.AtkUp(c,c,5000,nil)
		vgf.effect.Reset(c,e1,EVENT_BATTLED)
	end
	if vgf.cost.SoulBlast(2)(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectEffectYesNo(tp,vgf.stringid(VgID,10)) then
        vgf.cost.SoulBlast(2)(e,tp,eg,ep,ev,re,r,rp,1)
		local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,Card.IsRearguard,tp,0,LOCATION_CIRCLE,1,1,nil)
		vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.con.IsR(e) and c:GetFlagEffectLabel(FLAG_CONDITION)==201 and Duel.GetAttackTarget():IsVanguard()end