local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被「蒸汽修剪者 尼布甲尼撒」RIDE时
	vgd.action.AbilityAutoRided(c,m,20102002,cm.operation)
	-- 力量+5000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_ATTACK,5000,cm.powercon)
end
-- 灵魂填充2
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	vgf.operation.SoulCharge(2)(e,tp,eg,ep,ev,re,r,rp)
	-- 选择你的1张先导者，这个回合中，力量+5000
	local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_V_CIRCLE,0,1,1,nil)
	if g:GetCount()>0 then
		vgf.AtkUp(e:GetHandler(),g,5000)
	end
end
-- 你的回合中，你有等级3以上的含有「奥赛拉杰斯特」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return Duel.GetTurnPlayer()==tp and v and v:IsLevelAbove(3) and v:IsSetCard(0x12b)
end