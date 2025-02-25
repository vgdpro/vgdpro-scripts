--拥宝之龙牙 道拉珠艾尔德
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【永】：这张卡将要被RIDE之际，这张卡也当做「魔宝龙 道拉珠艾尔德」使用。
	vgf.AddRideMaterialCode(c,m,10407005)
	vgf.AddRideMaterialSetCard(c,m,0xc00d,0x75,0xe8)
	--【自】【V】：这个单位攻击先导者时，通过【费用】[使用等级均不同的卡进行灵魂爆发4]，选择对手的1张先导者，这个回合中，力量增减至1，对手有等级3以上的先导者的话，这个单位的☆+1。（仅将那个时点的力量增减至1，这之后那个单位的力量仍然能通过其他方式增减。）
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,cm.cost,cm.condition)
	--【永】【R】：这个回合中由于你的卡片的能力的费用同时使用4张以上的卡进行了灵魂爆发的话，这个单位的力量+5000。
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 5000, cm.con)
    if not cm.global_check then
        cm.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_MOVE)
        ge1:SetCondition(cm.checkcon)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function cm.checkfilter(c,re)
	return c:IsReason(REASON_COST) and re:IsActivated() and c:IsPreviousLocation(LOCATION_SOUL)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.checkfilter,1,nil,re) and eg:GetClassCount(Card.GetLevel)>=4
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.con(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterFilter(e:GetHandler()) and vgf.VMonsterFilter(Duel.GetAttackTarget())
end
function cm.check(g)
	return g:GetClassCount(Card.GetLevel)==#g
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0
	then
		return g:GetClassCount(Card.GetLevel)>=4
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:SelectSubGroup(tp,cm.check,true,4,4)
	vgf.Sendto(LOCATION_DROP,sg,REASON_EFFECT)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=vgf.SelectMatchingCard(HINTMSG_VMONSTER,e,tp,vgf.VMonsterFilter,tp,0,LOCATION_CIRCLE,1,1,nil):GetFirst()
	if tc:GetAttack()>1 then
		local atk=tc:GetAttack()-1
		vgf.AtkUp(c,tc,-atk)
	end
	if vgf.IsExistingMatchingCard(tp,cm.filter,tp,0,LOCATION_CIRCLE,1,1,nil) then
		vgf.StarUp(c,c,1)
	end
end
function cm.filter(c)
	return vgf.VMonsterFilter(c) and c:IsLevelAbove(3)
end