local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【起】【V】【1回合1次】：通过【费用】[计数爆发1]，选择你的指令区中的1张正面表示的歌曲卡，将其歌唱。（发动歌曲卡的能力，那个能力结算完毕后将那张卡转为背面表示。）
	vgd.AbilityAct(c,m,LOCATION_MZONE,cm.op,vgf.DamageCost(1),vgf.VMonsterCondition,nil,1)
	-- 补充一回合一次描述
	-- 【自】【V】：这个单位攻击时，你的指令区中的背面表示的卡有2张以上的话，选择你的指令区中的1张卡正面表示的歌曲卡，将其歌唱，这次战斗中，对手不能将守护者从手牌CALL到G上。
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.op2,nil,cm.con2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_FACEUP,e,tp,cm.filter,tp,LOCATION_ORDER,0,1,1,nil)
	Duel.RaiseEvent(g,EVENT_CUSTOM+EVENT_SING,e,0,tp,tp,0)
end
function cm.filter(c)
	return c:IsSetCard(0xa040) and c:IsPosition(POS_FACEUP)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterFilter(c) and vgf.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_ORDER,0,2,nil,POS_FACEDOWN)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_FACEUP,e,tp,cm.filter,tp,LOCATION_ORDER,0,1,1,nil)
	Duel.RaiseEvent(g,EVENT_CUSTOM+EVENT_SING,e,0,tp,tp,0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(cm.actlimit)
    Duel.RegisterEffect(e1,tp)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(AFFECT_CODE_DEFENDER_CANNOT_TO_GCIRCLE)
	e2:SetTargetRange(0,1)
	Duel.RegisterEffect(e2,tp)
	vgf.EffectReset(c,{e1,e2},EVENT_BATTLED)
end
function cm.actlimit(e,te,tp)
	local tc=te:GetHandler()
    return te:IsHasCategory(CATEGORY_DEFENDER) and tc:IsType(TYPE_MONSTER) and tc:GetBaseDefense()==0 and tc:IsLocation(LOCATION_HAND)
end