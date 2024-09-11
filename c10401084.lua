local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.SearchCard(LOCATION_HAND,LOCATION_DECK,Card.IsSetCard,1,0,0x5040),nil,vgf.VSummonCondition)
	vgd.EffectTypeContinuousChangeAttack(c,m,EFFECT_TYPE_SINGLE,2000,cm.con)
end
function cm.filter(c)
	return c:IsSetCard(0x5040)
end
function cm.con(e)
	local tp=e:GetHandler()
	local c=e:GetHandler()
	return (Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_NIGHT) or Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DEEP_NIGHT))
		and (Duel.GetAttacker()==e:GetHandler() or c:GetFlagEffect(FLAG_SUPPORT)>0)
		and vgf.RMonsterCondition(e)
end