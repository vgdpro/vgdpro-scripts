local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【永】：这张卡将要被RIDE之际，这张卡也当做「朱斯贝克 “破天黎骑”」使用。
	--【反抗舞装】
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.operation,nil,cm.condition)
	--【永】【R】：这个回合中曾有你的等级3以上的先导者登场过的话，这个单位的力量+5000。
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con)
	VgD.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_SPSUMMON_SUCCESS,cm.checkcon,cm.checkop)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if vgf.Call(g,SUMMON_VALUE_REVOLT,tp,0x20)>0 then
		local mg=Duel.GetOperatedGroup()
		vgd.TriggerCountUp(c,-2,RESET_PHASE+PHASE_END,mg)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x76) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function cm.checkfilter(c)
	return (c:IsSummonType(SUMMON_TYPE_SELFRIDE) or c:IsSummonType(SUMMON_TYPE_RIDE)) and c:IsLevelAbove(4)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.checkfilter,1,nil)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end