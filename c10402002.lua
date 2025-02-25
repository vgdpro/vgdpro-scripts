local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.OverDress(c,10101009)
	vgd.AbilityAuto(c,m,LOCATION_HAND,EFFECT_TYPE_FIELD,EVENT_BATTLED,cm.op,vgf.OverlayCost(2),cm.con)
	vgd.AbilityCont(c, m, LOCATION_MZONE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 10000, cm.con2)
	vgd.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, 10000, EFFECT_UPDATE_DEFENSE, cm.con2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	if c:IsRelateToEffect(e) or not c:IsFaceup() then
		if g:GetCount()>1 then
			g=g:Select(tp,1,1,nil)
		end
		if g:GetCount()>0 then
			vgf.Sendto(LOCATION_MZONE,c,SUMMON_VALUE_OVERDRESS,tp,vgf.SequenceToGlobal(tp,g:GetFirst():GetLocation(),g:GetFirst():GetSequence()))
		end
	end
	vgf.OverlayFill(1)(e,tp,eg,ep,ev,re,r,rp)
end
function cm.filter(c)
	return c:IsCode(10101009) and vgf.RMonsterFilter(c)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsCode(10101009) and vgf.GetVMonster(tp):IsCode(10101001)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(FLAG_CONDITION)==201 and (vgf.RMonsterCondition(e) or not c:IsLocation(LOCATION_MZONE))
end