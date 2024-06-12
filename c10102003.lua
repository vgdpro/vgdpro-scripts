local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con2)
    e1:SetValue(5000)
    c:RegisterEffect(e1)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(tp,ConditionFlag)==10102001
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE))
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if vgf.GetAvailableLocation(tp)&0x4<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
	local g=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():Select(tp,1,1,nil)
	vgf.Sendto(LOCATION_MZONE,g,0,tp,0x4)
	vgf.OverlayFill(1)(e,tp,eg,ep,ev,re,r,rp)
end
