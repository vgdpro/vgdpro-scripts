local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	VgD.SpellActivate(c,m,op,con,cm.cost)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc,mg)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,mg,TYPE_MONSTER)
	if chkc then return g end
	if chk==0 then return g:GetCount()>0 end
	g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
