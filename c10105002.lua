local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation,nil,vgf.VSummonCondition)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not vgf.CheckPrison(tp) then return end
	local g=vgf.SelectMatchingCard(HINTMSG_IMPRISON,e,1-tp,nil,tp,0,LOCATION_HAND,1,1,nil)
	vgf.SendtoPrison(g,tp)
end
function cm.con(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return vgf.RMonsterFilter(c) and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end