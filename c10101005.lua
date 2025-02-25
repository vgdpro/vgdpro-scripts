--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityCont(c, m, LOCATION_MZONE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler()
end