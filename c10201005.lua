-- 【自】【R】：这个单位攻击先导者时，后列的你的后防者有3张以上的话，通过【费用】[计数爆发1]，这次战斗中，这个单位的力量+10000。
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,VgF.DamageCost(1),cm.condition)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		VgF.AtkUp(c,c,10000,EVENT_BATTLED)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_IGNORE_IMMUNE)
		c:RegisterEffect(e1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterFilter(Duel.GetAttackTarget()) and vgf.RMonsterCondition(e) and Duel.IsExistingMatchingCard(vgf.IsSequence,tp,LOCATION_MZONE,0,3,nil,1,2,3)
end
