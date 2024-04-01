VgF={}

function GetID()
	local offset=self_code<100000000 and 1 or 100
	return self_table,self_code,offset
end
function VgF.Stringid(code,id)
	return code*16+id
end
function VgF.SequenceToGlobal(p,loc,seq)
	if p~=0 and p~=1 then
		return 0
	end
	if loc==LOCATION_MZONE then
		if seq<=6 then
			return 0x0001<<(16*p+seq)
		else
			return 0
		end
	elseif loc == LOCATION_SZONE then
		if seq<=4 then
			return 0x0100<<(16*p+seq)
		else
			return 0
		end
	else
		return 0
	end
end
function VgF.True()
    return true
end
function VgF.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
function VgF.GetValueType(v)
	local t=type(v)
	if t=="userdata" then
		local mt=getmetatable(v)
		if mt==Group then return "Group"
		elseif mt==Effect then return "Effect"
		else return "Card" end
	else return t end
end
function VgF.ReturnCard(g)
    local tc
    if VgF.GetValueType(g)=="Group" then
        tc=g:GetFirst()
    elseif VgF.GetValueType(g)=="Card" then
        tc=g
    end
    return tc
end
bit={}
function bit.band(a,b)
	return a&b
end
function bit.bor(a,b)
	return a|b
end
function bit.bxor(a,b)
	return a~b
end
function bit.lshift(a,b)
	return a<<b
end
function bit.rshift(a,b)
	return a>>b
end
function bit.bnot(a)
	return ~a
end
function VgF.VMonsterFilter(c)
    return VgF.IsSequence(c,5)
end
function VgF.RMonsterFilter(c)
    return c:GetSequence()<5
end
function VgF.RMonsterCondition(e,c)
    return VgF.RMonsterFilter(e:GetHandler())
end
function VgF.VMonsterCondition(e,c)
    return VgF.VMonsterFilter(e:GetHandler())
end
function VgF.IsSequence(c,...)
    for i,v in ipairs{...} do
        if c:GetSequence()==v then
            return true
        end
    end
    return false
end
function VgF.RuleCardCondtion(e)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ALL,0,nil)
    return e:GetHandler()==g:GetFirst()
end
function VgF.RuleTurnCondtion(e)
    local tp=e:GetHandlerPlayer()
    local a=Duel.GetTurnCount(tp)
    local b=Duel.GetTurnCount(1-tp)
    return a+b==1
end
function VgF.Not(c,f)
    return not f(c)
end
function VgF.GetColumnGroup(c)
    local tp=c:GetControler()
    local g=Group.CreateGroup()
     if c:GetSequence()==0 then
        local sg1=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,1)
        local sg2=Duel.GetMatchingGroup(VgF.IsSequence,tp,0,LOCATION_MZONE,nil,3,4)
        if sg1 then g:Merge(sg1) end
        if sg2 then g:Merge(sg2) end
    end
    if c:GetSequence()==1 then
        local sg1=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,0)
        local sg2=Duel.GetMatchingGroup(VgF.IsSequence,tp,0,LOCATION_MZONE,nil,3,4)
        if sg1 then g:Merge(sg1) end
        if sg2 then g:Merge(sg2) end
    end
    if c:GetSequence()==2 then
        local sg1=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,5)
        local sg2=Duel.GetMatchingGroup(VgF.IsSequence,tp,0,LOCATION_MZONE,nil,2,5)
        if sg1 then g:Merge(sg1) end
        if sg2 then g:Merge(sg2) end
    end
    if c:GetSequence()==3 then
        local sg1=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,4)
        local sg2=Duel.GetMatchingGroup(VgF.IsSequence,tp,0,LOCATION_MZONE,nil,0,1)
        if sg1 then g:Merge(sg1) end
        if sg2 then g:Merge(sg2) end
    end
    if c:GetSequence()==4 then
        local sg1=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,3)
        local sg2=Duel.GetMatchingGroup(VgF.IsSequence,tp,0,LOCATION_MZONE,nil,0,1)
        if sg1 then g:Merge(sg1) end
        if sg2 then g:Merge(sg2) end
    end
    if c:GetSequence()==5 then
        local sg1=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,2)
        local sg2=Duel.GetMatchingGroup(VgF.IsSequence,tp,0,LOCATION_MZONE,nil,2,5)
        if sg1 then g:Merge(sg1) end
        if sg2 then g:Merge(sg2) end
    end
    return g
end
function VgF.Call(g,sumtype,sp,zone)
    if not zone then zone=0x7f end
	return Duel.SpecialSummon(g,sumtype,sp,sp,true,true,POS_FACEUP_ATTACK,zone)
end
function VgF.LvCondition(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    local lv=c:GetLevel()
    return Duel.IsExistingMatchingCard(VgF.LvConditionFilter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function VgF.LvConditionFilter(c,lv)
    return VgF.VMonsterFilter(c) and c:IsLevelAbove(lv)
end
function VgF.AtkUp(c,g,val,reset)
    if not c or not g then return end
    if not reset then reset=RESET_PHASE+PHASE_END end
    local tc=VgF.ReturnCard(g)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(val)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
    tc:RegisterEffect(e1)
end
function VgF.StarUp(c,g,val,reset)
    if not c or not g then return end
    if not reset then reset=RESET_PHASE+PHASE_END end
    local tc=VgF.ReturnCard(g)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_LSCALE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(val)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_RSCALE)
    tc:RegisterEffect(e2)
end
function VgF.IsAbleToGZone(c)
    if c:IsLocation(LOCATION_MZONE) then
        return c:IsAttribute(SKILL_BLOCK)
    end
    return c:IsLocation(LOCATION_HAND)
end