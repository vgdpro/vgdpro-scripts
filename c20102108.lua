local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.action.AbilityAuto(c,m,LOCATION_R_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,cm.cost,cm.condition)
end
-- 你有等级3以上的含有「奥赛拉杰斯特」的先导者的话
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=vgf.GetVMonster(tp)
	return tc and tc:IsLevelAbove(3) and tc:IsSetCard(0x12b)
end
-- 计数爆发1
cm.cost=vgf.cost.And(vgf.cost.CounterBlast(1),function(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 将你前列的其他的1张后防者放置到灵魂里
	local c=e:GetHandler()
	local mg=vgf.GetMatchingGroup(Card.IsFrontrow,tp,LOCATION_R_CIRCLE,0,c)
	if chk==0 then return mg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=mg:Select(tp,1,1,nil)
	vgf.Sendto(LOCATION_SOUL,sg)
end)
-- 抽1张卡
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end