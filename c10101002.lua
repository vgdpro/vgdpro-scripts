--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,10101001,vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter),vgf.OverlayCost(1))
    vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,2000,cm.con)
end
function cm.filter(c)
	return c:IsCode(10101006)
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler()
end