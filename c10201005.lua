local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,VgF.DamageCost(1),cm.condition)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=vgf.AtkUp(c,c,10000)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterFilter(Duel.GetAttackTarget()) and vgf.RMonsterCondition(e) and vgf.IsExistingMatchingCard(vgf.IsSequence,tp,LOCATION_MZONE,0,3,nil,1,2,3)
end
