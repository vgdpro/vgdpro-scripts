local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.op,vgf.CounterBlast(2),cm.con1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_NIGHT) or Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DEEP_NIGHT)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_DEEP_NIGHT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,vgf.Stringid(m,0))
	local ct=Duel.AnnounceNumber(tp,1,2,3)
	for i=1,ct do
		local tc=Duel.CreateToken(tp,VgID)
		g:AddCard(tc)
	end
	vgf.Sendto(LOCATION_CIRCLE,g,0,tp)
end