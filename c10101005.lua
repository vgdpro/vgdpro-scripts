--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
    e1:SetValue(2000)
    c:RegisterEffect(e1)
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler()
end