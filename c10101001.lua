--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,vgf.op.CardsFromTo(REASON_EFFECT,LOCATION_CIRCLE,LOCATION_DROP,cm.filter),vgf.cost.Discard(1),vgf.VMonsterCondition,nil,1)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.cost.CounterBlast(1),vgf.VMonsterCondition)
end
function cm.filter(c)
	return c:IsLevel(0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then g:AddCard(c) end
	local sg=vgf.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_CIRCLE,0,nil,0x201)
	if sg:GetCount()>0 then g:Merge(sg) end
	vgf.AtkUp(c,g,10000)
end