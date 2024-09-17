local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeContinuousChangeAttack(c,m,EFFECT_TYPE_SINGLE,5000,function(e) return vgf.RMonsterCondition(e) and cm.con(e) end)
	vgd.EffectTypeContinuousChangeDefense(c,m,EFFECT_TYPE_SINGLE,5000,cm.con)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,vgf.OverlayCost(1),vgf.RSummonCondition)
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,2,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if vgf.CheckPrison(tp) then
		local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,cm.filter1,tp,0,LOCATION_MZONE,1,1,nil)
		vgf.SendtoPrison(g,tp)
	end
end
function cm.filter1(c)
	return vgf.RMonsterFilter(c) and vgf.FrontFilter(c)
end