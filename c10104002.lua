--树角兽 拉提斯
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位被「树角兽王 马格诺利亚」RIDE时，通过【费用】[灵魂爆发1]，将你的牌堆顶的1张卡公开，那张卡是单位卡的话，CALL到R上，不是的话，加入手牌。
	vgd.BeRidedByCard(c,m,10104001,cm.operation,vgf.OverlayCost(1))
	--【自】【后列的R】：这个单位攻击先导者时，通过【费用】[灵魂爆发1]，这次战斗中，这个单位的力量+10000。
	vgd.EffectTypeTrigger(c,m,cm,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,vgf.OverlayCost(1),cm.condition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=vgf.ReturnCard(g)
	Duel.DisableShuffleCheck()
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then
        vgf.Call(g,0,tp)
	elseif tc:IsAbleToHand() then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=vgf.AtkUp(c,c,10000,nil)
	vgf.EffectReset(c,e1,EVENT_BATTLED)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.IsSequence(c,1,2,3) and vgf.VMonsterFilter(Duel.GetAttackTarget())
end