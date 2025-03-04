local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAct(c,m,LOCATION_V_CIRCLE,cm.thop,cm.thcost,nil,nil,1)
	vgd.action.AbilityAuto(c,m,LOCATION_V_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,cm.cost,cm.condition)
end
function cm.thfilter(c)
	return c:IsCode(m)
end
-- 计数爆发1
cm.thcost=vgf.cost.CounterBlast(1)
-- 从你的牌堆里探寻至多1张与这个单位同名的卡，公开后加入手牌
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_ATOHAND,e,tp,cm.thfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_HAND,g,nil,REASON_EFFECT)
	end
	-- 这个回合中，这个单位的力量+10000
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		vgf.AtkUp(c,c,10000)
	end
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsCanBeCalled(e,tp)end
-- 攻击先导者时
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc and tc:IsVanguard()
end
-- 能量爆发4
cm.cost=vgf.cost.EnergyBlast(4)
-- 选择你的灵魂里的1张等级3以下的卡，CALL到R上
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=vgf.GetSoulGroup(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
	local sg=mg:FilterSelect(tp,cm.filter,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		if vgf.Sendto(LOCATION_CIRCLE,tc,0,tp)>0 then
			-- 这个回合中，那个单位的力量+10000
			vgf.AtkUp(e:GetHandler(),tc,10000)
		end
	end
end