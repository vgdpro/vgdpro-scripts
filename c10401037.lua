--在地上爬行吧，“下等生物”！
local cm,m,o=GetID()
function cm.initial_effect(c)
--通过【费用】[计数爆发1]施放！灵魂填充1。这之后，选择你的1个单位，你的灵魂里的卡每有5张，这个回合中，力量+10000。你的灵魂在10张以上的话，抽1张卡。
	vgd.Order(c,m,cm.operation,vgf.cost.CounterBlast(1))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	vgf.op.SoulCharge(1)(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
	local e1=vgf.GetMatchingGroupCount(nil,tp,LOCATION_SOUL,0,nil)/5
	local e2=e1*10000
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_CIRCLE,0,1,1,nil)
	vgf.AtkUp(c,g,e2,nil)
	if vgf.GetMatchingGroupCount(nil,tp,LOCATION_SOUL,0,nil)>=10 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end