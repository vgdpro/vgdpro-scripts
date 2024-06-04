--轰雷龙 凯旋龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【起】【V】【1回合1次】：通过【费用】[计数爆发1]，从你的牌堆里探寻至多1张与这个单位同名的卡，公开后加入手牌，然后牌堆洗切，这个回合中，这个单位的力量+10000。
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,vgf.DamageCost(1),vgf.VMonsterCondition,nil,1)
	--【自】【V】：这个单位攻击先导者时，通过【费用】[能量爆发4]，选择对手的一张后方者，退场，这次战斗中，这个单位的力量+5000，⭐+1。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,vgf.EnergyCost(4),cm.condition)
end
--效果一处理
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.SearchCardOP(LOCATION_DECK,cm.fliter,e,tp,eg,ep,ev,re,r,rp)
	vgf.AtkUp(c,c,10000,nil)
end
--返回效果一寻找卡密
function cm.fliter(c)
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
	local g=VgF.SelectMatchingCard(HINTMSG_LEAVEONFIELD,e,tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
		if g then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
		end
	vgf.AtkUp(c,c,5000)
	VgF.StarUp(c,c,1)
end