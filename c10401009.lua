local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(AFFECT_CODE_MIX)
    e1:SetRange(LOCATION_ORDER)
    e1:SetTargetRange(1,0)
	e1:SetCondition(vgf.VMonsterCondition)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
    e2:SetCode(AFFECT_CODE_MIX_DIFFERENT_NAME)
    c:RegisterEffect(e2)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,vgf.SearchCard(LOCATION_MZONE,LOCATION_DROP),vgf.DamageCost(1),vgf.VMonsterCondition,nil,1)
end