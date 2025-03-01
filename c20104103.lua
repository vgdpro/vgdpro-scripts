local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被「静默的骑士 史威斯赫尔姆」RIDE时
	vgd.action.AbilityAutoRided(c,m,20104002,cm.operation)
	-- 力量+5000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_ATTACK,5000,cm.powercon)
end
-- 将你的牌堆顶的1张卡公开
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=vgf.ReturnCard(g)
	Duel.DisableShuffleCheck()
	if tc:IsLevelBelow(2) and tc:IsType(TYPE_NORMAL) and vgf.IsCanBeCalled(tc,e,tp)
		and Duel.SelectYesNo(tp,vgf.Stringid(m,0)) then
		-- 将那张卡CALL到R上
		vgf.Sendto(LOCATION_CIRCLE,c,0,tp)
	else
		-- 将那张卡加入手牌，选择你的手牌中的1张卡，舍弃
		local tg=vgf.SelectMatchingCard(HINTMSG_DISCARD,e,tp,nil,tp,LOCATION_HAND,0,1,1,nil)
		vgf.Sendto(LOCATION_DROP,tg,REASON_EFFECT)
	end
end
-- 你的回合中，你有等级3以上的含有「扎雷乌萨耶尔」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return Duel.GetTurnPlayer()==tp and v:IsLevelAbove(3) and v:IsSetCard(0x12d)
end