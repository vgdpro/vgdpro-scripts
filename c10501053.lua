-- 诚意真心的支持者 特莉尔比
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 【自】【R】：你的先导者的攻击击中时，这个回合中，这个单位的力量+5000。
	vgd.action.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_FIELD,EVENT_HITTING,cm.op,nil,cm.con)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		vgf.AtkUp(c,c,5000,nil)
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return vgf.con.IsR(e) and Duel.GetAttacker():IsVanguard()end