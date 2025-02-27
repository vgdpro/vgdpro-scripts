local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CHANGE_POS,cm.op,nil,cm.con,nil,1)
	vgd.action.GlobalCheckEffect(c,m,EVENT_SPSUMMON_SUCCESS,cm.checkcon)
    cm.is_has_continuous=true
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_SKILL)
    e1:SetRange(LOCATION_CIRCLE)
    e1:SetValue(SKILL_BOOST)
    e1:SetCondition(cm.condition)
    c:RegisterEffect(e1)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SELFRIDE)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0 and vgf.con.IsR(e)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPosition(POS_FACEUP_ATTACK) and eg:IsExists(Card.IsControler,1,c,tp) and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ChangePosition(c,POS_FACEUP_ATTACK)
end