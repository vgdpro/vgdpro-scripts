local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(AFFECT_OVERLAY_INSTEAD_WHEN_RIDE)
    e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
		return cm.con(e,tp,eg,ep,ev,re,r,rp) and vgf.VMonsterCondition(e)
	end)
    e1:SetTargetRange(1,0)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
		return not cm.con(e,tp,eg,ep,ev,re,r,rp) and vgf.VMonsterCondition(e)
	end)
    e2:SetValue(function (e,tc)
		return tc:IsLevelBelow(1) and vgf.RMonsterFilter(tc)
	end)
    c:RegisterEffect(e2)
	vgd.EffectTypeTrigger(c,m,nil,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.op,nil,cm.con1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    local a=vgf.IsExistingMatchingCard(cm.filter1,tp,LOCATION_LOCK,0,1,nil)
    local b=vgf.IsExistingMatchingCard(cm.filter2,tp,LOCATION_LOCK,0,1,nil)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）
    return not a and b
end
function cm.filter1(c)
    return c:GetLevel()%2==1
end
function cm.filter2(c)
    return c:GetLevel()%2==0
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	vgf.Sendto(LOCATION_LOCK,g,POS_FACEUP,REASON_EFFECT)
end