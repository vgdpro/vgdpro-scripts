local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被「琳琅盛宴龙」RIDE时
	vgd.action.AbilityAutoRided(c,m,20105002,cm.operation)
	-- 力量+5000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_ATTACK,5000,cm.powercon)
end
-- 抽2张卡
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
	-- 选择你的手牌中的2张卡，舍弃
	local g=vgf.SelectMatchingCard(HINTMSG_DISCARD,e,tp,nil,tp,LOCATION_HAND,0,2,2,nil)
	vgf.Sendto(LOCATION_DROP,g,REASON_EFFECT)
end
-- 你的回合中，你有等级3以上的含有「凯旋龙」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return Duel.GetTurnPlayer()==tp and v and v:IsLevelAbove(3) and v:IsSetCard(0x12f)
end