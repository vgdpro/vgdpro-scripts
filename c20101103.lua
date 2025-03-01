local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 被「轰雷兽 扬升黄喉貂」RIDE时
	vgd.action.AbilityAutoRided(c,m,20101002,vgf.op.Draw(),vgf.cost.EnergyBlast(2))
	-- 力量+5000
	vgd.action.AbilityCont(c,m,LOCATION_G_CIRCLE,EFFECT_TYPE_SINGLE,EFFECT_UPDATE_ATTACK,5000,cm.powercon)
end
-- 你的回合中，你有等级3以上的含有「凯旋龙」的先导者的话
function cm.powercon(e)
	local tp=e:GetHandlerPlayer()
	local v=vgf.GetVMonster(tp)
	return Duel.GetTurnPlayer()==tp and v and v:IsLevelAbove(3) and v:IsSetCard(0x12a)
end