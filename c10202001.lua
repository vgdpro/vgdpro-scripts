--拥宝之龙牙 道拉珠艾尔德
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【永】：这张卡将要被RIDE之际，这张卡也当做「魔宝龙 道拉珠艾尔德」使用。
	
	--【自】【V】：这个单位攻击先导者时，通过【费用】[使用等级均不同的卡进行灵魂爆发4]，选择对手的1张先导者，这个回合中，力量增减至1，对手有等级3以上的先导者的话，这个单位的☆+1。（仅将那个时点的力量增减至1，这之后那个单位的力量仍然能通过其他方式增减。）
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,cm.cost,cm.condition)
	--【永】【R】：这个回合中由于你的卡片的能力的费用同时使用4张以上的卡进行了灵魂爆发的话，这个单位的力量+5000。

end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return VgF.VMonsterFilter(e:GetHandler()) and vgf.VMonsterFilter(Duel.GetAttackTarget())
end
function cm.check(sg)
	return sg:FilterCount(Card.IsLevel,nil,1)<=1
		and sg:FilterCount(Card.IsLevel,nil,2)<=1
		and sg:FilterCount(Card.IsLevel,nil,3)<=1
		and sg:FilterCount(Card.IsLevel,nil,4)<=1
		and sg:FilterCount(Card.IsLevel,nil,5)<=1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0
	then
		return g:GetClassCount(Card.GetLevel)>=4
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:SelectSubGroup(tp,vgf.True,true,4,4)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(nil)
	e1:SetValue(1)
	Duel.GetAttackTarget():RegisterEffect(e1)
	if Duel.GetAttackTarget():IsLevelAbove(4)
	then
		VgF.StarUp(c,c,1,nil)
	end
end
