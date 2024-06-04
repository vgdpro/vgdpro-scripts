local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.ContinuousSpell(c)
	vgd.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_SINGLE,EVENT_MOVE,vgf.OverlayFill(3),cost,cm.con)
	vgd.EffectTypeTrigger(c,m,LOCATION_ORDER,EFFECT_TYPE_FIELD,EVENT_SPSUMMON_SUCCESS,cm.op1,cm.cost1,cm.con1,tg,count,EFFECT_FLAG_BOTH_SIDE)
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetOperation(function (e,tp)
		local g=vgf.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		Duel.Sendto(g,tp,LOCATION_DECK,POS_FACEUP_ATTACK,REASON_RULE,1)
	end)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_ORDER)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayGroup():FilterCount(Card.IsAbleToGraveAsCost,nil)>=1
	local b=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,1,nil)
	if chk==0 then return a or b end
	local off=1
    local ops={}
    if a then
        ops[off]=VgF.Stringid(VgID,11)
        off=off+1
    end
    if b then
        ops[off]=VgF.Stringid(VgID,12)
        off=off+1
    end
	local sel=Duel.SelectOption(tp,table.unpack(ops))
	if sel==0 and a then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
        local g=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,num,num,nil)
        Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(1)
	else
        local g=vgf.SelectMatchingCard(HINTMSG_DAMAGE,e,tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,num,num,nil)
        Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
		e:SetLabel(2)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,e) and eg:GetCount()==1
end
function cm.filter(c,e)
	return c:IsSummonType(SUMMON_VALUE_CALL) and c:GetControler()~=e:GetHandler():GetControler()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local zone=vgf.GetAvailableLocation(tp)
	local ct=bit.ReturnCount(zone)
	if ct>e:GetLabel() then ct=e:GetLabel() end
	local g=vgf.SelectMatchingCard(HINTMSG_CALL,e,tp,cm.filter1,tp,0,LOCATION_ORDER,ct,ct,nil,e,tp)
	Duel.HintSelection(g)
	for tc in vgf.Next(g) do
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then
			vgf.Call(tc,0,tp)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function cm.filter1(c,e,tp)
	return c:GetFlagEffect(ImprisonFlag)>0
end