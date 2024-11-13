local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【永】：这张卡将要被RIDE之际，这张卡也当做「朱斯贝克 “破天黎骑”」使用。
	vgf.AddRideMaterialCode(c,m,10406010)
	vgf.AddRideMaterialSetCard(c,m,0x300d,0x77,0x8a,0x202)
	--【反抗舞装】
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.operation,nil,cm.condition)
	--【永】【R】：这个回合中曾有你的等级3以上的先导者登场过的话，这个单位的力量+5000。
	vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,5000,cm.con)
	vgd.GlobalCheckEffect(c,m,EVENT_SPSUMMON_SUCCESS,cm.checkcon)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if vgf.Sendto(LOCATION_MZONE,g,SUMMON_VALUE_REVOLT,tp,0x20)>0 then
		local mg=Duel.GetOperatedGroup()
		vgd.TriggerCountUp(c,m,-2,nil,RESET_PHASE+PHASE_END,mg)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x76) and vgf.IsCanBeCalled(c,e,tp)
end
function cm.checkfilter(c)
	return vgf.IsSummonTypeV(c) and c:IsLevelAbove(3)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.checkfilter,1,nil)
end