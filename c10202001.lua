--拥宝之龙牙 道拉珠艾尔德
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【永】：这张卡将要被RIDE之际，这张卡也当做「魔宝龙 道拉珠艾尔德」使用。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetCondition(cm.condition1)
	e1:SetValue(10407005)
	e1:SetReset(nil)
	c:RegisterEffect(e1)
	--【自】【V】：这个单位攻击先导者时，通过【费用】[使用等级均不同的卡进行灵魂爆发4]，选择对手的1张先导者，这个回合中，力量增减至1，对手有等级3以上的先导者的话，这个单位的☆+1。（仅将那个时点的力量增减至1，这之后那个单位的力量仍然能通过其他方式增减。）
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,cm.cost2,cm.condition2)
	--【永】【R】：这个回合中由于你的卡片的能力的费用同时使用4张以上的卡进行了灵魂爆发的话，这个单位的力量+5000。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.rmcon)
	e2:SetValue(2000)
	c:RegisterEffect(e2)
end

function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return VgF.VMonsterFilter(e:GetHandler()) and Duel.GetCurrentPhase()==PHASE_STANDBY
end

function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup()
	return VgF.VMonsterFilter(e:GetHandler()) and vgf.VMonsterFilter(Duel.GetAttackTarget()) and g:GetClassCount(Card.GetLevel)>=4
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0
	local g = Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup()
	local sg=g:SelectSubGroup(tp,cm.ATKcheck,false,4,4)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function cm.ATKcheck(g)
	return g:FilterCount(Card.IsLevel,nil,0)<=1
		and g:FilterCount(Card.IsLevel,nil,1)<=1
		and g:FilterCount(Card.IsLevel,nil,2)<=1
		and g:FilterCount(Card.IsLevel,nil,3)<=1
		and g:FilterCount(Card.IsLevel,nil,4)<=1
end

function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(nil)
	e1:SetValue(1)
	t:RegisterEffect(e1)
	if t.IsLevelAbove(3)
	then
		VgF.StarUp(c,c,1,nil)
	end
end
function cm.rmcon(e)
--需要灵魂爆发4的标识
	return Duel.GetFlagEffect(0,id)>0
end
