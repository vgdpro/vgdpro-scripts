--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,vgf.SearchCardSpecialSummon(LOCATION_DROP,cm.filter),vgf.DisCardCost(1),nil,nil,1)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.DamageCost(1))
end
function cm.filter(c)
	return vgf.IsLevel(c,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.FromCards(c)
	local sg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x3210)
	if sg then g:Merge(sg) end
	for tc in VgF.Next(g) do
		VgF.AtkUp(c,tc,10000,nil)
	end
end