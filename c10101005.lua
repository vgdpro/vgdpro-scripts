--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
    vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,2000,cm.con)
end
function cm.con(e)
    return Duel.GetAttacker()==e:GetHandler()
end