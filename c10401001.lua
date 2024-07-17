local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.OverDress(c,cm.filter)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,cm.val,cm.con)
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.op,cm.cost,cm.con)
end
function cm.filter(c)
	return c:IsCode(10101009) or (c:IsLevelBelow(4) and c:GetFlagEffectLabel(FLAG_CONDITION)==201)
end
function cm.con(e)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(FLAG_CONDITION)==201 and vgf.RMonsterCondition(e)
end
function cm.val(e)
	local c=e:GetHandler()
	return c:GetOverlayCount()*5000
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ChangePosition(c,POS_FACEUP_ATTACK)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.DisCardCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.DisCardCost(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end