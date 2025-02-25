--VgF库
VgF = {}
vgf = VgF
bit = {}

---@class Card
---@class Group
---@class Effect

---获取脚本基本信息
function GetID()
    local offset = self_code < 100000000 and 1 or 100
    return self_table, self_code, offset
end
---根据卡号和索引获取描述编号
---@param code number 卡片密码
---@param id number 索引
---@return number 描述的编号
function VgF.Stringid(code, id)
    return code * 16 + id
end
---根据控制者，区域和编号获取zone；不合法的数据会返回0
---@param p number 控制者
---@param loc number 所在区域，若不是LOCATION_MZONE或LOCATION_SZONE则返回0
---@param seq number 编号
---@return number 卡片所在的zone
function VgF.SequenceToGlobal(p, loc, seq)
	if p ~= 0 and p ~= 1 then return 0 end
	if loc==LOCATION_MZONE then
		if seq <= 6 then return 0x0001 << (seq) end
	elseif loc == LOCATION_SZONE then
		if seq <= 4 then return 0x0100 << (16 * p + seq) end
    end
    return 0
end
---一个总是返回true的函数。
---@return true
function VgF.True()
    return true
end
---一个总是返回false的函数。
---@return false
function VgF.False()
    return false
end
---返回g中的“下一张卡”。第一次调用会返回第一张卡。没有下一张卡会返回nil。
---@param g Group 要遍历的卡片组
---@return function 指示返回的卡的函数
function VgF.Next(g)
    local first = true
    return  function()
                if first then first = false return g:GetFirst()
                else return g:GetNext() end
            end
end
---返回v在lua中的变量类型，以string方式呈现。
---@param v any 要获取类型的变量（或常量）
---@return string 以字符串形式呈现的类型
function VgF.GetValueType(v)
    local t = type(v)
    if t == "userdata" then
        local mt = getmetatable(v)
        if mt == Group then return "Group"
        elseif mt == Effect then return "Effect"
        else return "Card" end
    else return t end
end
---如果g是Group的话，返回其第一张卡；如果g是Card的话，返回其本身；否则返回nil。
---@param g any 要操作的变量
---@return Card
function VgF.ReturnCard(g)
    local tc = nil
    if VgF.GetValueType(g) == "Group" then
        tc = g:GetFirst()
    elseif VgF.GetValueType(g) == "Card" then
        tc = g
    end
    return tc
end

function VgF.ReturnGroup(tc)
    local g = Group.CreateGroup()
    if VgF.GetValueType(tc) == "Group" then
        return tc
    elseif VgF.GetValueType(g) == "Card" then
        g.AddCard(tc)
    end
    return g
end

---返回g的前val张卡。
---@param g Group 要操作的卡片组
---@param val number 要获取的卡片数量
function VgF.GetCardsFromGroup(g, val)
    if VgF.GetValueType(g) == "Group" then
        local sg = Group.CreateGroup()
        for tc in VgF.Next(g) do
            if sg:GetCount() >= val then break end
            sg:AddCard(tc)
        end
        return sg
    end
end
function bit.ReturnCount(n)
    if n == 0 then
        return 0
    end
    return 1 + bit.ReturnCount(n & (n - 1))
end

function table.copy(copy, original)
    copy = {}
    if VgF.GetValueType(original) ~= "table" then return end
    for i = 1, #original do
        table.insert(copy, original[i])
    end
end

---返回对a和b进行按位与运算的结果。
---@param a number 操作数1
---@param b number 操作数2
---@return number 运算结果
function bit.band(a, b)
    return a & b
end
---返回对a和b进行按位或运算的结果。
---@param a number 操作数1
---@param b number 操作数2
---@return number 运算结果
function bit.bor(a, b)
    return a | b
end
---返回对a和b进行按位异或运算的结果。
---@param a number 操作数1
---@param b number 操作数2
---@return number 运算结果
function bit.bxor(a, b)
    return a ~ b
end
---返回a按位左移b位后的结果。
---@param a number 操作数1
---@param b number 操作数2
---@return number 运算结果
function bit.lshift(a, b)
    return a << b
end
---返回a按位右移b位后的结果。
---@param a number 操作数1
---@param b number 操作数2
---@return number 运算结果
function bit.rshift(a, b)
    return a >> b
end
---返回a按位非后的结果。
---@param a number 操作数
---@return number 运算结果
function bit.bnot(a)
    return ~a
end
---返回c是不是先导者。
---@param c Card 要判断的卡
---@return boolean 指示是否是先导者
function VgF.VMonsterFilter(c)
    return VgF.IsSequence(c, 5)
end
---返回c是不是后防者。
---@param c Card 要判断的卡
---@return boolean 指示是否是后防者
function VgF.RMonsterFilter(c)
    return c:GetSequence() < 5
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

function VgF.VSummonCondition(e)
    local c = e:GetHandler()
    return VgF.IsSummonTypeV(c)
end

function VgF.RSummonCondition(e)
    return not VgF.VSummonCondition(e)
end

function VgF.IsSummonTypeV(c)
    return c:IsSummonType(SUMMON_TYPE_RIDE) or c:IsSummonType(SUMMON_TYPE_SELFRIDE)
end

function VgF.IsSummonTypeR(c)
    return not VgF.IsSummonTypeV(c)
end
---判断c是否在当前区域的某（几）个编号上
---@param c Card 要判断的卡
---@param ... number 编号
---@return boolean 指示是否在给定编号上
function VgF.IsSequence(c, ...)
    for i, v in ipairs{...} do
        if c:GetSequence() == v then
            return true
        end
    end
    return false
end
function VgF.RuleCardCondtion(e)
    local tp = e:GetHandlerPlayer()
    local g = Duel.GetMatchingGroup(nil, tp, LOCATION_ALL, 0, nil)
    return e:GetHandler() == g:GetFirst()
end
function VgF.RuleTurnCondtion(e)
    local tp = e:GetHandlerPlayer()
    local a = Duel.GetTurnCount(tp)
    local b = Duel.GetTurnCount(1 - tp)
    return a + b == 1
end
---返回函数，该函数与f的结果总是相反的。
---@param f 要操作的函数
---@return function 经过操作的函数
function VgF.Not(f)
    return  function(...)
                return not f(...)
            end
end
---返回c所在列的所有单位。
---@param c Card 指示某一列的卡
---@return Group 这一列的所有单位
function VgF.GetColumnGroup(c)
    local tp = c:GetControler()
    local g = Group.CreateGroup()
     if c:GetSequence() == 0 then
        local sg1 = VgF.GetMatchingGroup(VgF.IsSequence, tp, LOCATION_MZONE, 0, nil, 1)
        local sg2 = VgF.GetMatchingGroup(VgF.IsSequence, tp, 0, LOCATION_MZONE, nil, 3, 4)
        if sg1:GetCount() > 0 then g:Merge(sg1) end
        if sg2:GetCount() > 0 then g:Merge(sg2) end
    end
    if c:GetSequence() == 1 then
        local sg1 = VgF.GetMatchingGroup(VgF.IsSequence, tp, LOCATION_MZONE, 0, nil, 0)
        local sg2 = VgF.GetMatchingGroup(VgF.IsSequence, tp, 0, LOCATION_MZONE, nil, 3, 4)
        if sg1:GetCount() > 0 then g:Merge(sg1) end
        if sg2:GetCount() > 0 then g:Merge(sg2) end
    end
    if c:GetSequence() == 2 then
        local sg1 = VgF.GetMatchingGroup(VgF.IsSequence, tp, LOCATION_MZONE, 0, nil, 5)
        local sg2 = VgF.GetMatchingGroup(VgF.IsSequence, tp, 0, LOCATION_MZONE, nil, 2, 5)
        if sg1:GetCount() > 0 then g:Merge(sg1) end
        if sg2:GetCount() > 0 then g:Merge(sg2) end
    end
    if c:GetSequence() == 3 then
        local sg1 = VgF.GetMatchingGroup(VgF.IsSequence, tp, LOCATION_MZONE, 0, nil, 4)
        local sg2 = VgF.GetMatchingGroup(VgF.IsSequence, tp, 0, LOCATION_MZONE, nil, 0, 1)
        if sg1:GetCount() > 0 then g:Merge(sg1) end
        if sg2:GetCount() > 0 then g:Merge(sg2) end
    end
    if c:GetSequence() == 4 then
        local sg1 = VgF.GetMatchingGroup(VgF.IsSequence, tp, LOCATION_MZONE, 0, nil, 3)
        local sg2 = VgF.GetMatchingGroup(VgF.IsSequence, tp, 0, LOCATION_MZONE, nil, 0, 1)
        if sg1:GetCount() > 0 then g:Merge(sg1) end
        if sg2:GetCount() > 0 then g:Merge(sg2) end
    end
    if c:GetSequence() == 5 then
        local sg1 = VgF.GetMatchingGroup(VgF.IsSequence, tp, LOCATION_MZONE, 0, nil, 2)
        local sg2 = VgF.GetMatchingGroup(VgF.IsSequence, tp, 0, LOCATION_MZONE, nil, 2, 5)
        if sg1:GetCount() > 0 then g:Merge(sg1) end
        if sg2:GetCount() > 0 then g:Merge(sg2) end
    end
    return g
end

function VgF.GetAvailableLocation(tp, zone)
    local z
    if zone then z = zone else z = 0x1f end
    local rg = Duel.GetMatchingGroup(Card.IsPosition, tp, LOCATION_MZONE, 0, nil, POS_FACEDOWN_ATTACK)
    for tc in VgF.Next(rg) do
        local szone = VgF.SequenceToGlobal(tp, tc:GetLocation(), tc:GetSequence())
        z = bit.bxor(z, szone)
    end
    return z
end
---将g（中的每一张卡）Call到单位区。返回Call成功的数量。
---@param g Card|Group 要Call的卡（片组）
---@param sumtype number Call的方式，默认填0
---@param tp number Call的玩家
---@param zone number|nil 指示要Call到的格子。<br>前列的R：17； 后列的R：14； 全部的R：31； V：32
---@param pos number|nil 表示形式
---@return number Call成功的数量
function VgF.Call(g, sumtype, tp, zone, pos)
    if (VgF.GetValueType(g) ~= "Card" and VgF.GetValueType(g) ~= "Group") or (VgF.GetValueType(g) == "Group" and g:GetCount() == 0) then return 0 end
    if VgF.GetValueType(pos) ~= "number" then pos = POS_FACEUP_ATTACK end
    if VgF.GetValueType(zone) == "string" and zone == "NoMonster" then
        return Duel.SpecialSummon(g, sumtype, tp, tp, false, false, pos)
    elseif VgF.GetValueType(zone) == "string" and zone == "FromOverlayToV" then
        local tc = VgF.ReturnCard(g)
        if not VgF.IsCanBeCalled(tc, nil, tp, sumtype, pos, "FromOverlayToV") then return 0 end
        VgF.Sendto(0, tc, tp, POS_FACEUP, REASON_EFFECT)
        local _, code = tc:GetOriginalCode()
        local c = Duel.CreateToken(tp, code)
        return VgF.Call(c, sumtype, tp, 0x20, pos)
    elseif VgF.GetValueType(zone) == "number" and zone > 0 then
        local sc = VgF.ReturnCard(g)
        local z = VgF.GetAvailableLocation(tp, zone)
        local ct = bit.ReturnCount(z)
        local szone
        if ct > 1 then
            z = bit.bnot(z)
            z = bit.bor(z, 0xffffff00)
            Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CallZONE)
            szone = Duel.SelectField(tp, 1, LOCATION_MZONE, 0, z)
        else
            szone = z
        end
        if szone == 0x20 then
            if VgF.GetVMonster(tp) then
                local tc = VgF.GetVMonster(tp)
                local mg = tc:GetOverlayGroup()
                if mg:GetCount() ~= 0 then
                    VgF.Sendto(LOCATION_OVERLAY, mg, sc)
                end
                sc:SetMaterial(Group.FromCards(tc))
                VgF.Sendto(LOCATION_OVERLAY, Group.FromCards(tc), sc)
            end
        elseif VgF.IsExistingMatchingCard(VgD.CallFilter, tp, LOCATION_MZONE, 0, 1, nil, tp, szone) then
            local tc = Duel.GetMatchingGroup(VgD.CallFilter, tp, LOCATION_MZONE, 0, nil, tp, szone):GetFirst()
            if bit.band(sumtype, SUMMON_VALUE_OVERDRESS) > 0 then VgF.Sendto(LOCATION_OVERLAY, Group.FromCards(tc), sc)
            else VgF.Sendto(LOCATION_DROP, tc, REASON_COST)
            end
        end
        return Duel.SpecialSummon(sc, sumtype, tp, tp, false, false, pos, szone)
    else
        local sg
        local z = bit.bnot(VgF.GetAvailableLocation(tp))
        z = bit.bor(z, 0xffffff00)
        if VgF.GetValueType(g) == "Card" then sg = Group.FromCards(g) else sg = Group.Clone(g) end
        for sc in VgF.Next(sg) do
            if sc:IsLocation(LOCATION_EXTRA) then
                local rc = Duel.GetMatchingGroup(VgF.VMonsterFilter, tp, LOCATION_MZONE, 0, nil):GetFirst()
                local mg = rc:GetOverlayGroup()
                if mg:GetCount() ~= 0 then
                    VgF.Sendto(LOCATION_OVERLAY, mg, sc)
                end
                sc:SetMaterial(Group.FromCards(rc))
                VgF.Sendto(LOCATION_OVERLAY, Group.FromCards(rc), sc)
                Duel.SpecialSummonStep(sc, sumtype, tp, tp, false, false, pos, 0x20)
            else
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CallZONE)
                local szone = Duel.SelectField(tp, 1, LOCATION_MZONE, 0, z)
                if VgF.IsExistingMatchingCard(VgD.CallFilter, tp, LOCATION_MZONE, 0, 1, nil, tp, szone) then
                    local tc = Duel.GetMatchingGroup(VgD.CallFilter, tp, LOCATION_MZONE, 0, nil, tp, szone):GetFirst()
                    VgF.Sendto(LOCATION_DROP, tc, REASON_COST)
                end
                Duel.SpecialSummonStep(sc, sumtype, tp, tp, false, false, pos, szone)
                z = bit.bor(z, szone)
            end
        end
        return Duel.SpecialSummonComplete()
    end
end
function VgF.LvCondition(e_or_c)
    local c = VgF.GetValueType(e_or_c) == "Effect" and e_or_c:GetHandler() or e_or_c
    local tp, lv = c:GetControler(), c:GetLevel()
    return VgF.IsExistingMatchingCard(VgF.LvConditionFilter, tp, LOCATION_MZONE, 0, 1, nil, lv)
end
function VgF.LvConditionFilter(c, lv)
    return VgF.VMonsterFilter(c) and c:IsLevelAbove(lv)
end
---以c的名义，使g（中的每一张卡）的攻击力上升val，并在reset时重置。
---@param c Card 要使卡上升攻击力的卡
---@param g Card|Group 要被上升攻击力的卡
---@param val number|string 要上升的攻击力（可以为负）
---@param reset number|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.AtkUp(c, g, val, reset, resetcount)
    if not c or not g then return end
    if not resetcount then resetcount = 1 end
    if not reset then reset = RESET_PHASE + PHASE_END end
    if not val or (VgF.GetValueType(val) == "number" and val == 0) then return end
    if VgF.GetValueType(g) == "Group" and g:GetCount() > 0 then
        local e = {}
        for tc in VgF.Next(g) do
            if tc:IsLocation(LOCATION_MZONE) then
                if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                    val = tc:GetAttack()
                end
                local e1 = Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(val)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
                tc:RegisterEffect(e1)
                table.insert(e, e1)
            end
        end
        return e
    elseif VgF.GetValueType(g) == "Card" then
        local tc = g
        if tc:IsLocation(LOCATION_MZONE) then
            local tc = VgF.ReturnCard(g)
            if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                val = tc:GetAttack()
            end
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
            tc:RegisterEffect(e1)
            return e1
        end
    end
end
---以c的名义，使g（中的每一张卡）的盾值上升val，并在reset时重置。
---@param c Card 要使卡上升盾值的卡
---@param g Card|Group 要被上升盾值的卡
---@param val number|string 要上升的盾值（可以为负）
---@param reset number|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.DefUp(c, g, val, reset, resetcount)
    if not c or not g then return end
    if not reset then reset = RESET_PHASE + PHASE_END end
    if not resetcount then resetcount = 1 end
    if not val or (VgF.GetValueType(val) == "number" and val == 0) then return end
    if VgF.GetValueType(g) == "Group" and g:GetCount() > 0 then
        local e = {}
        for tc in VgF.Next(g) do
            if tc:IsLocation(LOCATION_MZONE) then
                if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                    val = tc:GetDefense()
                end
                local e1 = Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_DEFENSE)
                e1:SetValue(val)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
                tc:RegisterEffect(e1)
                table.insert(e, e1)
            end
        end
        return e
    elseif VgF.GetValueType(g) == "Card" then
        local tc = g
        if tc:IsLocation(LOCATION_MZONE) then
            if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                val = tc:GetDefense()
            end
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_DEFENSE)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
            tc:RegisterEffect(e1)
            return e1
        end
    end
end
---以c的名义，使g（中的每一张卡）的☆上升val，并在reset时重置。
---@param c Card 要使卡上升☆的卡
---@param g Card|Group 要被上升☆的卡
---@param val number|string 要上升的☆（可以为负）
---@param reset number|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.StarUp(c, g, val, reset, resetcount)
    if not c or not g then return end
    if not reset then reset = RESET_PHASE + PHASE_END end
    if not resetcount then resetcount = 1 end
    if not val or (VgF.GetValueType(val) == "number" and val == 0) then return end
    if VgF.GetValueType(g) == "Group" and g:GetCount() > 0 then
        local t1 = {}
        local t2 = {}
        for tc in VgF.Next(g) do
            if tc:IsLocation(LOCATION_MZONE) then
                if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                    val = tc:GetLeftScale()
                end
                local e1 = Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_LSCALE)
                e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
                e1:SetRange(LOCATION_MZONE)
                e1:SetValue(val)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
                tc:RegisterEffect(e1)
                local e2 = e1:Clone()
                e2:SetCode(EFFECT_UPDATE_RSCALE)
                tc:RegisterEffect(e2)
                table.insert(t1, e1)
                table.insert(t2, e2)
            end
        end
        return t1, t2
    elseif VgF.GetValueType(g) == "Card" then
        local tc = VgF.ReturnCard(g)
        if tc:IsLocation(LOCATION_MZONE) then
            if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                val = tc:GetLeftScale()
            end
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LSCALE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
            tc:RegisterEffect(e1)
            local e2 = e1:Clone()
            e2:SetCode(EFFECT_UPDATE_RSCALE)
            tc:RegisterEffect(e2)
            return e1, e2
        end
    end
end
---以c的名义，使g（中的每一张卡）的等级上升val，并在reset时重置。
---@param c Card 要使卡上升等级的卡
---@param g Card|Group 要被上升等级的卡
---@param val number|string 要上升的等级（可以为负,等级最低为0）
---@param reset number|nil 指示重置的时点，默认为“回合结束时”。无论如何，都会在离场时重置。
function VgF.LevelUp(c, g, val, reset, resetcount)
    if not c or not g then return end
    if not reset then reset = RESET_PHASE + PHASE_END end
    if not resetcount then resetcount = 1 end
    if not val or (VgF.GetValueType(val) == "number" and val == 0) then return end
    if VgF.GetValueType(g) == "Group" and g:GetCount() > 0 then
        local e = {}
        for tc in VgF.Next(g) do
            if tc:IsLocation(LOCATION_MZONE) then
                if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                    val = tc:GetLevel()
                end
                local e1 = Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_LEVEL)
                e1:SetValue(val)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
                tc:RegisterEffect(e1)
                table.insert(e, e1)
            end
        end
        return e
    elseif VgF.GetValueType(g) == "Card" then
        local tc = g
        if tc:IsLocation(LOCATION_MZONE) then
            if VgF.GetValueType(val) == "string" and val == "DOUBLE" then
                val = tc:GetLevel()
            end
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LEVEL)
            e1:SetValue(val)
            e1:SetReset(RESET_EVENT + RESETS_STANDARD + reset, resetcount)
            tc:RegisterEffect(e1)
            return e1
        end
    end
end
---判断c是否可以以规则的手段到G区域。
---@param c Card 要判断的卡
---@return boolean 指示c能否去到G区域。
function VgF.IsAbleToGCircle(c)
    if c:IsLocation(LOCATION_HAND) then
        if Duel.IsPlayerAffectedByEffect(c:GetControler(), AFFECT_CODE_DEFENDER_CANNOT_TO_G_CIRCLE) and c:GetBaseDefense() == 0 then return false end
        return c:IsType(TYPE_MONSTER)
    elseif c:IsLocation(LOCATION_MZONE) then
        return c:IsAttribute(SKILL_BLOCK) and VgF.IsSequence(c, 0, 4) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
    end
    return false
end
---用于效果的Operation。它返回一个执行“[计数回充val]”的函数。
---@param val number 计数回充的数量
---@return function 效果的Operation函数
function VgF.DamageFill(val)
    return function (e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
        local g = Duel.SelectMatchingCard(tp, Card.IsFacedown, tp, LOCATION_DAMAGE, 0, val, val, nil)
        Duel.ChangePosition(g, POS_FACEUP_ATTACK)
        return Duel.GetOperatedGroup():GetCount()
    end
end

---用于效果的Cost。它返回一个执行“【费用】[将这个单位放置到灵魂里]”的函数。
function VgF.ToOverlayCost(e,tp,eg,ep,ev,re,r,rp,chk)
    return function ()
        local c = e:GetHandler()
        if chk == 0 then return c:IsRelateToEffect(e) end
        VgF.Sendto(LOCATION_OVERLAY,c)
    end
end

---用于效果的Cost。它返回一个执行“【费用】[将手牌中的val张卡舍弃]”的函数。
function VgF.CostAnd(...)
    local funcs = {...}
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        for _, func in ipairs(funcs) do
            if chk == 0 then
                chk = chk and func(e, tp, eg, ep, ev, re, r, rp, chk)
            else
                func(e, tp, eg, ep, ev, re, r, rp, chk)
            end
        end
        return chk
    end
end

function VgF.Stand(c)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        if VgF.GetValueType(c) ~= "Card" then c = e:GetHandler() end
        if chk == 0 then return c:IsCanChangePosition() and c:IsPosition(POS_FACEUP_DEFENCE) and (c ~= e:GetHandler() or c:IsRelateToEffect(e)) end
        Duel.ChangePosition(c, POS_FACEUP_ATTACK)
    end
end

function VgF.Rest(c)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        if VgF.GetValueType(c) ~= "Card" then c = e:GetHandler() end
        if chk == 0 then return c:IsCanChangePosition() and c:IsPosition(POS_FACEUP_ATTACK) and (c ~= e:GetHandler() or c:IsRelateToEffect(e)) end
        Duel.ChangePosition(c, POS_FACEUP_DEFENCE)
    end
end

---用于效果的Cost。它返回一个执行“【费用】[将手牌中的val张卡舍弃]”的函数。
---@param val number 要舍弃的卡的数量
---@return function 效果的Cost函数
function VgF.DisCardCost(val)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        if VgF.GetValueType(val) ~= "number" then return 0 end
        local c = e:GetHandler()
        local m = c:GetOriginalCode()
        if chk == 0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddAlchemagicFrom(c, m, "LOCATION_HAND")
                VgF.AddAlchemagicTo(c, m, "LOCATION_DROP")
                VgF.AddAlchemagicFilter(c, m, nil)
                VgF.AddAlchemagicCountMin(c, m, val)
                VgF.AddAlchemagicCountMax(c, m, val)
            end
            return VgF.IsExistingMatchingCard(nil, tp, LOCATION_HAND, 0, val, nil)
        end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
        local g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_HAND, 0, val, val, nil)
        return VgF.Sendto(LOCATION_DROP, g, REASON_COST + REASON_DISCARD)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[能量爆发val]”的函数。
---@param val number 能量爆发的数量
---@return function 效果的Cost函数
function VgF.EnergyCost(val)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        if VgF.GetValueType(val) ~= "number" then return 0 end
        local c = e:GetHandler()
        local m = c:GetOriginalCode()
        if chk == 0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddAlchemagicFrom(c, m, "LOCATION_EMBLEM")
                VgF.AddAlchemagicTo(c, m, "0")
                VgF.AddAlchemagicFilter(c, m, function(tc) tc:IsCode(CARD_ENERGY) end)
                VgF.AddAlchemagicCountMin(c, m, val)
                VgF.AddAlchemagicCountMax(c, m, val)
            end
            return VgF.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_EMBLEM, 0, val, nil, CARD_ENERGY)
        end
        local sg = Duel.GetMatchingGroup(Card.IsCode, tp, LOCATION_EMBLEM, 0, nil, CARD_ENERGY)
        local g = VgF.GetCardsFromGroup(sg, val)
        return VgF.Sendto(0, g, tp, POS_FACEUP, REASON_COST)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[灵魂爆发val]”的函数。
---@param val number 灵魂爆发的数量
---@return function 效果的Cost函数
function VgF.OverlayCost(val)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        if VgF.GetValueType(val) ~= "number" then return 0 end
        local c = e:GetHandler()
        local m = c:GetOriginalCode()
        if chk == 0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddAlchemagicFrom(c, m, "LOCATION_OVERLAY")
                VgF.AddAlchemagicTo(c, m, "LOCATION_DROP")
                VgF.AddAlchemagicFilter(c, m, nil)
                VgF.AddAlchemagicCountMin(c, m, val)
                VgF.AddAlchemagicCountMax(c, m, val)
            end
            return Duel.GetMatchingGroup(VgF.VMonsterFilter, tp, LOCATION_MZONE, 0, nil, nil):GetFirst():GetOverlayCount() >= val
        end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVEXYZ)
        local g = Duel.GetMatchingGroup(VgF.VMonsterFilter, tp, LOCATION_MZONE, 0, nil):GetFirst():GetOverlayGroup():Select(tp, nil, val, val, nil)
        return VgF.Sendto(LOCATION_DROP, g, REASON_COST)
    end
end
---用于效果的Cost或Operation。它返回一个执行“【费用】[灵魂填充val]”的函数。
---@param val number 灵魂填充的数量
---@return function 效果的Cost或Operation函数
function VgF.OverlayFill(val)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        if VgF.GetValueType(val) ~= "number" then return 0 end
        local c = e:GetHandler()
        local m = c:GetOriginalCode()
        if chk == 0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddAlchemagicFrom(c, m, "LOCATION_DECK")
                VgF.AddAlchemagicTo(c, m, "LOCATION_OVERLAY")
                VgF.AddAlchemagicFilter(c, m, nil)
                VgF.AddAlchemagicCountMin(c, m, val)
                VgF.AddAlchemagicCountMax(c, m, val)
            end
            return Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) >= val
        end
        local rc = Duel.GetMatchingGroup(VgF.VMonsterFilter, tp, LOCATION_MZONE, 0, nil):GetFirst()
        local g = Duel.GetDecktopGroup(tp, val)
        Duel.DisableShuffleCheck()
        Duel.RaiseEvent(g, EVENT_CUSTOM + EVENT_OVERLAY_FILL, e, 0, tp, tp, val)
        return VgF.Sendto(LOCATION_OVERLAY, g, rc)
    end
end
---用于效果的Cost。它返回一个执行“【费用】[计数爆发val]”的函数。
---@param val number 计数爆发的数量
---@return function 效果的Cost函数
function VgF.DamageCost(val)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        if VgF.GetValueType(val) ~= "number" then return 0 end
        local c = e:GetHandler()
        local m = c:GetOriginalCode()
        if chk == 0 then
            if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
                VgF.AddAlchemagicFrom(c, m, "LOCATION_DAMAGE")
                VgF.AddAlchemagicTo(c, m, "POSCHANGE")
                VgF.AddAlchemagicFilter(c, m, Card.IsFaceup)
                VgF.AddAlchemagicCountMin(c, m, val)
                VgF.AddAlchemagicCountMax(c, m, val)
            end
            return VgF.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_DAMAGE, 0, val, nil)
        end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DAMAGE)
        local g = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_DAMAGE, 0, val, val, nil)
        Duel.ChangePosition(g, POS_FACEDOWN_ATTACK)
        return Duel.GetOperatedGroup():GetCount()
    end
end
---用于效果的Cost。它返回一个执行“【费用】[将xxx退场]”的函数。
---@param card_code_func Card|integer|function|nil 退场的卡的条件
---@param max number|nil 退场的卡的最大数量
---@param min number|nil 退场的卡的最小数量
---@param except Card|nil 
---@param ... any 
---@return function 效果的Cost函数
function VgF.LeaveFieldCost(card_code_func, max, min, except, ...)
    if not card_code_func then
        return VgF.LeaveFieldCostGroup()
    elseif VgF.GetValueType(card_code_func) == "Card" then
        return VgF.LeaveFieldCostGroup(Group.FromCards(card_code_func))
    elseif VgF.GetValueType(card_code_func) == "Group" then
        return VgF.LeaveFieldCostGroup(card_code_func)
    end
    local ex_params = {...}
    min, max = min or 1, max or 1
    if min > max then min = max end
    local leave_filter = VgF.True
    if type(card_code_func) == "function" then
        leave_filter = card_code_func
    elseif type(card_code_func) == "number" then
        leave_filter = function(c) return c:IsCode(card_code_func) end
    end
    return function(e, tp, eg, ep, ev, re, r, rp, chk)
        leave_filter = function(c) return leave_filter(c, table.unpack(ex_params)) and c:IsAbleToGraveAsCost() end
        local g = VgF.GetMatchingGroup(leave_filter, tp, LOCATION_MZONE, 0, except)
        if chk == 0 then return g:CheckSubGroup(VgF.LeaveFieldCostFilter, 1, max, min, e, tp) end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_LEAVEFIELD)
        g = g:SelectSubGroup(tp, VgF.LeaveFieldCostFilter, false, 1, max, min, e, tp)
        VgF.Sendto(LOCATION_DROP, g, REASON_COST)
    end
end
function VgF.LeaveFieldCostFilter(g, min, e, tp)
    local fg = g:Filter(Card.IsHasEffect, nil, EFFECT_EXTRA_LEAVEFIELD_COUNT)
    if #fg == 0 then return #g >= min end
    local val_total = 0
    for c in VgF.Next(fg) do
        for _, te in pairs({c:IsHasEffect(EFFECT_EXTRA_LEAVEFIELD_COUNT)}) do
            local val = te:GetValue() -- number or function
            if not (val or type(val) == "number" or type(val) == "function") then 
                Debug.Message("EFFECT_EXTRA_LEAVEFIELD_COUNT Value should be number or function")
            end
            if type(val) == "function" then
                val = val(g, e, tp)
            end
            val_total = val_total + val
        end
    end
    min = min > val_total and (min - val_total) or 1
    return #g >= min
end
---将 自己/g 退场
function VgF.LeaveFieldCostGroup(g)
    return function (e, tp, eg, ep, ev, re, r, rp, chk)
        g = g or Group.FromCards(e:GetHandler())
        local fg = g:Filter(function(c) return c:IsAbleToGraveAsCost() and (c ~= e:GetHandler() or c:IsRelateToEffect(e)) end, nil)
        if chk == 0 then return #g == #fg end
        VgF.Sendto(LOCATION_DROP, g, REASON_COST)
    end
end
function VgF.IsCanBeCalled(c, e, tp, sumtype, pos, zone)
    local z = 0
    if VgF.GetValueType(zone) == "number" then z = VgF.GetAvailableLocation(tp, zone)
    elseif VgF.GetValueType(zone) == "string" and zone == "NoMonster" then z = Duel.GetLocationCount(tp, LOCATION_MZONE) zone = 0xff
    else z = VgF.GetAvailableLocation(tp) zone = 0xff end
    if VgF.GetValueType(sumtype) ~= "number" then sumtype = 0 end
    if VgF.GetValueType(pos) ~= "number" then pos = POS_FACEUP_ATTACK end
    if VgF.GetValueType(zone) == "string" and zone == "FromOverlayToV" then
        local _, code = c:GetOriginalCode()
        return Duel.IsPlayerCanSpecialSummonMonster(tp, code, nil, TYPE_MONSTER + TYPE_NORMAL, c:GetBaseAttack(), c:GetBaseDefense(), c:GetOriginalLevel(), c:GetOriginalRace(), c:GetOriginalAttribute())
    end
    return z > 0 and c:IsCanBeSpecialSummoned(e, sumtype, tp, false, false, pos, tp, zone)
end
---用于效果的Operation。执行“从loc_from中选取最少int_min，最多int_max张满足f的卡，送去loc_to。”。
---@param loc_to number 要送去的区域。不填则返回0。
---@param loc_from number 要选取的区域。不填则返回0。
---@param f function|nil 卡片过滤的条件
function VgF.CardsFromTo(reason ,loc_to, loc_from, f, int_max, int_min, ...)
    local ext_params = {...}
    return function (e, tp, eg, ep, ev, re, r, rp)
        if not loc_to or not loc_from then return 0 end
        if loc_from == LOCATION_R_CIRCLE then loc_from = LOCATION_MZONE end
        if VgF.GetValueType(int_max) ~= "number" then int_max = 1 end
        if VgF.GetValueType(int_min) ~= "number" then int_min = int_max end
        if loc_to == LOCATION_HAND then
            local g = VgF.SelectMatchingCard(HINTMSG_ATOHAND, e, tp, function (c)
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                return VgF.Sendto(loc_to, g, nil, reason)
            end
        elseif loc_to == LOCATION_V_CIRCLE then
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, function (c)
                if not VgF.IsCanBeCalled(c, e, tp) then return false end
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                if loc_from == LOCATION_OVERLAY then return VgF.Sendto(loc_to, g, 0, tp, "FromOverlayToV")
                else return VgF.Sendto(loc_to, g, 0, tp, 0x20)
                end
            end
        elseif loc_to == LOCATION_MZONE then
            if VgF.GetAvailableLocation(tp) < int_min then return 0 end
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, function (c)
                if not VgF.IsCanBeCalled(c, e, tp) then return false end
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                return VgF.Sendto(loc_to, g, 0, tp)
            end
        elseif loc_to == LOCATION_DROP then
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, function (c)
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                return VgF.Sendto(loc_to, g, reason)
            end
        elseif loc_to == LOCATION_REMOVED then
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, function (c)
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                return VgF.Sendto(loc_to, g, POS_FACEUP, reason)
            end
        elseif loc_to == LOCATION_EXILE then
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, function (c)
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                return VgF.Sendto(loc_to, g, reason)
            end
        elseif loc_to == LOCATION_OVERLAY then
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, function (c)
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                local rc = VgF.GetVMonster(tp)
                return VgF.Sendto(loc_to, g, rc)
            end
        elseif bit.band(loc_to, 0xf800) > 0 then
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, function (c)
                return VgF.GetValueType(f) ~= "function" or f(c, table.unpack(ext_params))
            end, tp, loc_from, 0, int_min, int_max, nil)
            if g:GetCount() > 0 then
                return VgF.Sendto(loc_to, g, tp, POS_FACEUP_ATTACK, reason)
            end
        end
        return 0
    end
end

function Group.ForEach(g, f, ...)
    local ext_params = {...}
    if #g == 0 then return end
    for c in VgF.Next(g) do
        f(c, table.unpack(ext_params))
    end
end

function Group.CheckSubGroup(g, f, min, max, ...)
    min = min or 1
    max = max or #g
    if min > max then return false end
    local ext_params = {...}
    -- selected group
    local sg = Group.CreateGroup()
    -- be select group
    local bg = g:Clone()
    for c in VgF.Next(g) do
        if VgF.CheckGroupRecursiveCapture(c, sg, bg, f, min, max, ext_params) then return true end
        bg:RemoveCard(c)
    end
    return false
end
function VgF.CheckGroupRecursiveCapture(c, sg, bg, f, min, max, ext_params)
    sg = sg + c
    if VgF.G_Add_Check and not VgF.G_Add_Check(sg, c, bg) then
        sg = sg - c
        return false
    end
    local res = #sg >= min and #sg <= max and (not f or f(sg, table.unpack(ext_params)))
    if not res and #sg < max then
        res = bg:IsExists(VgF.CheckGroupRecursiveCapture, 1, sg, sg, bg, f, min, max, ext_params)
    end
    sg = sg - c
    return res
end
function Group.SelectSubGroup(g, tp, f, cancelable, min, max, ...)
    VgF.SubGroupCaptured = Group.CreateGroup()
    min = min or 1
    max = max or #g
    local ext_params = {...}
    local sg = Group.CreateGroup()
    local fg = Duel.GrabSelectedCard()
    if #fg > max or min > max or #(g + fg) < min then return nil end
    for tc in VgF.Next(fg) do
        fg:SelectUnselect(sg, tp, false, false, min, max)
    end
    sg:Merge(fg)
    local finish = (#sg >= min and #sg <= max and f(sg, ...))
    while #sg < max do
        local cg = Group.CreateGroup()
        local eg = g:Clone()
        for c in VgF.Next(g - sg) do
            if not cg:IsContains(c) then
                if VgF.CheckGroupRecursiveCapture(c, sg, eg, f, min, max, ext_params) then
                    cg:Merge(VgF.SubGroupCaptured)
                else
                    eg:RemoveCard(c)
                end
            end
        end
        cg:Sub(sg)
        finish = (#sg >= min and #sg <= max and f(sg, ...))
        if #cg == 0 then break end
        local cancel = not finish and cancelable
        local tc = cg:SelectUnselect(sg, tp, finish, cancel, min, max)
        if not tc then break end
        if not fg:IsContains(tc) then
            if not sg:IsContains(tc) then
                sg:AddCard(tc)
                if #sg == max then finish = true end
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
function Group.SelectDoubleSubGroup(g, p, f1, int_min1, int_max1, f2, int_min2, int_max2, except_g, ...)
    if VgF.GetValueType(f1) ~= "function" then f1 = VgF.True end
    if VgF.GetValueType(f2) ~= "function" then f2 = VgF.True end
    local result = Group.CreateGroup()
    local g1 = g:Filter(f1, except_g, ...)
    local g2 = g:Filter(f2, except_g, ...)
    local g3 = Group.__band(g1, g2)
    if g:GetCount() < int_min1 + int_min2 or g1:GetCount() < int_min1 or g2:GetCount() < int_min2 then return result end
    if g1:GetCount() < int_max1 then int_max1 = g1:GetCount() end
    if g2:GetCount() < int_max2 then int_max2 = g2:GetCount() end
    if g3:GetCount() == g2:GetCount() and g3:GetCount() == g1:GetCount() then
        local min = int_min1 + int_min2
        local max = int_max1 + int_max2
        return g3:SelectSubGroup(p, vgf.True, false, min, max)
    end
    local result1 = Group.CreateGroup()
    local result2 = Group.CreateGroup()
    while result1:GetCount() < int_max1 do
        local sg = Group.__sub(g1, result1)
        local check_group = Group.__sub(g2, result1)
        for tc in VgF.Next(Group.__sub(g1, result1)) do
            if g3:IsContains(tc) and not check_group:IsExists(VgF.True, int_min2, tc) then sg:RemoveCard(tc) end
        end
        local btok = false
        if result1:GetCount() >= int_min1 then btok = true end
        local tc = sg:SelectUnselect(result1, p, btok, false, int_min1, int_max1)
        if not tc then break
        elseif result1:IsContains(tc) then result1:RemoveCard(tc)
        else result1:AddCard(tc) end
    end
    g2:Sub(result1)
    while result2:GetCount() < int_max2 do
        local sg = Group.__sub(g2, result2)
        local btok = false
        if result2:GetCount() >= int_min2 then btok = true end
        local tc = sg:SelectUnselect(result2, p, btok, false, int_min2, int_max2)
        if not tc then break
        elseif result2:IsContains(tc) and not result1:IsContains(tc) then result2:RemoveCard(tc)
        else result2:AddCard(tc) end
    end
    result = Group.__add(result1, result2)
    return result
end
---返回p场上的先导者。
---@param p number 要获取先导者的玩家。不合法则返回nil。
---@return Card|nil p场上的先导者
function VgF.GetVMonster(p)
    if p ~= 0 and p ~= 1 then return end
    return Duel.GetMatchingGroup(VgF.VMonsterFilter, p, LOCATION_MZONE, 0, nil):GetFirst()
end
---判断c是否在前列。
---@param c Card 要判断的卡
---@return boolean 指示c是否是前列的单位
function VgF.FrontFilter(c)
    return vgf.IsSequence(c, 0, 4, 5) and c:IsLocation(LOCATION_MZONE)
end
---判断c是否在后列。
---@param c Card 要判断的卡
---@return boolean 指示c是否是后列的单位
function VgF.BackFilter(c)
    return vgf.IsSequence(c, 1, 2, 3) and c:IsLocation(LOCATION_MZONE)
end
function VgF.PrisonFilter(c, ct)
    return c:GetSequence() == ct - 1
end
---收容g（中的每一张卡）到p的监狱。没有监狱时，不操作。
---@param g Card|Group
---@param p number
function VgF.SendtoPrison(g, p)
    if not VgF.CheckPrison(p) or not g then return end
    local og = Duel.GetFieldGroup(p, LOCATION_ORDER, 0)
    local oc = og:Filter(VgF.PrisonFilter, nil, og:GetCount()):GetFirst()
    if VgF.GetValueType(g) == "Card" then
        VgF.Sendto(LOCATION_ORDER, g, p, POS_FACEUP_ATTACK, REASON_EFFECT)
        g:RegisterFlagEffect(FLAG_IMPRISON, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, VgF.Stringid(10105015, 0))
    elseif VgF.GetValueType(g) == "Group" then
        for tc in VgF.Next(g) do
            VgF.Sendto(LOCATION_ORDER, tc, p, POS_FACEUP_ATTACK, REASON_EFFECT)
            tc:RegisterFlagEffect(FLAG_IMPRISON, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, VgF.Stringid(10105015, 0))
        end
    end
    Duel.MoveSequence(oc, og:GetCount() - 1)
end
--[[
function VgF.PrisonFilter(c, tp)
    return c:IsSetCard(0x3040) and not VgF.IsExistingMatchingCard(function (tc)
        return tc:GetSequence() < c:GetSequence()
    end, tp, LOCATION_ORDER, 0, 1, c)
end
---收容g（中的每一张卡）到p的监狱。没有监狱时，不操作。
---@param g Card|Group
---@param p number
function VgF.SendtoPrison(g, p)
    if not VgF.CheckPrison(p) or not g then return end
    local og = Duel.GetFieldGroup(p, LOCATION_ORDER, 0)
    local oc = og:Filter(VgF.PrisonFilter, nil, p):GetFirst()
    if VgF.GetValueType(g) == "Card" then
        Duel.Sendto(g, p, LOCATION_ORDER, POS_FACEUP_ATTACK, REASON_EFFECT, 1)
        g:RegisterFlagEffect(FLAG_IMPRISON, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, VgF.Stringid(10105015, 0))
    elseif VgF.GetValueType(g) == "Group" then
        for tc in VgF.Next(g) do
            Duel.Sendto(tc, p, LOCATION_ORDER, POS_FACEUP_ATTACK, REASON_EFFECT, 1)
            tc:RegisterFlagEffect(FLAG_IMPRISON, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, VgF.Stringid(10105015, 0))
        end
    end
end]]
---检测p场上有没有监狱。
---@param p number
---@return boolean 指示p场上有没有监狱。
function VgF.CheckPrison(p)
    local og = Duel.GetFieldGroup(p, LOCATION_ORDER, 0)
    return og:IsExists(Card.IsSetCard, 1, nil, 0x3040)
end
--重置Effect
function VgF.EffectReset(c, e, code, con)
    if VgF.GetValueType(e) == "Effect" then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(code)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetRange(LOCATION_ALL)
        e1:SetLabelObject(e)
        if VgF.GetValueType(con) == "function" then e1:SetCondition(con) end
        e1:SetOperation(VgF.EffectResetOperation)
        c:RegisterEffect(e1)
    elseif VgF.GetValueType(e) == "table" then
        for i, v in ipairs(e) do
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(code)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_ALL)
            e1:SetLabelObject(v)
            if VgF.GetValueType(con) == "function" then e1:SetCondition(con) end
            e1:SetOperation(VgF.EffectResetOperation)
            c:RegisterEffect(e1)
        end
    end
end
function VgF.EffectResetOperation(e, tp, eg, ep, ev, re, r, rp)
    local e1 = e:GetLabelObject()
    if VgF.GetValueType(e1) == "Effect" then e1:Reset() end
    e:Reset()
end
function VgF.IsExistingMatchingCard(f, tp, loc_self, loc_op, int, except_g, ...)
    return VgF.GetMatchingGroupCount(f, tp, loc_self, loc_op, except_g, ...) >= int
end
function VgF.SelectMatchingCard(hintmsg, e, select_tp, f, tp, loc_self, loc_op, int_min, int_max, except_g, ...)
    local a = false
    if ((select_tp == tp and bit.band(loc_self, LOCATION_DECK) > 0) or (select_tp ~= tp and bit.band(loc_op, LOCATION_DECK) > 0)) and Duel.SelectYesNo(select_tp, VgF.Stringid(VgID, 13)) then
        local g = Duel.GetFieldGroup(select_tp, LOCATION_DECK, 0)
        Duel.DisableShuffleCheck()
        Duel.ConfirmCards(select_tp, g)
        a = true
    end
    local g = Group.CreateGroup()
    local loc_self_f = VgF.True
    local loc_op_f = VgF.True
    if bit.band(loc_self, LOCATION_V_CIRCLE) > 0 and bit.band(loc_self, LOCATION_R_CIRCLE) > 0 then
        loc_self = loc_self - LOCATION_V_CIRCLE - LOCATION_R_CIRCLE
        if bit.band(loc_self, LOCATION_MZONE) == 0 then
            loc_self = loc_self + LOCATION_MZONE
        end
    elseif bit.band(loc_self, LOCATION_V_CIRCLE) > 0 then
        loc_self = loc_self - LOCATION_V_CIRCLE
        loc_self_f = VgF.VMonsterFilter
        if bit.band(loc_self, LOCATION_MZONE) == 0 then
            loc_self = loc_self + LOCATION_MZONE
        end
    elseif bit.band(loc_self, LOCATION_R_CIRCLE) > 0 then
        loc_self = loc_self - LOCATION_R_CIRCLE
        loc_self_f = VgF.RMonsterFilter
        if bit.band(loc_self, LOCATION_MZONE) == 0 then
            loc_self = loc_self + LOCATION_MZONE
        end
    end
    if bit.band(loc_op, LOCATION_V_CIRCLE) > 0 and bit.band(loc_op, LOCATION_R_CIRCLE) > 0 then
        loc_op = loc_op - LOCATION_V_CIRCLE - LOCATION_R_CIRCLE
        if bit.band(loc_op, LOCATION_MZONE) == 0 then
            loc_op = loc_op + LOCATION_MZONE
        end
    elseif bit.band(loc_op, LOCATION_V_CIRCLE) > 0 then
        loc_op = loc_op - LOCATION_V_CIRCLE
        loc_op_f = VgF.VMonsterFilter
        if bit.band(loc_op, LOCATION_MZONE) == 0 then
            loc_op = loc_op + LOCATION_MZONE
        end
    elseif bit.band(loc_op, LOCATION_R_CIRCLE) > 0 then
        loc_op = loc_op - LOCATION_R_CIRCLE
        loc_op_f = VgF.RMonsterFilter
        if bit.band(loc_op, LOCATION_MZONE) == 0 then
            loc_op = loc_op + LOCATION_MZONE
        end
    end
    if bit.band(loc_self, LOCATION_MZONE) > 0 then
        local g1 = Duel.GetMatchingGroup(function (c)
            return c:IsCanBeEffectTarget(e) and c:IsFaceup() and loc_self_f(c)
        end, tp, LOCATION_MZONE, 0, nil)
        loc_self = loc_self - LOCATION_MZONE
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if bit.band(loc_op, LOCATION_MZONE) > 0 then
        local g1 = Duel.GetMatchingGroup(function (c)
            return c:IsCanBeEffectTarget(e) and c:IsFaceup() and loc_op_f(c)
        end, tp, 0, LOCATION_MZONE, nil)
        loc_op = loc_op - LOCATION_MZONE
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if bit.band(loc_self, LOCATION_OVERLAY) > 0 then
        local g1 = VgF.GetVMonster(tp):GetOverlayGroup()
        loc_self = loc_self - LOCATION_OVERLAY
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if bit.band(loc_op, LOCATION_OVERLAY) > 0 then
        local g1 = VgF.GetVMonster(1 - tp):GetOverlayGroup()
        loc_op = loc_op - LOCATION_OVERLAY
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if loc_self > 0 or loc_op > 0 then
        local g1 = Duel.GetMatchingGroup(nil, tp, loc_self, loc_op, nil)
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if g:GetCount() > 0 then
        Duel.Hint(HINT_SELECTMSG, select_tp, hintmsg)
        if VgF.GetValueType(f) == "function" then
            g = g:FilterSelect(select_tp, f, int_min, int_max, except_g, ...)
        else
            g = g:Select(select_tp, int_min, int_max, except_g)
        end
    end
    local cg = g:Filter(function (tc)
        return not tc:IsLocation(LOCATION_DECK + LOCATION_HAND + LOCATION_EXTRA)
    end, nil)
    if cg:GetCount() > 0 then
        Duel.HintSelection(cg)
        Duel.SetTargetCard(cg)
    end
    if a then Duel.ShuffleDeck(select_tp) end
    return g
end
function VgF.GetMatchingGroupCount(f, tp, loc_self, loc_op, except_g, ...)
    return VgF.GetMatchingGroup(f, tp, loc_self, loc_op, except_g, ...):GetCount()
end
function VgF.GetMatchingGroup(f, tp, loc_self, loc_op, except_g, ...)
    local loc_self_f = VgF.True
    local loc_op_f = VgF.True
    if bit.band(loc_self, LOCATION_V_CIRCLE) > 0 and bit.band(loc_self, LOCATION_R_CIRCLE) > 0 then
        loc_self = loc_self - LOCATION_V_CIRCLE - LOCATION_R_CIRCLE
        if bit.band(loc_self, LOCATION_MZONE) == 0 then
            loc_self = loc_self + LOCATION_MZONE
        end
    elseif bit.band(loc_self, LOCATION_V_CIRCLE) > 0 then
        loc_self = loc_self - LOCATION_V_CIRCLE
        loc_self_f = VgF.VMonsterFilter
        if bit.band(loc_self, LOCATION_MZONE) == 0 then
            loc_self = loc_self + LOCATION_MZONE
        end
    elseif bit.band(loc_self, LOCATION_R_CIRCLE) > 0 then
        loc_self = loc_self - LOCATION_R_CIRCLE
        loc_self_f = VgF.RMonsterFilter
        if bit.band(loc_self, LOCATION_MZONE) == 0 then
            loc_self = loc_self + LOCATION_MZONE
        end
    end
    if bit.band(loc_op, LOCATION_V_CIRCLE) > 0 and bit.band(loc_op, LOCATION_R_CIRCLE) > 0 then
        loc_op = loc_op - LOCATION_V_CIRCLE - LOCATION_R_CIRCLE
        if bit.band(loc_op, LOCATION_MZONE) == 0 then
            loc_op = loc_op + LOCATION_MZONE
        end
    elseif bit.band(loc_op, LOCATION_V_CIRCLE) > 0 then
        loc_op = loc_op - LOCATION_V_CIRCLE
        loc_op_f = VgF.VMonsterFilter
        if bit.band(loc_op, LOCATION_MZONE) == 0 then
            loc_op = loc_op + LOCATION_MZONE
        end
    elseif bit.band(loc_op, LOCATION_R_CIRCLE) > 0 then
        loc_op = loc_op - LOCATION_R_CIRCLE
        loc_op_f = VgF.RMonsterFilter
        if bit.band(loc_op, LOCATION_MZONE) == 0 then
            loc_op = loc_op + LOCATION_MZONE
        end
    end
    local g = Group.CreateGroup()
    if bit.band(loc_self, LOCATION_MZONE) > 0 then
        local g1 = Duel.GetMatchingGroup(function (c)
            return c:IsFaceup() and loc_self_f(c)
        end, tp, LOCATION_MZONE, 0, nil)
        loc_self = loc_self - LOCATION_MZONE
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if bit.band(loc_op, LOCATION_MZONE) > 0 then
        local g1 = Duel.GetMatchingGroup(function (c)
            return c:IsFaceup() and loc_op_f(c)
        end, tp, 0, LOCATION_MZONE, nil)
        loc_op = loc_op - LOCATION_MZONE
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if bit.band(loc_self, LOCATION_OVERLAY) > 0 then
        local g1 = VgF.GetVMonster(tp):GetOverlayGroup()
        loc_self = loc_self - LOCATION_OVERLAY
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if bit.band(loc_op, LOCATION_OVERLAY) > 0 then
        local g1 = VgF.GetVMonster(1 - tp):GetOverlayGroup()
        loc_op = loc_op - LOCATION_OVERLAY
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if loc_self > 0 or loc_op > 0 then
        local g1 = Duel.GetMatchingGroup(nil, tp, loc_self, loc_op, nil)
        if g1:GetCount() > 0 then g:Merge(g1) end
    end
    if g:GetCount() > 0 and VgF.GetValueType(f) == "function" then
        g = g:Filter(f, except_g, ...)
    end
    return g
end
---用于效果的Operation。执行“把卡sg，送去loc,第三个参数开始为额外参数，内容与原函数相同。”。
---@param loc number 要送去的区域。不填则返回0。
---@param sg Card|Group 要操作的卡|卡片组。
---@return number 具体操作的卡的数量
function VgF.Sendto(loc, sg, ...)
    local ext_params = {...}
    local function AddOverlayGroup(g, o_loc)
        for tc in VgF.Next(g) do
            if tc:GetOverlayCount() > 0 then
                local mg = tc:GetOverlayGroup()
                VgF.Sendto(o_loc, mg, table.unpack(ext_params))
            end
        end
    end
    local g = nil
    if VgF.GetValueType(sg) == "Group" and sg:GetCount() > 0 then
        g = Group.Clone(sg)
    elseif VgF.GetValueType(sg) == "Card" then
        g = Group.FromCards(sg)
    else return 0
    end
    if loc == LOCATION_DROP then
        AddOverlayGroup(g, LOCATION_DROP)
        local return_val = 0
        if g:IsExists(Card.IsLocation, 1, nil, LOCATION_HAND) then
            local g2 = g:Filter(Card.IsLocation, nil, LOCATION_HAND)
            local reason = ext_params[1]
            if VgF.GetValueType(reason) ~= "number" then reason = 0 end
            if bit.band(reason, REASON_DISCARD) == 0 then reason = reason + REASON_DISCARD end
            return_val = return_val + Duel.SendtoGrave(g2, reason)
            g:Sub(g2)
        end
        return_val = return_val + Duel.SendtoGrave(g, ...)
        return return_val
    elseif loc == LOCATION_DECK then
        return Duel.SendtoDeck(g, ...)
    elseif loc == LOCATION_HAND then
        local ct = Duel.SendtoHand(g, ...)
        local cg = Duel.GetOperatedGroup()
        for tp = 0, 1 do
            local confirm_group = cg:Filter(Card.IsControler, nil, tp)
            if confirm_group:GetCount() > 0 then
                Duel.ConfirmCards(1 - tp, confirm_group)
                Duel.ShuffleHand(tp)
            end
        end
        return ct
    elseif loc == LOCATION_REMOVED then
        AddOverlayGroup(g, LOCATION_REMOVED)
        return Duel.Remove(g, ...)
    elseif loc == LOCATION_EXILE then
        AddOverlayGroup(g, LOCATION_EXILE)
        return Duel.Exile(g, ...)
    elseif loc == LOCATION_OVERLAY then
        AddOverlayGroup(g, LOCATION_OVERLAY)
        local ct = 0
        if #ext_params > 0 then
            local c = ext_params[1]
            Duel.Overlay(c, g)
            ct = Duel.GetOperatedGroup():GetCount()
        else
            for tp = 0, 1 do
                local c = VgF.GetVMonster(tp)
                local og = g:Filter(Card.IsControler, nil, tp)
                if og:GetCount() > 0 then
                    Duel.Overlay(c, og)
                    ct = ct + Duel.GetOperatedGroup():GetCount()
                end
            end
        end
        return ct
    elseif loc == LOCATION_TRIGGER then
        local ct = 0
        for tc in VgF.Next(g) do
            local tp = tc:GetControler()
            if Duel.MoveToField(tc, tp, tp, loc, POS_FACEUP, true) then ct = ct + 1 end
        end
        return ct
    elseif loc == LOCATION_MZONE then
        return VgF.Call(g, table.unpack(ext_params))
    elseif bit.band(loc, 0xf800) > 0 or loc == 0 then
        AddOverlayGroup(g, loc)
        Duel.Sendto(g, ext_params[1], loc, ext_params[2], ext_params[3], ext_params[4])
        local return_group = Duel.GetOperatedGroup()
        return return_group:GetCount()
    end
    return 0
end

-- 白翼能力在你的封锁区中的卡只有奇数的等级的场合有效
function VgF.WhiteWing(e)
    local tp = e:GetHandlerPlayer()
    local a = vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2 == 1
    end, tp, LOCATION_REMOVED, 0, 1, nil)
    local b = vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2 == 0
    end, tp, LOCATION_REMOVED, 0, 1, nil)
    return (a and not b) or Duel.IsPlayerAffectedByEffect(tp, AFFECT_CODE_BOTH_WING)
end
-- 黑翼能力在你的封锁区中的卡只有偶数的等级的场合有效
function VgF.DarkWing(e)
    local tp = e:GetHandlerPlayer()
    local a = vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2 == 1
    end, tp, LOCATION_REMOVED, 0, 1, nil)
    local b = vgf.IsExistingMatchingCard(function (c)
        return c:GetLevel()%2 == 0
    end, tp, LOCATION_REMOVED, 0, 1, nil)
    return (not a and b) or Duel.IsPlayerAffectedByEffect(tp, AFFECT_CODE_BOTH_WING)
end

function VgF.AddRideMaterialSetCardCheck(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.ride_material_setcard_chk) ~= "table" then cm.ride_material_setcard_chk = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.ride_material_setcard_chk, v)
    end
end
function VgF.AddRideMaterialCodeCheck(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.ride_material_code_chk) ~= "table" then cm.ride_material_code_chk = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.ride_material_code_chk, v)
    end
end
function VgF.AddRideMaterialSetCard(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.ride_setcard) ~= "table" then cm.ride_setcard = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.ride_setcard, v)
    end
end
function VgF.AddRideMaterialCode(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.ride_code) ~= "table" then cm.ride_code = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.ride_code, v)
    end
end
function VgF.AddAlchemagicFrom(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.cos_from) ~= "table" then cm.cos_from = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.cos_from, v)
    end
end
function VgF.AddAlchemagicTo(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.cos_to) ~= "table" then cm.cos_to = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.cos_to, v)
    end
end
function VgF.AddAlchemagicCountMin(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.cos_val) ~= "table" then cm.cos_val = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.cos_val, v)
    end
end
function VgF.AddAlchemagicCountMax(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.cos_val_max) ~= "table" then cm.cos_val_max = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.cos_val_max, v)
    end
end
function VgF.AddAlchemagicFilter(c, m, ...)
    local cm = _G["c"..m]
    if VgF.GetValueType(cm.cos_filter) ~= "table" then cm.cos_filter = {} end
    for i, v in ipairs({...}) do
        table.insert(cm.cos_filter, v)
    end
end
function VgF.AddEffectWhenTrigger(c, m, op, cost, con, tg, chk)
    local cm = _G["c"..m]
    cm.effect_when_trigger = {op, cost, con, tg, chk}
end

function VgF.ShiftLocationFromString(str)
    local loc = 0
    if str == "POSCHANGE" then return str end
    for i = 1, 13 do
        if str == LOCATION_LIST_STRING[i] then
            loc = LOCATION_LIST[i]
            break
        end
    end
    return loc
end

function VgF.PlayerEffect(e, tp, eg, ep, ev, re, r, rp)
    return true
end


---玩家抽1张卡
---@param p number 0：自己 1：对手 默认为0
---@param count number 抽count数量的卡 默认为1
function VgF.Draw(p, count)
    p = (VgF.GetValueType(p) ~= "number" or p < 0 or p > 1) and 0 or p
    count = VgF.GetValueType(count) ~= "number" and 1 or count
    return function (e,tp,eg,ep,ev,re,r,rp)
        local draw_player = p == 0 and tp or (1 - tp)
	    Duel.Draw(draw_player, count, REASON_EFFECT)
    end
end
---创建一个函数检查器 检查func是否为nil或函数
function VgF.IllegalFunctionCheck(name, c)
    if VgF.GetValueType(c) ~= "Card" then Debug.Message("VgD."..name.." param c isn't Card") end
    local m = c:GetOriginalCode()
    local chk = function(key)
        return function(func)
            local ftyp = type(func)
            if ftyp == "nil" or ftyp == "function" then return false end
            Debug.Message("c"..m.." VgD."..name.." param "..key.." isn't function | nil")
            return true
        end
    end
    return {con = chk("con"), cost = chk("cost"), tg = chk("tg"), op = chk("op")}
end
---检查并转换 loc 以及 con 用于【起】等模板函数
function VgF.GetLocCondition(loc, con)
    local con_exf = VgF.True
    if loc == LOCATION_R_CIRCLE then
        loc, con_exf = LOCATION_MZONE, VgF.RMonsterCondition
    elseif loc == LOCATION_V_CIRCLE then 
        loc, con_exf = LOCATION_MZONE, VgF.VMonsterCondition
    end
    loc = loc or LOCATION_MZONE
    local condition = function(e, tp, eg, ep, ev, re, r, rp)
        return (not con or con(e, tp, eg, ep, ev, re, r, rp)) and con_exf(e)
    end
    return loc, condition
end

VgF.EffectDamageE = nil

---效果伤害的operation函数
---@param val number 伤害的数值
---@param p number 受伤的玩家
function VgF.EffectDamage(val, p)
    return function (e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        c:RegisterFlagEffect(FLAG_DAMAGE_TRIGGER, RESET_EVENT + RESETS_STANDARD, 0, 1, val - 1)
        Duel.RegisterFlagEffect(p, FLAG_EFFECT_DAMAGE, 0, 0, 1)
        VgD.Trigger(e, p, eg, ep, ev, re, r, rp)
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
        e1:SetCode(EVENT_CUSTOM + EVENT_TRIGGER)
        e1:SetRange(LOCATION_ALL)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCondition(function (te, ttp, teg, tep, tev, tre, tr, trp)
            return Duel.GetFlagEffect(p, FLAG_EFFECT_DAMAGE) > 0
        end)
        e1:SetOperation(VgD.Trigger)
        c:RegisterEffect(e1)
        if VgF.GetValueType(VgF.EffectDamageE) == "Effect" then
            VgF.EffectDamageE:Reset()
            VgF.EffectDamageE = nil
        end
        VgF.EffectDamageE = e1
    end
end
