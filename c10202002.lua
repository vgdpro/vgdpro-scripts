--魔石龙 珠艾尼尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	--【自】【V/R】：这个单位的攻击击中先导者时，灵魂填充1。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_HITTING,vgf.op.SoulCharge(1),nil,cm.condition)
	--【自】：这个单位被含有「道拉珠艾尔德」的单位RIDE时，灵魂填充1，你的灵魂里有3张以上的相互不同等级的卡的话，抽1张卡。
	vgd.BeRidedByCard(c,m,cm.filter,cm.operation)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.filter.IsV(Duel.GetAttackTarget())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.SoulCharge(1)(e,tp,eg,ep,ev,re,r,rp)
	if vgf.GetVMonster(tp):GetOverlayGroup():GetClassCount(Card.GetLevel)>=3 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.filter(c)
	return c:IsSetCard(0xe8)
end
