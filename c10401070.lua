--入魂的操兽师 梅甘
local cm,m,o=GetID()
function cm.initial_effect(c)
--【永】【R】：这个回合中你进行过灵魂填充的话，这个单位的力量+2000	
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
vgd.action.GlobalCheckEffect(c,m,EVENT_CUSTOM+EVENT_OVERLAY_FILL,cm.checkcon)
end
function cm.con(e)
	local tp=e:GetHandlerPlayer()
	return vgf.con.IsR(e) and Duel.GetFlagEffect(tp,m)>0
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and rp==tp
end