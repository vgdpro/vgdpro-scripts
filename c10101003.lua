--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,10101002,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_CIRCLE,LOCATION_DECK,cm.filter))
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
end
function cm.filter(c)
	return c:IsCode(10101009)
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler()
end