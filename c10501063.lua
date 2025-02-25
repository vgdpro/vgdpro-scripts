-- 积极生活 杰莉
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】【R】：你的含有「诚意真心」的单位被攻击时，通过【费用】[将这个单位退场]，选择1张正在被攻击的单位，这次战斗中，力量+10000。
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_BE_BATTLE_TARGET,cm.op,vgf.LeaveFieldCost,cm.con)
	-- EFFECT_TYPE_FIELD
	-- EVENT_BE_BATTLE_TARGET
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.FromCards(Duel.GetAttackTarget())
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
        g=g:FilterSelect(tp,Card.IsCanBeEffectTarget,1,1,nil,e)
		local e1=vgf.AtkUp(c,g,10000)
		vgf.EffectReset(c,e1,EVENT_BATTLED)
	end
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.FromCards(Duel.GetAttackTarget())
	return vgf.RMonsterCondition(c) and g:IsExists(Card.IsSetCard,1,nil,0xb6)
end