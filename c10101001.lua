--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,vgf.SearchCard(LOCATION_HAND,LOCATION_MZONE,LOCATION_DROP,cm.filter),vgf.DisCardCost(1),nil,nil,1)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.DamageCost(1))
end
function cm.filter(c)
	return c:IsLevel(0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	if c:IsRelateToEffect(e) then g:AddCard(c) end
	local sg=vgf.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x201)
	if sg:GetCount()>0 then g:Merge(sg) end
	vgf.AtkUp(c,g,10000)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.GetMatchingGroup(nil,tp,LOCATION_DAMAGE,0,nil)
	for tc in vgf.Next(g) do
		Duel.ChangePosition(tc,POS_FACEDOWN)
	end
end