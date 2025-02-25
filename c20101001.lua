--轰雷龙 凯旋龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【起】【V】【1回合1次】：通过【费用】[计数爆发1]，从你的牌堆里探寻至多1张与这个单位同名的卡，公开后加入手牌，然后牌堆洗切，这个回合中，这个单位的力量+10000。
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.operation,vgf.CounterBlast(1),vgf.VMonsterCondition,nil,1)
	--【自】【V】：这个单位攻击先导者时，通过【费用】[能量爆发4]，选择对手的一张后方者，退场，这次战斗中，这个单位的力量+5000，⭐+1。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,vgf.EnergyBlast(4),cm.condition)
end
--效果一处理
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.CardsFromTo(REASON_EFFECT,LOCATION_HAND,LOCATION_DECK,cm.filter)(e,tp,eg,ep,ev,re,r,rp)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,10000,nil)
	end
end
--返回效果一寻找卡密
function cm.filter(c)
	return c:IsCode(m)
end
--检测打的是不是v
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.VMonsterFilter(c) and vgf.VMonsterFilter(Duel.GetAttackTarget())
end
--效果二处理
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_LEAVEFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_CIRCLE,1,1,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000)
		vgf.StarUp(c,c,1)
	end
end