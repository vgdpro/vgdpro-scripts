-- 精明世故 特蕾吉娅
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】【R】：这个单位攻击时，这个回合中你施放了指令卡的话，通过【费用】[灵魂爆发1]，这个回合中，这个单位的力量+5000。
	vgd.GlobalCheckEffect(c,m,EVENT_CHAIN_SOLVING,cm.checkcon)
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op,vgf.cost.SoulBlast(1),cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000,nil)
	end
end

function cm.con(e)
    local tp=e:GetHandlerPlayer()
    return vgf.con.IsR(e) and Duel.GetFlagEffect(tp,m)>0
end

function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end