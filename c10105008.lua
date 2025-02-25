local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityContChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,2000,con)
	vgd.AbilityContChangeDefense(c,m,EFFECT_TYPE_SINGLE,5000,con)
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_ORDER,0,1,nil)
end
function cm.filter(c)
	return c:GetFlagEffect(FLAG_IMPRISON)>0
end