local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
    vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.op,vgf.cost.CounterBlast(1),cm.con)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return vgf.RMonsterFilter(c) and eg:IsContains(c) and vgf.GetVMonster(tp):GetOverlayCount()>=5
end
--对手要从手牌将卡CALL到G上之际，不将2张以上同时CALL的话则不能CALL出场。
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_ACTIVATE_COST)
    e1:SetRange(LOCATION_CIRCLE)
    e1:SetTargetRange(0,1)
    e1:SetTarget(cm.costtg)
    e1:SetCost(cm.costchk)
    e1:SetOperation(cm.costop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
	vgf.EffectReset(c,e1,EVENT_BATTLED)
end
function cm.costtg(e,re,tp)
    e:SetLabelObject(re:GetHandler())
    return re:IsHasCategory(CATEGORY_DEFENDER) and re:GetHandler():IsLocation(LOCATION_HAND) and re:GetHandlerPlayer()==tp and not vgf.IsExistingMatchingCard(nil,tp,LOCATION_G_CIRCLE,0,1,nil) and Duel.GetAttacker()==e:GetHandler() and re:IsActiveType(TYPE_UNIT)
end
function cm.costchk(e,re,tp)
    return vgf.IsExistingMatchingCard(vgf.IsAbleToGCircle,tp,LOCATION_HAND,0,1,re:GetHandler(),LOCATION_HAND)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject()
	local g=vgf.SelectMatchingCard(HINTMSG_TO_G_CIRCLE,e,tp,vgf.IsAbleToGCircle,tp,LOCATION_HAND,0,1,1,c,LOCATION_HAND)
    vgf.Sendto(LOCATION_G_CIRCLE,g,tp,POS_FACEUP,REASON_EFFECT)
end