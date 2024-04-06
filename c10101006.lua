--
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(vgf.Stringid(vgid,9))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,0)
    e1:SetCondition(cm.condition)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_CUSTOM+m,cm.operation3,vgf.OverlayCost(2))
end
function cm.condition(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return vgf.LvCondition(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c)
    return vgf.RMonsterFilter(c) and c:IsCode(10101009)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OVERLAY)
    local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	tc=vgf.ReturnCard(tc)
	local zone=vgf.SequenceToGlobal(tp,tc:GetLocation(),tc:GetSequence())
    e:SetValue(function () return 0,zone end)
	c:SetMaterial(Group.FromCards(tc))
	local mg=tc:GetOverlayGroup()
	if mg:GetCount()~=0 then
		Duel.Overlay(c,mg)
	end
	c:SetMaterial(Group.FromCards(tc))
	Duel.Overlay(c,Group.FromCards(tc))
    c:RegisterFlagEffect(ConditionFlag,RESET_EVENT+RESETS_STANDARD,0,1,201)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	VgF.AtkUp(c,c,10000,nil)
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,tp,tp,0)
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
	local g=Duel.SelectTarget(tp,vgf.RMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end