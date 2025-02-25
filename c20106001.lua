--满场同心 玛莉蕾恩
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【起】【V】【1回合1次】：通过【费用】[计数爆发1]，从你的牌堆里探寻至多1张与这个单位同名的卡，公开后加入手牌，然后牌堆洗切，这个回合中，这个单位的力量+10000。
	vgd.AbilityAct(c,m,LOCATION_CIRCLE,cm.operation,vgf.CounterBlast(1),vgf.VMonsterCondition,nil,1)
	--自】【V】：这个单位攻击先导者时，通过【费用】[能量爆发4]，选择你的1张后防者，返回手牌，选择你的手牌中的至多1张等级3以下的单位卡，CALL到不存在单位的R上，这个回合中，那个单位的力量+10000。（能量爆发4是通过消费4个能量来支付！）
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
--返回找的卡密
function cm.filter(c)
	return c:IsCode(m)
end
--效果二检测被打的是v
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.VMonsterFilter(c) and vgf.VMonsterFilter(Duel.GetAttackTarget())
end
--效果二处理
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.CardsFromTo(REASON_EFFECT,LOCATION_CIRCLE,LOCATION_HAND,cm.filter2)(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOperatedGroup()
	vgf.AtkUp(c,g,10000)
end
function cm.filter2(c)
	return c:IsLevel(1,2,3)
end
