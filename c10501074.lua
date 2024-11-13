--最不服输 托蕾因
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 【永】【后列的R】：这个单位的获得『支援』的技能，力量-2000。
    -- 支援
    cm.is_has_continuous=true
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_SKILL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(SKILL_SUPPORT)
    e2:SetCondition(cm.con)
    c:RegisterEffect(e2)
    -- -2000
    vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,-2000,cm.con)
end
function cm.con(e)
    local c = e:GetHandler()
    return VgF.BackFilter(c)
end
