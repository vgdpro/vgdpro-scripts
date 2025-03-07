local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.OverDress(c,cm.filter)
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, cm.val, cm.con)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,cm.op,cm.cost,cm.con)
end
function cm.filter(c)
	return c:IsCode(10101009) or (c:IsLevelBelow(3) and c:GetFlagEffectLabel(FLAG_CONDITION)==201)
end
function cm.con(e)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(FLAG_CONDITION)==201 and vgf.con.IsR(e)
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
		return vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk) and vgf.cost.Discard(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	vgf.cost.CounterBlast(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	vgf.cost.Discard(1)(e,tp,eg,ep,ev,re,r,rp,chk)
end