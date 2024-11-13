local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeContinuousChangeDefense(c,m,EFFECT_TYPE_SINGLE,5000,cm.con)
end
function cm.con(e)
	local c = vgf.GetVMonster(1-e:GetHandlerPlayer())
	return c and c:IsLevelAbove(3)
end