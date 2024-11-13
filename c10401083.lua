local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,2000,cm.con)
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil) and Duel.GetAttacker()==e:GetHandler() and vgf.RMonsterCondition(e)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end