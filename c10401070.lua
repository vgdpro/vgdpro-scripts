--入魂的操兽师 梅甘
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--【永】【R】：这个回合中你进行过灵魂填充的话，这个单位的力量+2000	
vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,2000,cm.con)
vgd.GlobalCheckEffect(c,m,EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS,EVENT_CHAIN_SOLVED,cm.checkcon,cm.checkop)
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return vgf.RMonsterCondition(e) and Duel.OverlayFill()>0
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	
end