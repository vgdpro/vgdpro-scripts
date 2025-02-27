--最不服输 托蕾因
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【永】【后列的R】：这个单位的获得『支援』的技能，力量-2000。
    -- 支援
    cm.is_has_continuous=true
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_ADD_SKILL)
    e2:SetRange(LOCATION_CIRCLE)
    e2:SetValue(SKILL_BOOST)
    e2:SetCondition(cm.con)
    c:RegisterEffect(e2)
    -- -2000
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, -2000, cm.con)
end
function cm.con(e)
    local c = e:GetHandler()
    return vgf.filter.Back(c)
end
