local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.SpellActivate(c,m,vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter),vgf.DamageCost(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.GetVMonster(tp):IsSetCard(0x202)
end
function cm.filter(c)
	return c:IsCode(10203005)
end