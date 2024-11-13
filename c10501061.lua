local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return not c:IsPreviousLocation(LOCATION_HAND) and vgf.RSummonCondition(e)
end
--对手要从手牌将卡CALL到G上之际，不将2张以上同时CALL的话则不能CALL出场。
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_ACTIVATE_COST)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetTarget(cm.costtg)
    e1:SetCost(cm.costchk)
    e1:SetOperation(cm.costop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function cm.costtg(e,re,tp)
    e:SetLabelObject(re:GetHandler())
    return re:IsHasCategory(CATEGORY_DEFENDER) and re:GetHandler():IsLocation(LOCATION_HAND) and re:GetHandlerPlayer()==tp and not vgf.IsExistingMatchingCard(nil,tp,LOCATION_GZONE,0,1,nil) and Duel.GetAttacker()==e:GetHandler()
end
function cm.costchk(e,re,tp)
    return vgf.IsExistingMatchingCard(vgf.IsAbleToGZone,tp,LOCATION_HAND,0,1,re:GetHandler(),LOCATION_HAND)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject()
	local g=vgf.SelectMatchingCard(HINTMSG_TO_GZONE,e,tp,vgf.IsAbleToGZone,tp,LOCATION_HAND,0,1,1,c,LOCATION_HAND)
    vgf.Sendto(LOCATION_GZONE,g,tp,POS_FACEUP,REASON_EFFECT)
end