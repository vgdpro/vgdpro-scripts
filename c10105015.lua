local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.ContinuousSpell(c)
	vgd.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_MOVE,vgf.OverlayFill(3),nil,cm.con)
	vgd.CallInPrison(c,m)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=vgf.SelectMatchingCard(HINTMSG_POSCHANGE,e,tp,cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
end
function cm.cfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_ORDER)
end
