local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被「拼命歌唱的觉悟 露依兹」RIDE时
	vgd.action.AbilityAutoRided(c,m,20101002,cm.operation)
	-- 力量+5000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_ATTACK,5000,cm.powercon)
end
function cm.filter(c)
	return c:IsLevelBelow(2) and c:IsType(TYPE_NORMAL) and vgf.IsCanBeCalled(c,e,tp)
end
function cm.thfilter(c,tc)
	return c:IsCode(tc:GetCode())
end
-- 选择你的手牌中的至多1张等级2以下的普通单位卡，CALL到R上
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter,tp,LOCATION_HAND,0,0,1,nil,e,tp)
	if g:GetCount()>0 and vgf.Sendto(LOCATION_CIRCLE,g,0,tp)>0 then
		-- CALL出场了的话，从你的牌堆里探寻至多1张与由于这个能力CALL出场的单位同名的卡，公开后加入手牌
		local tc=g:GetFirst()
		local sg=vgf.SelectMatchingCard(HINTMSG_ATOHAND,e,tp,cm.thfilter,tp,LOCATION_DECK,0,0,1,nil,tc)
		if sg:GetCount()>0 then
			vgf.Sendto(LOCATION_HAND,sg,nil,REASON_EFFECT)
		end
	end
end
-- 你的回合中，你有等级3以上的含有「玛莉蕾恩」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return Duel.GetTurnPlayer()==tp and v:IsLevelAbove(3) and v:IsSetCard(0x12a)
end