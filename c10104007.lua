--根植花瓣 斯特玛利亚
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,cm.cost,vgf.RMonsterCondition,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        vgf.AtkUp(c,c,5000,nil)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetCode(EFFECT_ADD_ATTRIBUTE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetValue(SKILL_SUPPORT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)
    end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return vgf.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,nil) and vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayCount()>=1 end
    local g1=vgf.SelectMatchingCard(HINTMSG_DAMAGE,e,tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,1,nil)
    Duel.ChangePosition(g1,POS_FACEDOWN)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
    local g2=vgf.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():Select(tp,1,1,nil)
    vgf.Sendto(LOCATION_DROP,g2,REASON_COST)
end