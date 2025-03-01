local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 起1
	vgd.action.AbilityAct(c,m,LOCATION_V_CIRCLE,cm.thop,cm.thcost,nil,nil,1)
	-- 起2
	vgd.action.AbilityAct(c,m,LOCATION_V_CIRCLE,cm.operation,cm.cost,nil,nil,1)
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
	return c:IsLevelBelow(3) and vgf.IsCanBeCalled(c,e,tp)
end
-- 能量爆发4
cm.cost=vgf.cost.EnergyBlast(4)
-- 将你的牌堆顶的2张卡舍弃
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,2)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
	-- 选择你的弃牌区中的至多2张等级3以下的单位卡，CALL到R上
	local sg=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_DROP,0,0,2,nil,e,tp)
	if g:GetCount()>0 then
		vgf.Sendto(LOCATION_CIRCLE,g,0,tp)
	end
end