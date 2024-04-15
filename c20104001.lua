--救翼天使 扎雷乌萨耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【起】【V】【1回合1次】：通过【费用】[计数爆发1]，从你的牌堆里探寻至多1张与这个单位同名的卡，公开后加入手牌，然后牌堆洗切，这个回合中，这个单位的力量+10000。
	vgd.EffectTypeIgnition(c,m,LOCATION_MZONE,cm.operation,vgf.DamageCost(1),vgf.VMonsterCondition,nil,1)
	--【自】【V】：这个单位攻击先导者时，通过【费用】[能量爆发4]，选择你的弃牌区中的1张等级3以下的普通单位卡，CALL到R上，这个回合中，那个单位的力量+10000。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,vgf.EnegyCost(4),vgf.VMonsterCondition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.SearchCard(LOCATION_DECK,cm.fliter)
	vgf.AtkUp(c,c,10000,nil)
end
function cm.fliter(c)
	return c:IsCode(20104001)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.SearchCardSpecialSummon(LOCATION_DROP,cm.fliter2)
	local g=Dual.GetOperatedGroup()
	vgf.AtkUp(c,g,10000)

end
function cm.fliter2(c)
	return vgf.IsLevel(c,3)
end
