local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAuto(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_PHASE+PHASE_END,cm.op1,nil,cm.con1)
	if not cm.global_check then
        cm.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetCondition(cm.checkcon)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_VALUE_REVOLT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,15000)
		if Duel.GetFlagEffect(tp,m)>0 then vgf.StarUp(c,c,1) end
	end
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SELFRIDE)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and vgf.RMonsterCondition(e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_Call)
	local g=vgf.GetVMonster(tp):GetOverlayGroup():FilterSelect(tp,cm.filter,1,1,nil,e,tp)
	vgf.Sendto(LOCATION_CIRCLE,g,SUMMON_TYPE_RIDE,tp,"FromOverlayToV",POS_FACEDOWN_DEFENCE)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x202) and vgf.IsCanBeCalled(c,e,tp,SUMMON_TYPE_RIDE,POS_FACEDOWN_DEFENCE,"FromOverlayToV")
end