local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.op1,vgf.DamageCost(1),nil,nil,1)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 10000, cm.con)
	vgd.TriggerCountUp(c,m,1,cm.con2)
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and vgf.VMonsterCondition(e) and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not vgf.CheckPrison(tp) then return end
	local g1=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_CIRCLE,2,2,nil)
	vgf.SendtoPrison(g1,tp)
end
function cm.con2(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and vgf.VMonsterCondition(e) and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,3,nil)
end