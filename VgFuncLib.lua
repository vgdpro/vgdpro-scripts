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
    if c:IsType(TYPE_MONSTER) then
        VgD.RideUp(c)
        VgD.CallToR(c)
        VgD.MonsterBattle(c)
    end
    if not c:IsRace(TRRIGGER_SUPER) then
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
    if not count then count=nil end
    if not property then property=nil end
    if not reset then reset=nil end
    if not op then op=nil end
    if not cost then cost=nil end
    if not con then con=nil end
    if not tg then tg=nil end
    if not f then f=nil end
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
---@return Card|nil
function VgF.ReturnCard(g)
    local tc
    if VgF.GetValueType(g)=="Group" then
        tc=g:GetFirst()
    elseif VgF.GetValueType(g)=="Card" then
        tc=g
    end
    return tc
end
---返回g的前num张卡。
---@param g Group 要操作的卡片组
---@param num integer 要获取的卡片数量
function VgF.GetCardsFromGroup(g,num)
    if VgF.GetValueType(g)=="Group" then
        local sg=Group.CreateGroup()
        for tc in VgF.Next(g) do
            if sg:GetCount()>=num then break end
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
---判断c是否是某（几）个等级（之一）。
---@param c Card 要判断的卡
---@param ... integer 等级
---@return boolean 指示是否是给定等级中的一个
function VgF.IsLevel(c,...)
    for i,v in ipairs{...} do
        local lv=v+1
        if c:IsLevel(lv) then
            return true
        end
    end
    return false
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
---@param zone integer 指示要Call到的格子。<br>前列的R：17； 后列的R：14； 全部的R：31； V：32
---@param pos integer 表示形式
---@return integer Call成功的数量
function VgF.Call(g,sumtype,tp,zone,pos)
    if (VgF.GetValueType(g)~="Card" and VgF.GetValueType(g)~="Group") or (VgF.GetValueType(g)=="Group" and g:GetCount()==0) then return 0 end
    if VgF.GetValueType(pos)~="number" then pos=POS_FACEUP_ATTACK end
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
            local tc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
            local mg=tc:GetOverlayGroup()
            if mg:GetCount()~=0 then
                Duel.Overlay(sc,mg)
            end
            sc:SetMaterial(Group.FromCards(tc))
            Duel.Overlay(sc,Group.FromCards(tc))
        elseif Duel.IsExistingMatchingCard(VgD.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,szone) then
            local tc=Duel.GetMatchingGroup(VgD.CallFilter,tp,LOCATION_MZONE,0,nil,tp,szone):GetFirst()
            Duel.SendtoGrave(tc,REASON_COST)
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
                    Duel.Overlay(sc,mg)
                end
                sc:SetMaterial(Group.FromCards(rc))
                Duel.Overlay(sc,Group.FromCards(rc))
                Duel.SpecialSummonStep(sc,sumtype,tp,tp,false,false,pos,0x20)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CallZONE)
                local szone=Duel.SelectField(tp,1,LOCATION_MZONE,0,z)
                if Duel.IsExistingMatchingCard(VgD.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,szone) then
                    local tc=Duel.GetMatchingGroup(VgD.CallFilter,tp,LOCATION_MZONE,0,nil,tp,szone):GetFirst()
                    Duel.SendtoGrave(tc,REASON_COST)
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
    return Duel.IsExistingMatchingCard(VgF.LvConditionFilter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function VgF.LvConditionFilter(c,lv)
    return VgF.VMonsterFilter(c) and c:IsLevelAbove(lv)
end
---以c的名义，使g（中的每一张卡）的攻击力上升val，并在reset时重置。
---@param c Card 要使卡上升攻击力的卡
---@param g Card|Group 要被上升攻击力的卡
---@param val integer 要上升的攻击力（可以为负）
---@param reset integer|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.AtkUp(c,g,val,reset)
    if not c then return end
    if not reset then reset=RESET_PHASE+PHASE_END end
    if not val or val==0 then return end
    if VgF.GetValueType(g)=="Group" and g:GetCount()>0 then
        local e={}
        for tc in VgF.Next(g) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
            tc:RegisterEffect(e1)
            table.insert(e,e1)
        end
        return e,#e
    elseif VgF.GetValueType(g)=="Card" then
        local tc=VgF.ReturnCard(g)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(val)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
        tc:RegisterEffect(e1)
        return e1,1
    end
end
---以c的名义，使g（中的每一张卡）的盾值上升val，并在reset时重置。
---@param c Card 要使卡上升盾值的卡
---@param g Card|Group 要被上升盾值的卡
---@param val integer 要上升的盾值（可以为负）
---@param reset integer|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.DefUp(c,g,val,reset)
    if not c then return end
    if not reset then reset=RESET_PHASE+PHASE_END end
    if not val or val==0 then return end
    if VgF.GetValueType(g)=="Group" and g:GetCount()>0 then
        local e={}
        for tc in VgF.Next(g) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_DEFENSE)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
            tc:RegisterEffect(e1)
            table.insert(e,e1)
        end
        return e,#e
    elseif VgF.GetValueType(g)=="Card" then
        local tc=VgF.ReturnCard(g)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(val)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
        tc:RegisterEffect(e1)
        return e1,1
    end
end
---以c的名义，使g（中的每一张卡）的☆上升val，并在reset时重置。
---@param c Card 要使卡上升☆的卡
---@param g Card|Group 要被上升☆的卡
---@param val integer 要上升的☆（可以为负）
---@param reset integer|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.StarUp(c,g,val,reset)
    if not c or not g then return end
    if not reset then reset=RESET_PHASE+PHASE_END end
    if not val or val==0 then return end
    if VgF.GetValueType(g)=="Group" and g:GetCount()>0 then
        local el={}
        local er={}
        for tc in VgF.Next(g) do
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
            table.insert(el,e1)
            table.insert(er,er)
        end
        return el,er,#el,#er
    elseif VgF.GetValueType(g)=="Card" then
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
        return e1,e2,1,1
    end
end
---判断c是否可以以规则的手段到G区域。
---@param c Card 要判断的卡
---@return boolean 指示c能否去到G区域。
function VgF.IsAbleToGZone(c)
    if c:IsLocation(LOCATION_HAND) then return true end
    local tp=c:GetControler()
    return c:IsAttribute(SKILL_BLOCK) and VgF.IsSequence(c,0,4) and not Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_SENDTOG_MZONE) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
---用于效果的Cost。它返回一个执行“【费用】[将手牌中的num张卡舍弃]”的函数。
---@param num integer 要舍弃的卡的数量
---@return function 效果的Cost函数
function VgF.DisCardCost(num)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        local cm=_G["c"..m]
        if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
            cm.cos_g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
            cm.cos_val={nil,num,num}
        end
        if chk==0 then
            return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,num,nil)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,num,num,nil)
        Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[能量爆发num]”的函数。
---@param num integer 能量爆发的数量
---@return function 效果的Cost函数
function VgF.EnergyCost(num)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        local cm=_G["c"..m]
        if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
            cm.cos_g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EMBLEM,0,nil,10800730)
            cm.cos_val={nil,num,num}
        end
        if chk==0 then
            return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EMBLEM,0,num,nil,10800730)
        end
        local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EMBLEM,0,nil,10800730)
        local g=VgF.GetCardsFromGroup(sg,num)
        Duel.Sendto(g,tp,0,POS_FACEUP,REASON_COST)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[灵魂爆发num]”的函数。
---@param num integer 灵魂爆发的数量
---@return function 效果的Cost函数
function VgF.OverlayCost(num)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        local cm=_G["c"..m]
        if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
            cm.cos_g=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayGroup():FilterCount(Card.IsAbleToGraveAsCost,nil)
            cm.cos_val={nil,num,num}
        end
        if chk==0 then
            return Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil,nil):GetFirst():GetOverlayGroup():FilterCount(Card.IsAbleToGraveAsCost,nil)>=num
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
        local g=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,num,num,nil)
        Duel.SendtoGrave(g,REASON_COST)
    end
end
---用于效果的Cost或Operation。它返回一个执行“【费用】[灵魂填充num]”的函数。
---@param num integer 灵魂填充的数量
---@return function 效果的Cost或Operation函数
function VgF.OverlayFill(num)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        local cm=_G["c"..m]
        if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
            cm.cos_g=Duel.GetFieldGroupCount(tp,LOCATION_DECK)
            cm.cos_val={nil,num,num}
        end
        if chk==0 then
            return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=num
        end
        VgF.OverlayFillOP(num,e,tp,eg,ep,ev,re,r,rp)
    end
end
function VgF.OverlayFillOP(num,e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    local g=Duel.GetDecktopGroup(tp,num)
    Duel.DisableShuffleCheck()
    Duel.Overlay(rc,g)
end
---用于效果的Cost。它返回一个执行“【费用】[计数爆发num]”的函数。
---@param num integer 计数爆发的数量
---@return function 效果的Cost函数
function VgF.DamageCost(num)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        local m=c:GetOriginalCode()
        local cm=_G["c"..m]
        if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
            cm.cos_g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DAMAGE,0,nil)
            cm.cos_val={nil,num,num}
        end
        if chk==0 then
            return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,num,nil)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DAMAGE)
        local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,num,num,nil)
        Duel.ChangePosition(g,POS_FACEDOWN_ATTACK)
    end
end
---用于效果的Operation。执行“从loc中选取1张满足f的卡，返回手牌。”。
---@param loc integer 要选取的区域。不填则返回nil，而不是效果的Operation函数。
---@param f function 卡片过滤的条件
---@return function|nil 效果的Operation函数
function VgF.SearchCard(loc,f)
    if not loc then return end
    return function (e,tp,eg,ep,ev,re,r,rp)
        VgF.SearchCardOP(loc,f,e,tp,eg,ep,ev,re,r,rp)
    end
end
function VgF.SearchCardOP(loc,f,e,tp,eg,ep,ev,re,r,rp)
    if not loc then return end
    Duel.Hint(HINT_SELECTMSG,tp ,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,function (c)
        if VgF.GetValueType(f)=="function" and not f(c) then return false end
        return c:IsAbleToHand()
    end,tp,loc,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    local sg=Duel.GetOperatedGroup()
    return sg:GetCount()
end
    ---用于效果的Operation。执行“从loc中选取1张满足f的卡，Call到R上。”。
---@param loc integer 要选取的区域。不填则返回nil，而不是效果的Operation函数。
---@param f function 卡片过滤的条件
---@return function|nil 效果的Operation函数
function VgF.SearchCardSpecialSummon(loc,f)
    if not loc then return end
    return function (e,tp,eg,ep,ev,re,r,rp)
        VgF.SearchCardSpecialSummonOP(loc,f,e,tp,eg,ep,ev,re,r,rp)
    end
end
function VgF.SearchCardSpecialSummonOP(loc,f,e,tp,eg,ep,ev,re,r,rp)
    if not loc then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
    local g=Duel.SelectMatchingCard(tp,function (c)
        if VgF.GetValueType(f)=="function" and not f(c) then return false end
        return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
    end,tp,loc,0,1,1,nil)
    if g:GetCount()>0 then
        if loc&LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA==0 then Duel.HintSelection(g) end
        VgF.Call(g,0,tp)
    end
    local sg=Duel.GetOperatedGroup()
    return sg:GetCount()
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
	    Duel.Sendto(g,p,LOCATION_ORDER,POS_FACEUP_ATTACK,REASON_EFFECT)
        g:RegisterFlagEffect(ImprisonFlag,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,vgf.Stringid(10105015,0))
    elseif VgF.GetValueType(g)=="Group" then
        for tc in VgF.Next(g) do
            Duel.Sendto(tc,p,LOCATION_ORDER,POS_FACEUP_ATTACK,REASON_EFFECT)
            tc:RegisterFlagEffect(ImprisonFlag,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,vgf.Stringid(10105015,0))
        end
    end
	Duel.MoveSequence(oc,og:GetCount()-1)
end
---检测p场上有没有监狱。
---@param p integer
---@return boolean 指示p场上有没有监狱。
function VgF.CheckPrison(p)
	local og=Duel.GetFieldGroup(p,LOCATION_ORDER,0)
	local oc=og:Filter(VgF.PrisonFilter,nil,og:GetCount()):GetFirst()
	return oc:IsSetCard(0x3040)
end
--重置Effect
function VgF.EffectReset(c,e,code,con)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(code)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_ALL)
    e1:SetLabelObject(e)
    if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
    e1:SetOperation(VgF.EffectResetOperation)
    c:RegisterEffect(e1)
end
function VgF.EffectResetOperation(e,tp,eg,ep,ev,re,r,rp)
    local e1=e:GetLabelObject()
    if VgF.GetValueType(e1)=="Effect" then e1:Reset() end
end