--根植花瓣 斯特玛利亚
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,cm.cost,vgf.RMonsterCondition,nil,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.AtkUp(c,c,5000,nil)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_ATTRIBUTE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(SKILL_SUPPORT)
    e2:SetCondition(cm.condition)
    c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp)
	
end
--未写效果的【费用】[计数爆发1，灵魂爆发1]