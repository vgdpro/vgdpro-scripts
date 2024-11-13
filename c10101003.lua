--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.BeRidedByCard(c,m,10101002,vgf.SearchCard(LOCATION_MZONE,LOCATION_DECK,cm.filter))
    vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,2000,cm.con)
end
function cm.filter(c)
	return c:IsCode(10101009)
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler()
end