local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.DisCardCost(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetVMonster(tp):IsCode(10401003)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=vgf.AtkUp(c,c,5000)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
	end
	if vgf.GetVMonster(tp):GetOverlayCount()>=10 then
		Duel.BreakEffect()
		vgf.OverlayFill(1)
	end
end