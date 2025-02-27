local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.AbilityAuto(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,Card.IsSetCard,1,0,0x5040),nil,vgf.con.RideOnVCircle)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
end
function cm.filter(c)
	return c:IsSetCard(0x5040)
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return (Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DARK_NIGHT) or Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_ABYSSAL_DARK_NIGHT))
		and (Duel.GetAttacker()==e:GetHandler() or c:GetFlagEffect(FLAG_SUPPORT)>0)
		and vgf.con.IsR(e)
end