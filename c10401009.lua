local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
    cm.is_has_continuous=true
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(AFFECT_CODE_ALCHEMAGIC)
    e1:SetRange(LOCATION_ORDER)
    e1:SetTargetRange(1,0)
	e1:SetCondition(vgf.VMonsterCondition)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
    e2:SetCode(AFFECT_CODE_ALCHEMAGIC_DIFFERENT_NAME)
    c:RegisterEffect(e2)
	vgd.AbilityAct(c,m,LOCATION_MZONE,vgf.CardsFromTo(REASON_EFFECT,LOCATION_MZONE,LOCATION_DROP),vgf.DamageCost(1),vgf.VMonsterCondition,nil,1)
end