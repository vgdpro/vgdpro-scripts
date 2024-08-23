VgF={}
vgf=VgF

---@class Card
---@class Group
---@class Effect

---初始化c，使c具有vg卡的功能。
---@param c Card 要初始化的卡
function VgF.VgCard(c)
    VgD.Rule(c)
    VgF.DefineArguments()
    VgD.RideUp(c)
    if c:IsType(TYPE_MONSTER) then
        VgD.CallToR(c)
        VgD.MonsterBattle(c)
    end
    if not c:IsRace(TRIGGER_SUPER) then
	    VgD.CardTrigger(c,nil)
    end
end
---获取脚本基本信息
function GetID()
	local offset=self_code<100000000 and 1 or 100
	return self_table,self_code,offset
end
---根据卡号和索引获取描述编号
---@param code integer 卡片密码
---@param id integer 索引
---@return integer 描述的编号
function VgF.Stringid(code,id)
	return code*16+id
end
function VgF.DefineArguments()
    if not code then code=nil end
    if not loc then loc=nil end
    if not typ then typ=nil end
    if not typ2 then typ2=nil end
    if not count then count=nil end
    if not property then property=nil end
    if not reset then reset=nil end
    if not op then op=nil end
    if not cost then cost=nil end
    if not con then con=nil end
    if not tg then tg=nil end
    if not f then f=nil end
    if not zone then zone=nil end
end
---根据控制者，区域和编号获取zone；不合法的数据会返回0
---@param p integer 控制者
---@param loc integer 所在区域，若不是LOCATION_MZONE或LOCATION_SZONE则返回0
---@param seq integer 编号
---@return integer 卡片所在的zone
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
---一个总是返回true的函数。
---@return true
function VgF.True()
    return true
end
---返回g中的“下一张卡”。第一次调用会返回第一张卡。没有下一张卡会返回nil。
---@param g Group 要遍历的卡片组
---@return function 指示返回的卡的函数
function VgF.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
---返回v在lua中的变量类型，以string方式呈现。
---@param v any 要获取类型的变量（或常量）
---@return string 以字符串形式呈现的类型
function VgF.GetValueType(v)
	local t=type(v)
	if t=="userdata" then
		local mt=getmetatable(v)
		if mt==Group then return "Group"
		elseif mt==Effect then return "Effect"
		else return "Card" end
	else return t end
end
---如果g是Group的话，返回其第一张卡；如果g是Card的话，返回其本身；否则返回nil。
---@param g any 要操作的变量
---@return Card
function VgF.ReturnCard(g)
    local tc
    if VgF.GetValueType(g)=="Group" then
        tc=g:GetFirst()
    elseif VgF.GetValueType(g)=="Card" then
        tc=g
    end
    return tc
end
---返回g的前val张卡。
---@param g Group 要操作的卡片组
---@param val integer 要获取的卡片数量
function VgF.GetCardsFromGroup(g,val)
    if VgF.GetValueType(g)=="Group" then
        local sg=Group.CreateGroup()
        for tc in VgF.Next(g) do
            if sg:GetCount()>=val then break end
            sg:AddCard(tc)
        end
        return sg
    end
end
bit={}
function bit.ReturnCount(n)
    if n==0 then
        return 0
    end
    return 1+bit.ReturnCount(n&(n-1))
end

---返回对a和b进行按位与运算的结果。
---@param a integer 操作数1
---@param b integer 操作数2
---@return integer 运算结果
function bit.band(a,b)
	return a&b
end
---返回对a和b进行按位或运算的结果。
---@param a integer 操作数1
---@param b integer 操作数2
---@return integer 运算结果
function bit.bor(a,b)
	return a|b
end
---返回对a和b进行按位异或运算的结果。
---@param a integer 操作数1
---@param b integer 操作数2
---@return integer 运算结果
function bit.bxor(a,b)
	return a~b
end
---返回a按位左移b位后的结果。
---@param a integer 操作数1
---@param b integer 操作数2
---@return integer 运算结果
function bit.lshift(a,b)
	return a<<b
end
---返回a按位右移b位后的结果。
---@param a integer 操作数1
---@param b integer 操作数2
---@return integer 运算结果
function bit.rshift(a,b)
	return a>>b
end
---返回a按位非后的结果。
---@param a integer 操作数
---@return integer 运算结果
function bit.bnot(a)
	return ~a
end
---返回c是不是先导者。
---@param c Card 要判断的卡
---@return boolean 指示是否是先导者
function VgF.VMonsterFilter(c)
    return VgF.IsSequence(c,5)
end
---返回c是不是后防者。
---@param c Card 要判断的卡
---@return boolean 指示是否是后防者
function VgF.RMonsterFilter(c)
    return c:GetSequence()<5
end
---用于效果的Condition，判断e是否以后防者发动。
---@param e Effect
---@return boolean
function VgF.RMonsterCondition(e)
    return VgF.RMonsterFilter(e:GetHandler())
end
---用于效果的Condition，判断e是否以先导者发动。
---@param e Effect
---@return boolean
function VgF.VMonsterCondition(e)
    return VgF.VMonsterFilter(e:GetHandler())
end
---判断c是否在当前区域的某（几）个编号上
---@param c Card 要判断的卡
---@param ... integer 编号
---@return boolean 指示是否在给定编号上
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
---返回函数，该函数与f的结果总是相反的。
---@param f 要操作的函数
---@return function 经过操作的函数
function VgF.Not(f)
	return	function(...)
				return not f(...)
			end
end
---返回c所在列的所有单位。
---@param c Card 指示某一列的卡
---@return Group 这一列的所有单位
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
---用于【永】效果的Value属性。判断是否是对方发动的效果。<br>
---仅有特定的Code对此函数有效，其他Code的结果未知。
---@param e Effect 要注册的效果
---@param re Effect 引发该效果的效果
---@param rp integer 发动引发该效果的效果的玩家
---@return boolean 指示是否是对方发动的效果
function VgF.tgoval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
function VgF.GetAvailableLocation(tp,zone)
    local z
    if zone then z=zone else z=0x1f end
    local rg=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEDOWN_ATTACK)
    for tc in VgF.Next(rg) do
        local szone=VgF.SequenceToGlobal(tp,tc:GetLocation(),tc:GetSequence())
        z=bit.bxor(z,szone)
    end
    return z
end
---将g（中的每一张卡）Call到单位区。返回Call成功的数量。
---@param g Card|Group 要Call的卡（片组）
---@param sumtype integer Call的方式，默认填0
---@param tp integer Call的玩家
---@param zone integer|nil 指示要Call到的格子。<br>前列的R：17； 后列的R：14； 全部的R：31； V：32
---@param pos integer|nil 表示形式
---@return integer Call成功的数量
function VgF.Call(g,sumtype,tp,zone,pos,chk)
    if (VgF.GetValueType(g)~="Card" and VgF.GetValueType(g)~="Group") or (VgF.GetValueType(g)=="Group" and g:GetCount()==0) then return 0 end
    if VgF.GetValueType(pos)~="number" then pos=POS_FACEUP_ATTACK end
    if chk==0 then
        return Duel.SpecialSummon(g,sumtype,tp,tp,false,false,pos)
    end
    if zone and zone>0 then
        local sc=VgF.ReturnCard(g)
        local z=VgF.GetAvailableLocation(tp,zone)
        local ct=bit.ReturnCount(z)
        local szone
        if ct>1 then
            z=bit.bnot(z)
            z=bit.bor(z,0xffffff00)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CallZONE)
            szone=Duel.SelectField(tp,1,LOCATION_MZONE,0,z)
        else
            szone=z
        end
        if szone==0x20 and Duel.GetMatchingGroupCount(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil)>0 then
            if VgF.VMonsterFilter(sc:GetOverlayTarget()) then
                VgF.Sendto(0,sc,tp,POS_FACEUP,REASON_EFFECT)
                local _,code=c:GetOriginalCode()
                sc=Duel.CreateToken(tp,code)
            end
            local tc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
            local mg=tc:GetOverlayGroup()
            if mg:GetCount()~=0 then
                VgF.Sendto(LOCATION_OVERLAY,mg,sc)
            end
            sc:SetMaterial(Group.FromCards(tc))
            VgF.Sendto(LOCATION_OVERLAY,Group.FromCards(tc),sc)
        elseif VgF.IsExistingMatchingCard(VgD.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,szone) then
            local tc=Duel.GetMatchingGroup(VgD.CallFilter,tp,LOCATION_MZONE,0,nil,tp,szone):GetFirst()
            VgF.Sendto(LOCATION_DROP,tc,REASON_COST)
        end
	    return Duel.SpecialSummon(sc,sumtype,tp,tp,false,false,pos,szone)
    else
        local sg
        local z=bit.bnot(VgF.GetAvailableLocation(tp))
        z=bit.bor(z,0xffffff00)
        if VgF.GetValueType(g)=="Card" then sg=Group.FromCards(g) else sg=Group.Clone(g) end
        for sc in VgF.Next(sg) do
            if sc:IsLocation(LOCATION_EXTRA) then
                local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
                local mg=rc:GetOverlayGroup()
                if mg:GetCount()~=0 then
                    VgF.Sendto(LOCATION_OVERLAY,mg,sc)
                end
                sc:SetMaterial(Group.FromCards(rc))
                VgF.Sendto(LOCATION_OVERLAY,Group.FromCards(rc),sc)
                Duel.SpecialSummonStep(sc,sumtype,tp,tp,false,false,pos,0x20)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CallZONE)
                local szone=Duel.SelectField(tp,1,LOCATION_MZONE,0,z)
                if VgF.IsExistingMatchingCard(VgD.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,szone) then
                    local tc=Duel.GetMatchingGroup(VgD.CallFilter,tp,LOCATION_MZONE,0,nil,tp,szone):GetFirst()
                    VgF.Sendto(LOCATION_DROP,tc,REASON_COST)
                end
                Duel.SpecialSummonStep(sc,sumtype,tp,tp,false,false,pos,szone)
                z=bit.bor(z,szone)
            end
        end
        return Duel.SpecialSummonComplete()
    end
end
function VgF.LvCondition(e_or_c)
    local c=VgF.GetValueType(e_or_c)=="Effect" and e_or_c:GetHandler() or e_or_c
    local tp,lv=c:GetControler(),c:GetLevel()
    return VgF.IsExistingMatchingCard(VgF.LvConditionFilter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function VgF.LvConditionFilter(c,lv)
    return VgF.VMonsterFilter(c) and c:IsLevelAbove(lv)
end
---以c的名义，使g（中的每一张卡）的攻击力上升val，并在reset时重置。
---@param c Card 要使卡上升攻击力的卡
---@param g Card|Group 要被上升攻击力的卡
---@param val integer 要上升的攻击力（可以为负）
---@param reset integer|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.AtkUp(c,g,val,reset,resetcount)
    if not c or not g then return end
    if not resetcount then resetcount=1 end
    if not reset then reset=RESET_PHASE+PHASE_END end
    if not val or val==0 then return end
    if VgF.GetValueType(g)=="Group" and g:GetCount()>0 then
        local e={}
        for tc in VgF.Next(g) do
            if tc:IsLocation(LOCATION_MZONE) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(val)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset,resetcount)
                tc:RegisterEffect(e1)
                table.insert(e,e1)
            end
        end
        return e
    elseif VgF.GetValueType(g)=="Card" then
        local tc=g
        if tc:IsLocation(LOCATION_MZONE) then
            local tc=VgF.ReturnCard(g)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset,resetcount)
            tc:RegisterEffect(e1)
            return e1
        end
    end
end
---以c的名义，使g（中的每一张卡）的盾值上升val，并在reset时重置。
---@param c Card 要使卡上升盾值的卡
---@param g Card|Group 要被上升盾值的卡
---@param val integer 要上升的盾值（可以为负）
---@param reset integer|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.DefUp(c,g,val,reset,resetcount)
    if not c or not g then return end
    if not reset then reset=RESET_PHASE+PHASE_END end
    if not resetcount then resetcount=1 end
    if not val or val==0 then return end
    if VgF.GetValueType(g)=="Group" and g:GetCount()>0 then
        local e={}
        for tc in VgF.Next(g) do
            if tc:IsLocation(LOCATION_MZONE) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_DEFENSE)
                e1:SetValue(val)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset,resetcount)
                tc:RegisterEffect(e1)
                table.insert(e,e1)
            end
        end
        return e
    elseif VgF.GetValueType(g)=="Card" then
        local tc=g
        if tc:IsLocation(LOCATION_MZONE) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_DEFENSE)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset,resetcount)
            tc:RegisterEffect(e1)
            return e1
        end
    end
end
---以c的名义，使g（中的每一张卡）的☆上升val，并在reset时重置。
---@param c Card 要使卡上升☆的卡
---@param g Card|Group 要被上升☆的卡
---@param val integer 要上升的☆（可以为负）
---@param reset integer|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.StarUp(c,g,val,reset,resetcount)
    if not c or not g then return end
    if not reset then reset=RESET_PHASE+PHASE_END end
    if not resetcount then resetcount=1 end
    if not val or val==0 then return end
    if VgF.GetValueType(g)=="Group" and g:GetCount()>0 then
        local t1={}
        local t2={}
        for tc in VgF.Next(g) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LSCALE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset,resetcount)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_RSCALE)
            tc:RegisterEffect(e2)
            table.insert(t1,e1)
            table.insert(t2,e2)
        end
        return t1,t2
    elseif VgF.GetValueType(g)=="Card" then
        local tc=VgF.ReturnCard(g)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_LSCALE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(val)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset,resetcount)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_RSCALE)
        tc:RegisterEffect(e2)
        return e1,e2
    end
end
---判断c是否可以以规则的手段到G区域。
---@param c Card 要判断的卡
---@return boolean 指示c能否去到G区域。
function VgF.IsAbleToGZone(c,loc)
    if loc==LOCATION_HAND then
        return c:IsType(TYPE_MONSTER)
    elseif loc==LOCATION_MZONE then
        return c:IsAttribute(SKILL_BLOCK) and VgF.IsSequence(c,0,4) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
    end
    return false
end
---用于效果的Operation。它返回一个执行“[计数回充val]”的函数。
---@param val integer 计数回充的数量
---@return function 效果的Operation函数
function VgF.DamageFill(val)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
        local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,val,val,nil)
        Duel.ChangePosition(g,POS_FACEUP_ATTACK)
        return Duel.GetOperatedGroup():GetCount()
    end
end
---用于效果的Cost。它返回一个执行“【费用】[将手牌中的val张卡舍弃]”的函数。
---@param val integer 要舍弃的卡的数量
---@return function 效果的Cost函数
function VgF.DisCardCost(val)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        if VgF.GetValueType(val)~="number" then return 0 end
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        if chk==0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddMixCostGroupFrom(c,m,"LOCATION_HAND")
                VgF.AddMixCostGroupTo(c,m,"LOCATION_DROP")
                VgF.AddMixCostGroupFilter(c,m,nil)
                VgF.AddMixCostGroupCountMin(c,m,val)
                VgF.AddMixCostGroupCountMax(c,m,val)
            end
            return VgF.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,val,nil)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,val,val,nil)
        return VgF.Sendto(LOCATION_DROP,g,REASON_COST+REASON_DISCARD)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[能量爆发val]”的函数。
---@param val integer 能量爆发的数量
---@return function 效果的Cost函数
function VgF.EnergyCost(val)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        if VgF.GetValueType(val)~="number" then return 0 end
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        if chk==0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddMixCostGroupFrom(c,m,"LOCATION_EMBLEM")
                VgF.AddMixCostGroupTo(c,m,"0")
                VgF.AddMixCostGroupFilter(c,m,function(tc) tc:IsCode(10800730) end)
                VgF.AddMixCostGroupCountMin(c,m,val)
                VgF.AddMixCostGroupCountMax(c,m,val)
            end
            return VgF.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EMBLEM,0,val,nil,10800730)
        end
        local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EMBLEM,0,nil,10800730)
        local g=VgF.GetCardsFromGroup(sg,val)
        return VgF.Sendto(0,g,tp,POS_FACEUP,REASON_COST)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[灵魂爆发val]”的函数。
---@param val integer 灵魂爆发的数量
---@return function 效果的Cost函数
function VgF.OverlayCost(val)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        if VgF.GetValueType(val)~="number" then return 0 end
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        if chk==0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddMixCostGroupFrom(c,m,"LOCATION_OVERLAY")
                VgF.AddMixCostGroupTo(c,m,"LOCATION_DROP")
                VgF.AddMixCostGroupFilter(c,m,nil)
                VgF.AddMixCostGroupCountMin(c,m,val)
                VgF.AddMixCostGroupCountMax(c,m,val)
            end
            return Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayCount()>=val
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
        local g=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():Select(tp,nil,val,val,nil)
        return VgF.Sendto(LOCATION_DROP,g,REASON_COST)
    end
end
---用于效果的Cost或Operation。它返回一个执行“【费用】[灵魂填充val]”的函数。
---@param val integer 灵魂填充的数量
---@return function 效果的Cost或Operation函数
function VgF.OverlayFill(val)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        if VgF.GetValueType(val)~="number" then return 0 end
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        if chk==0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddMixCostGroupFrom(c,m,"LOCATION_DECK")
                VgF.AddMixCostGroupTo(c,m,"LOCATION_OVERLAY")
                VgF.AddMixCostGroupFilter(c,m,nil)
                VgF.AddMixCostGroupCountMin(c,m,val)
                VgF.AddMixCostGroupCountMax(c,m,val)
            end
            return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=val
        end
        local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
        local g=Duel.GetDecktopGroup(tp,val)
        Duel.DisableShuffleCheck()
        Duel.RaiseEvent(g,EVENT_CUSTOM+EVENT_OVERLAY_FILL,e,0,tp,tp,val)
        return VgF.Sendto(LOCATION_OVERLAY,g,rc)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[计数爆发val]”的函数。
---@param val integer 计数爆发的数量
---@return function 效果的Cost函数
function VgF.DamageCost(val)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        if VgF.GetValueType(val)~="number" then return 0 end
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        if chk==0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddMixCostGroupFrom(c,m,"LOCATION_DAMAGE")
                VgF.AddMixCostGroupTo(c,m,"POSCHANGE")
                VgF.AddMixCostGroupFilter(c,m,Card.IsFaceup)
                VgF.AddMixCostGroupCountMin(c,m,val)
                VgF.AddMixCostGroupCountMax(c,m,val)
            end
            return VgF.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,val,nil)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DAMAGE)
        local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,val,val,nil)
        Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
        return Duel.GetOperatedGroup():GetCount()
    end
end
function VgF.IsCanBeCalled(c,e,tp,sumtype,pos,zone)
    if VgF.GetValueType(zone)~="number" then zone=VgF.GetAvailableLocation(tp) end
    if VgF.GetValueType(sumtype)~="number" then sumtype=0 end
    if VgF.GetValueType(pos)~="number" then pos=POS_FACEUP_ATTACK end
    if zone==0x20 and VgF.VMonsterFilter(c:GetOverlayTarget()) then
        local _,code=c:GetOriginalCode()
        return Duel.IsPlayerCanSpecialSummonMonster(tp,code,nil,TYPE_MONSTER+TYPE_EFFECT,c:GetBaseAttack(),c:GetBaseDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
    end
    return zone>0 and c:IsCanBeSpecialSummoned(e,sumtype,tp,false,false,pos,tp,zone)
end
---用于效果的Operation。执行“从loc_from中选取最少int_min，最多int_max张满足f的卡，送去loc_to。”。
---@param loc_to integer 要送去的区域。不填则返回0。
---@param loc_from integer 要选取的区域。不填则返回0。
---@param f function 卡片过滤的条件
function VgF.SearchCard(loc_to,loc_from,f,int_max,int_min)
    return function (e,tp,eg,ep,ev,re,r,rp)
        if not loc_to or not loc_from then return 0 end
        if VgF.GetValueType(int_max)~="number" then int_max=1 end
        if VgF.GetValueType(int_min)~="number" then int_min=int_max end
        if loc_to==LOCATION_HAND then
            local g=VgF.SelectMatchingCard(HINTMSG_ATOHAND,e,tp,function (c)
                return VgF.GetValueType(f)~="function" or f(c)
            end,tp,loc_from,0,int_min,int_max,nil)
            if g:GetCount()>0 then
                return VgF.Sendto(loc_to,g,nil,REASON_EFFECT)
            end
        elseif loc_to==LOCATION_MZONE then
            local g=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,function (c)
                if not VgF.IsCanBeCalled(c,e,tp) then return false end
                return VgF.GetValueType(f)~="function" or f(c)
            end,tp,loc_from,0,int_min,int_max,nil)
            if g:GetCount()>0 then
                return VgF.Sendto(loc_to,g,0,tp)
            end
        elseif loc_to==LOCATION_DROP then
            local g=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,function (c)
                return VgF.GetValueType(f)~="function" or f(c)
            end,tp,loc_from,0,int_min,int_max,nil)
            if g:GetCount()>0 then
                return VgF.Sendto(loc_to,g,REASON_EFFECT)
            end
        elseif loc_to==LOCATION_REMOVED then
            local g=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,function (c)
                return VgF.GetValueType(f)~="function" or f(c)
            end,tp,loc_from,0,int_min,int_max,nil)
            if g:GetCount()>0 then
                return VgF.Sendto(loc_to,g,POS_FACEUP,REASON_EFFECT)
            end
        elseif loc_to==LOCATION_EXILE then
            local g=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,function (c)
                return VgF.GetValueType(f)~="function" or f(c)
            end,tp,loc_from,0,int_min,int_max,nil)
            if g:GetCount()>0 then
                return VgF.Sendto(loc_to,g,REASON_EFFECT)
            end
        elseif loc_to==LOCATION_OVERLAY then
            local g=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,function (c)
                return VgF.GetValueType(f)~="function" or f(c)
            end,tp,loc_from,0,int_min,int_max,nil)
            if g:GetCount()>0 then
                local rc=VgF.GetVMonster(tp)
                return VgF.Sendto(loc_to,g,rc)
            end
        elseif bit.band(loc_to,0xf800)>0 then
            local g=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,function (c)
                return VgF.GetValueType(f)~="function" or f(c)
            end,tp,loc_from,0,int_min,int_max,nil)
            if g:GetCount()>0 then
                return VgF.Sendto(loc_to,g,tp,POS_FACEUP_ATTACK,REASON_EFFECT)
            end
        end
        return 0
    end
end
function Group.CheckSubGroup(g,f,min,max,...)
	min=min or 1
	max=max or #g
	if min > max then return false end
	local ext_params={...}
	-- selected group
	local sg=Group.CreateGroup()
	-- be select group
	local bg=g:Clone()
	for c in VgF.Next(g) do
		if VgF.CheckGroupRecursiveCapture(c,sg,bg,f,min,max,ext_params) then return true end
		bg:RemoveCard(c)
	end
	return false
end
function VgF.CheckGroupRecursiveCapture(c,sg,bg,f,min,max,ext_params)
	sg=sg+c
	if VgF.G_Add_Check and not VgF.G_Add_Check(sg,c,bg) then
		sg=sg-c
		return false
	end
	local res=#sg >= min and #sg<=max and (not f or f(sg,table.unpack(ext_params)))
	if not res and #sg<max then
		res=bg:IsExists(VgF.CheckGroupRecursiveCapture,1,sg,sg,bg,f,min,max,ext_params)
	end
	sg=sg-c
	return res
end
function Group.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	VgF.SubGroupCaptured=Group.CreateGroup()
	min=min or 1
	max=max or #g
	local ext_params={...}
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	for tc in VgF.Next(fg) do
		fg:SelectUnselect(sg,tp,false,false,min,max)
	end
	sg:Merge(fg)
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		local cg=Group.CreateGroup()
		local eg=g:Clone()
		for c in VgF.Next(g-sg) do
			if not cg:IsContains(c) then
				if VgF.CheckGroupRecursiveCapture(c,sg,eg,f,min,max,ext_params) then
					cg:Merge(VgF.SubGroupCaptured)
				else
					eg:RemoveCard(c)
				end
			end
		end
		cg:Sub(sg)
		finish=(#sg>=min and #sg<=max and f(sg,...))
		if #cg==0 then break end
		local cancel=not finish and cancelable
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
		if not tc then break end
		if not fg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==max then finish=true end
			else
				sg:RemoveCard(tc)
			end
		elseif cancelable then
			return nil
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
function Group.SelectDoubleSubGroup(g,p,f1,int_min1,int_max1,f2,int_min2,int_max2,except_g,...)
    if VgF.GetValueType(f1)~="function" then f1=VgF.True end
    if VgF.GetValueType(f2)~="function" then f2=VgF.True end
    local result=Group.CreateGroup()
    local g1=g:Filter(f1,except_g,...)
    local g2=g:Filter(f2,except_g,...)
    local g3=Group.__band(g1,g2)
    if g:GetCount()<int_min1+int_min2 or g1:GetCount()<int_min1 or g2:GetCount()<int_min2 then return result end
	if g1:GetCount()<int_max1 then int_max1=g1:GetCount() end
	if g2:GetCount()<int_max2 then int_max2=g2:GetCount() end
    if g3:GetCount()==g2:GetCount() and g3:GetCount()==g1:GetCount() then
        local min=int_min1+int_min2
        local max=int_max1+int_max2
        return g3:SelectSubGroup(p,vgf.True,false,min,max)
    end
    local result1=Group.CreateGroup()
    local result2=Group.CreateGroup()
    while result1:GetCount()<int_max1 do
        local sg=Group.__sub(g1,result1)
        local check_group=Group.__sub(g2,result1)
        for tc in VgF.Next(Group.__sub(g1,result1)) do
            if g3:IsContains(tc) and not check_group:IsExists(VgF.True,int_min2,tc) then sg:RemoveCard(tc) end
        end
		local btok=false
		if result1:GetCount()>=int_min1 then btok=true end
        local tc=sg:SelectUnselect(result1,p,btok,false,int_min1,int_max1)
        if not tc then break
        elseif result1:IsContains(tc) then result1:RemoveCard(tc)
        else result1:AddCard(tc) end
    end
    g2:Sub(result1)
    while result2:GetCount()<int_max2 do
        local sg=Group.__sub(g2,result2)
		local btok=false
		if result2:GetCount()>=int_min2 then btok=true end
        local tc=sg:SelectUnselect(result2,p,btok,false,int_min2,int_max2)
        if not tc then break
        elseif result2:IsContains(tc) and not result1:IsContains(tc) then result2:RemoveCard(tc)
        else result2:AddCard(tc) end
    end
    result=Group.__add(result1,result2)
    return result
end
---返回p场上的先导者。
---@param p integer 要获取先导者的玩家。不合法则返回nil。
---@return Card|nil p场上的先导者
function VgF.GetVMonster(p)
    if p~=0 and p~=1 then return end
    return Duel.GetMatchingGroup(VgF.VMonsterFilter,p,LOCATION_MZONE,0,nil):GetFirst()
end
---判断c是否在前列。
---@param c Card 要判断的卡
---@return boolean 指示c是否是前列的单位
function VgF.FrontFilter(c)
    local seq=c:GetSequence()
    return (seq==0 or seq==4 or seq==5) and c:IsType(TYPE_MONSTER)
end
---判断c是否在后列。
---@param c Card 要判断的卡
---@return boolean 指示c是否是后列的单位
function VgF.BackFilter(c)
    local seq=c:GetSequence()
    return (seq==1 or seq==2 or seq==3) and c:IsType(TYPE_MONSTER)
end
function VgF.PrisonFilter(c,ct)
    return c:GetSequence() == ct-1
end
---收容g（中的每一张卡）到p的监狱。没有监狱时，不操作。
---@param g Card|Group
---@param p integer
function VgF.SendtoPrison(g,p)
    if not VgF.CheckPrison(p) or not g then return end
	local og=Duel.GetFieldGroup(p,LOCATION_ORDER,0)
	local oc=og:Filter(VgF.PrisonFilter,nil,og:GetCount()):GetFirst()
    if VgF.GetValueType(g)=="Card" then
	    VgF.Sendto(LOCATION_ORDER,g,p,POS_FACEUP_ATTACK,REASON_EFFECT)
        g:RegisterFlagEffect(FLAG_IMPRISON,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,VgF.Stringid(10105015,0))
    elseif VgF.GetValueType(g)=="Group" then
        for tc in VgF.Next(g) do
            VgF.Sendto(LOCATION_ORDER,tc,p,POS_FACEUP_ATTACK,REASON_EFFECT)
            tc:RegisterFlagEffect(FLAG_IMPRISON,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,VgF.Stringid(10105015,0))
        end
    end
	Duel.MoveSequence(oc,og:GetCount()-1)
end
--[[
function VgF.PrisonFilter(c,tp)
    return c:IsSetCard(0x3040) and not VgF.IsExistingMatchingCard(function (tc)
        return tc:GetSequence()<c:GetSequence()
    end,tp,LOCATION_ORDER,0,1,c)
end
---收容g（中的每一张卡）到p的监狱。没有监狱时，不操作。
---@param g Card|Group
---@param p integer
function VgF.SendtoPrison(g,p)
    if not VgF.CheckPrison(p) or not g then return end
	local og=Duel.GetFieldGroup(p,LOCATION_ORDER,0)
	local oc=og:Filter(VgF.PrisonFilter,nil,p):GetFirst()
    if VgF.GetValueType(g)=="Card" then
	    Duel.Sendto(g,p,LOCATION_ORDER,POS_FACEUP_ATTACK,REASON_EFFECT,1)
        g:RegisterFlagEffect(FLAG_IMPRISON,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,VgF.Stringid(10105015,0))
    elseif VgF.GetValueType(g)=="Group" then
        for tc in VgF.Next(g) do
            Duel.Sendto(tc,p,LOCATION_ORDER,POS_FACEUP_ATTACK,REASON_EFFECT,1)
            tc:RegisterFlagEffect(FLAG_IMPRISON,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,VgF.Stringid(10105015,0))
        end
    end
end]]
---检测p场上有没有监狱。
---@param p integer
---@return boolean 指示p场上有没有监狱。
function VgF.CheckPrison(p)
	local og=Duel.GetFieldGroup(p,LOCATION_ORDER,0)
	return og:IsExists(Card.IsSetCard,1,nil,0x3040)
end
--重置Effect
function VgF.EffectReset(c,e,code,con)
    if VgF.GetValueType(e)=="Effect" then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(code)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetRange(LOCATION_ALL)
        e1:SetLabelObject(e)
        if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
        e1:SetOperation(VgF.EffectResetOperation)
        c:RegisterEffect(e1)
    elseif VgF.GetValueType(e)=="table" then
        for i,v in ipairs(e) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(code)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_ALL)
            e1:SetLabelObject(v)
            if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
            e1:SetOperation(VgF.EffectResetOperation)
            c:RegisterEffect(e1)
        end
    end
end
function VgF.EffectResetOperation(e,tp,eg,ep,ev,re,r,rp)
    local e1=e:GetLabelObject()
    if VgF.GetValueType(e1)=="Effect" then e1:Reset() end
    e:Reset()
end
function VgF.IsExistingMatchingCard(f,tp,loc_self,loc_op,int,except_g,...)
    return VgF.GetMatchingGroupCount(f,tp,loc_self,loc_op,except_g,...)>=int
end
function VgF.SelectMatchingCard(hintmsg,e,select_tp,f,tp,loc_self,loc_op,int_min,int_max,except_g,...)
    local a=false
    if ((select_tp==tp and bit.band(loc_self,LOCATION_DECK)>0) or (select_tp~=tp and bit.band(loc_op,LOCATION_DECK)>0)) and Duel.SelectYesNo(select_tp,VgF.Stringid(VgID,13)) then
        local g=Duel.GetFieldGroup(select_tp,LOCATION_DECK,0)
        Duel.DisableShuffleCheck()
        Duel.ConfirmCards(select_tp,g)
        a=true
    end
    local g=Group.CreateGroup()
    if bit.band(loc_self,LOCATION_MZONE)>0 then
        local g1=Duel.GetMatchingGroup(function (c)
            return c:IsCanBeEffectTarget(e) and c:IsFaceup()
        end,tp,LOCATION_MZONE,0,nil)
        loc_self=loc_self-LOCATION_MZONE
        if g1:GetCount()>0 then g:Merge(g1) end
    end
    if bit.band(loc_op,LOCATION_MZONE)>0 then
        local g1=Duel.GetMatchingGroup(function (c)
            return c:IsCanBeEffectTarget(e) and c:IsFaceup()
        end,tp,0,LOCATION_MZONE,nil)
        loc_op=loc_op-LOCATION_MZONE
        if g1:GetCount()>0 then g:Merge(g1) end
    end
    if loc_self>0 or loc_op>0 then
        local g1=Duel.GetMatchingGroup(nil,tp,loc_self,loc_op,nil)
        if g1:GetCount()>0 then g:Merge(g1) end
    end
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,select_tp,hintmsg)
        if VgF.GetValueType(f)=="function" then
            g=g:FilterSelect(select_tp,f,int_min,int_max,except_g,...)
        else
            g=g:Select(select_tp,int_min,int_max,except_g)
        end
    end
    local cg=g:Filter(function (tc)
        return not tc:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
    end,nil)
    if cg:GetCount()>0 then Duel.HintSelection(cg) end
    if a then Duel.ShuffleDeck(select_tp) end
    return g
end
function VgF.GetMatchingGroupCount(f,tp,loc_self,loc_op,except_g,...)
    return VgF.GetMatchingGroup(f,tp,loc_self,loc_op,except_g,...):GetCount()
end
function VgF.GetMatchingGroup(f,tp,loc_self,loc_op,except_g,...)
    local g=Group.CreateGroup()
    if bit.band(loc_self,LOCATION_MZONE)>0 then
        local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        loc_self=loc_self-LOCATION_MZONE
        if g1:GetCount()>0 then g:Merge(g1) end
    end
    if bit.band(loc_op,LOCATION_MZONE)>0 then
        local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        loc_op=loc_op-LOCATION_MZONE
        if g1:GetCount()>0 then g:Merge(g1) end
    end
    if loc_self>0 or loc_op>0 then
        local g1=Duel.GetMatchingGroup(nil,tp,loc_self,loc_op,nil)
        if g1:GetCount()>0 then g:Merge(g1) end
    end
    if g:GetCount()>0 and VgF.GetValueType(f)=="function" then
        g=g:Filter(f,except_g,...)
    end
    return g
end
---用于效果的Operation。执行“把卡sg，送去loc,第三个参数开始为额外参数，内容与原函数相同。”。
---@param loc integer 要送去的区域。不填则返回0。
---@param sg integer 要操作的卡|卡片组。
---@return number 具体操作的卡的数量
function VgF.Sendto(loc,sg,...)
    local ext_params={...}
    local function AddOverlayGroup(g,o_loc)
        for tc in VgF.Next(g) do
            if tc:GetOverlayCount()>0 then
                local mg=tc:GetOverlayGroup()
                VgF.Sendto(o_loc,mg,table.unpack(ext_params))
            end
        end
    end
    local g=nil
    if VgF.GetValueType(sg)=="Group" and sg:GetCount()>0 then
        g=Group.Clone(sg)
    elseif VgF.GetValueType(sg)=="Card" then
        g=Group.FromCards(sg)
    else return 0
    end
    if loc==LOCATION_DROP then
        AddOverlayGroup(g,LOCATION_DROP)
        local function repfilter(c,tp)
            return c:IsControler(tp) and (c:IsLocation(LOCATION_GZONE) or VgF.RMonsterFilter(c)) and c:IsType(TYPE_MONSTER) and c:GetLevel()%2==1
        end
        local print=0
        for tp=0,1 do
            local replace_to_overlay_group=g:Filter(repfilter,nil,tp)
            local ct=replace_to_overlay_group:GetCount()
            if Duel.IsPlayerAffectedByEffect(tp,10501118) and ct>0 and Duel.SelectYesNo(tp,VgF.Stringid(10501118,0)) then
                if ct>1 then replace_to_overlay_group=replace_to_overlay_group:Select(tp,1,ct,nil) end
                local ct1=VgF.Sendto(LOCATION_OVERLAY,replace_to_overlay_group,VgF.GetVMonster(tp))
                print=print+ct1
                g:Sub(replace_to_overlay_group)
            end
        end
        if g:GetCount()>0 then
            local ct=Duel.SendtoGrave(g,...)
            print=print+ct
        end
        return print
    elseif loc==LOCATION_DECK then
        return Duel.SendtoDeck(g,...)
    elseif loc==LOCATION_HAND then
        local ct=Duel.SendtoHand(g,...)
        local cg=Duel.GetOperatedGroup()
        for tp=0,1 do
            local confirm_group=cg:Filter(Card.IsControler,nil,tp)
            if confirm_group:GetCount()>0 then
                Duel.ConfirmCards(1-tp,confirm_group)
                Duel.ShuffleHand(tp)
            end
        end
        return ct
    elseif loc==LOCATION_REMOVED then
        AddOverlayGroup(g,LOCATION_REMOVED)
        return Duel.Remove(g,...)
    elseif loc==LOCATION_EXILE then
        AddOverlayGroup(g,LOCATION_EXILE)
        return Duel.Exile(g,...)
    elseif loc==LOCATION_OVERLAY then
        AddOverlayGroup(g,LOCATION_OVERLAY)
        local ct=0
        if #ext_params>0 then
            local c=ext_params[1]
            Duel.Overlay(c,g)
            ct=Duel.GetOperatedGroup():GetCount()
        else
            for tp=0,1 do
                local c=VgF.GetVMonster(tp)
                local og=g:Filter(Card.IsControler,nil,tp)
                if og:GetCount()>0 then
                    Duel.Overlay(c,og)
                    ct=ct+Duel.GetOperatedGroup():GetCount()
                end
            end
        end
        return ct
    elseif loc==LOCATION_TRIGGER then
        local ct=0
        for tc in VgF.Next(g) do
            if Duel.MoveToField(tc,table.unpack(ext_params)) then ct=ct+1 end
        end
        return ct
    elseif loc==LOCATION_MZONE then
        return VgF.Call(g,table.unpack(ext_params))
    elseif bit.band(loc,0xf800)>0 or loc==0 then
        AddOverlayGroup(g,loc)
        Duel.Sendto(g,table.unpack(ext_params))
        local return_group=Duel.GetOperatedGroup()
        return return_group:GetCount()
    end
    return 0
end
-- 白翼能力在你的封锁区中的卡只有奇数的等级的场合有效
function VgF.WhiteWing(e)
    local tp=e:GetHandlerPlayer()
    local a=vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2==1
    end,tp,LOCATION_REMOVED,0,1,nil)
    local b=vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2==0
    end,tp,LOCATION_REMOVED,0,1,nil)
    return (not a and b) or Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_BOTH_WING)
end
-- 黑翼能力在你的封锁区中的卡只有偶数的等级的场合有效
function VgF.DarkWing(e)
    local tp=e:GetHandlerPlayer()
    local a=vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2==1
    end,tp,LOCATION_REMOVED,0,1,nil)
    local b=vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2==0
    end,tp,LOCATION_REMOVED,0,1,nil)
    return (a and not b) or Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_BOTH_WING)
end

function VgF.AddRideMaterialSetCardCheck(c,m,...)
    local cm=_G["c"..m]
    cm.ride_material_setcard_chk={...}
end
function VgF.AddRideMaterialCodeCheck(c,m,...)
    local cm=_G["c"..m]
    cm.ride_material_code_chk={...}
end
function VgF.AddRideMaterialSetCard(c,m,...)
    local cm=_G["c"..m]
    cm.ride_setcard={...}
end
function VgF.AddRideMaterialCode(c,m,...)
    local cm=_G["c"..m]
    cm.ride_code={...}
end
function VgF.AddMixCostGroupFrom(c,m,...)
    local cm=_G["c"..m]
    cm.cos_from={...}
end
function VgF.AddMixCostGroupTo(c,m,...)
    local cm=_G["c"..m]
    cm.cos_to={...}
end
function VgF.AddMixCostGroupCountMin(c,m,...)
    local cm=_G["c"..m]
    cm.cos_val={...}
end
function VgF.AddMixCostGroupCountMax(c,m,...)
    local cm=_G["c"..m]
    cm.cos_val_max={...}
end
function VgF.AddMixCostGroupFilter(c,m,...)
    local cm=_G["c"..m]
    cm.cos_filter={...}
end
function VgF.ShiftLocationFromString(str)
    local loc=0
    if str=="POSCHANGE" then return str end
    for i=1,13 do
        if str==LOCATION_LIST_STRING[i] then
            loc=LOCATION_LIST[i]
            break
        end
    end
    return loc
end

function table.copy(copy,original)
    copy={}
    if VgF.GetValueType(original)~="table" then return end
    for i = 1, #original do
        table.insert(copy, original[i])
    end
end