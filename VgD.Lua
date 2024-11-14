--VgD库
VgD = {}
vgd, vgf = VgD, VgF

---初始化卡片，使卡片具有基本的功能。
---@param c Card 要初始化的卡
function vgd.VgCard(c)
    VgD.Rule(c)
    VgD.RideUp(c)
    VgD.CardTrigger(c)
    if c:IsType(TYPE_MONSTER) then
        VgD.CallToR(c)
        VgD.MonsterBattle(c)
    end
end

---使卡片遵守VG的规则，已包含在 vgd.VgCard(c) 内
---@param c Card 要注册规则的卡
function VgD.Rule(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE + PHASE_DRAW)
    e1:SetRange(LOCATION_ALL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCountLimit(1, VgID + 2)
    e1:SetCondition(VgD.RuelDrawCondition)
    e1:SetOperation(VgD.RuelDrawOperation)
    c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLED)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(VgD.ResetOperation)
    c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE_START + PHASE_STANDBY)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_ALL)
    e3:SetCountLimit(1, VgID + 3)
    e3:SetCondition(VgF.RuleCardCondtion)
    e3:SetOperation(VgD.EventRideStart)
    c:RegisterEffect(e3)
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_HAND_LIMIT)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE)
    e10:SetRange(LOCATION_ALL)
    e10:SetTargetRange(1, 0)
    e10:SetValue(100)
    e10:SetCondition(VgF.RuleCardCondtion)
    c:RegisterEffect(e10)
    local e11 = Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_ADJUST)
    e11:SetRange(LOCATION_ALL)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e11:SetCondition(VgF.RuleCardCondtion)
    e11:SetOperation(VgD.RuleWin)
    c:RegisterEffect(e11)
    local e12 = Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_SKIP_M2)
    e12:SetRange(LOCATION_ALL)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetTargetRange(1, 0)
    c:RegisterEffect(e12)
    local e13 = e12:Clone()
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e13)
    local e14 = e12:Clone()
    e14:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e14)
    local e15 = e12:Clone()
    e15:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e15)
    local e16 = Effect.CreateEffect(c)
    e16:SetType(EFFECT_TYPE_FIELD)
    e16:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e16:SetRange(LOCATION_ALL)
    e16:SetCondition(VgF.RuleCardCondtion)
    e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e16:SetTargetRange(LOCATION_HAND, 0)
    c:RegisterEffect(e16)
end
function VgD.EventRideStart(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if Duel.GetTurnPlayer() == tp then
        Duel.RaiseEvent(c, EVENT_CUSTOM + EVENT_RIDE_START, e, 0, tp, tp, 0)
    end
end
function VgD.RuleWin(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetCurrentChain() > 0 then return end
    local g1 = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)
    local g2 = Duel.GetFieldGroupCount(tp, 0, LOCATION_DECK)
    if g1 == 0 and g2 == 0 then
        Duel.Win(PLAYER_NONE, 0x2)
    elseif g1 == 0 then
        Duel.Win(1 - tp, 0x2)
    elseif g2 == 0 then
        Duel.Win(tp, 0x2)
     end
end
function VgD.RuelDrawCondition(e, tp, eg, ep, ev, re, r, rp)
    return VgF.RuleTurnCondtion(e) and VgF.RuleCardCondtion(e)
end
function VgD.RuelDrawOperation(e, tp, eg, ep, ev, re, r, rp)
    local ct = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g = Duel.GetFieldGroup(tp, LOCATION_HAND, 0):Select(tp, 0, ct, nil)
    if g:GetCount() > 0 then
        ct = Duel.SendtoDeck(g, tp, 1, REASON_PHASEDRAW)
        Duel.Draw(tp, ct, REASON_PHASEDRAW)
        Duel.ShuffleDeck(tp)
    end
    if Duel.GetTurnPlayer() == tp then
        Duel.Draw(tp, 1, REASON_PHASEDRAW)
    end
end
function VgD.ResetOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:GetFlagEffect(FLAG_SUPPORT) > 0 then c:ResetFlagEffect(FLAG_SUPPORT) end
    if c:GetFlagEffect(FLAG_SUPPORTED) > 0 then c:ResetFlagEffect(FLAG_SUPPORTED) end
    if c:GetFlagEffect(FLAG_DEFENSE_ENTIRELY) > 0 then c:ResetFlagEffect(FLAG_DEFENSE_ENTIRELY) end
    if c:GetFlagEffect(FLAG_ATTACK_TRIGGER) > 0 then c:ResetFlagEffect(FLAG_ATTACK_TRIGGER) end
    if c:GetFlagEffect(FLAG_DAMAGE_TRIGGER) > 0 then c:ResetFlagEffect(FLAG_DAMAGE_TRIGGER) end
end

---使卡片具有骑升的功能，已包含在 vgd.VgCard(c) 内
---@param c Card 要注册骑升功能的卡
function VgD.RideUp(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetCountLimit(1, VgID)
    e1:SetRange(LOCATION_ALL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCondition(VgD.RideZeroCondition)
    e1:SetOperation(VgD.RideZeroOperation)
    c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e2:SetRange(LOCATION_ALL)
    e2:SetCountLimit(1, VgID + 1)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCondition(VgD.RideUpCondition)
    e2:SetOperation(VgD.RideUpOperation)
    c:RegisterEffect(e2)
end
function VgD.RideUpMaterialCheck(c, rc)
    if VgF.GetValueType(c.ride_material_code_chk) == "nil" and VgF.GetValueType(c.ride_material_setcard_chk) == "nil" then return true end
    if VgF.GetValueType(c.ride_material_code_chk) == "number" then
        if VgF.GetValueType(rc.ride_code) == "number" and c.ride_material_code_chk == rc.ride_code then return true
        elseif VgF.GetValueType(rc.ride_code) == "tabel" then
            for code in ipairs(rc.ride_code) do
                if c.ride_material_code_chk == code then return true end
            end
        end
        return c.ride_material_code_chk == rc:GetCode()
    elseif VgF.GetValueType(c.ride_material_code_chk) == "tabel" then
        for i in ipairs(c.ride_material_code_chk) do
            if VgF.GetValueType(rc.ride_code) == "number" and i == rc.ride_code then return true
            elseif VgF.GetValueType(rc.ride_code) == "tabel" then
                for code in ipairs(rc.ride_code) do
                    if i == code then return true end
                end
            end
            if rc:IsCode(i) then return true end
        end
    end
    if VgF.GetValueType(c.ride_material_setcard_chk) == "number" then
        if VgF.GetValueType(rc.ride_setcard) == "number" and c.ride_material_setcard_chk == rc.ride_setcard then return true
        elseif VgF.GetValueType(rc.ride_setcard) == "tabel" then
            for setcard in ipairs(rc.ride_setcard) do
                if c.ride_material_code_chk == setcard then return true end
            end
        end
        return rc:IsSetCard(c.ride_material_setcard_chk)
    elseif VgF.GetValueType(c.ride_material_setcard_chk) == "tabel" then
        for i in ipairs(c.ride_material_setcard_chk) do
            if VgF.GetValueType(rc.ride_setcard) == "number" and i == rc.ride_setcard then return true
            elseif VgF.GetValueType(rc.ride_setcard) == "tabel" then
                for setcard in ipairs(rc.ride_setcard) do
                    if i == setcard then return true end
                end
            end
            if rc:IsSetCard(i) then return true end
        end
    end
    return false
end
function VgD.RideUpFilter1(c, lv, code, rc)
    local tp = c:GetControler()
    if not c:IsType(TYPE_MONSTER) then return false end
    if rc:IsAttribute(SKILL_SELF_RIDE) and c:IsCode(code) then return false end
    if (c:IsLevel(lv, lv + 1) and c:IsLocation(LOCATION_HAND)) then return VgD.RideUpMaterialCheck(c, rc) end
    if (c:IsLevel(lv + 1) and c:IsLocation(LOCATION_RIDE) and (VgF.IsExistingMatchingCard(nil, tp, LOCATION_HAND, 0, 1, nil) or (Duel.IsPlayerAffectedByEffect(tp, AFFECT_CODE_OVERLAY_INSTEAD_WHEN_RIDE) and VgF.GetVMonster(tp):GetOverlayCount() > 0))) then return VgD.RideUpMaterialCheck(c, rc) end
    return false
end
function VgD.DisCardRideUpFilter(c, e, lv, code, rc)
    local tp = c:GetControler()
    return c:IsDiscardable() and VgF.IsExistingMatchingCard(VgD.RideUpFilter1, tp, LOCATION_HAND + LOCATION_RIDE, 0, 1, c, lv, code, rc)
end
function VgD.RideUpFilter2(c, lv, code, rc)
    return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsCode(code) and rc:IsAttribute(SKILL_SELF_RIDE)
end
function VgD.RideUpCondition(e, tp, eg, ep, ev, re, r, rp)
    local rc = Duel.GetMatchingGroup(VgF.VMonsterFilter, tp, LOCATION_MZONE, 0, nil):GetFirst()
    if not rc then return false end
    local lv = rc:GetLevel()
    local code = rc:GetCode()
    local rg1 = Duel.GetMatchingGroup(VgD.RideUpFilter1, tp, LOCATION_HAND + LOCATION_RIDE, 0, nil, lv, code, rc)
    local rg2 = Duel.GetMatchingGroup(VgD.RideUpFilter2, tp, LOCATION_HAND, 0, nil, lv, code, rc)
    local a = rg1:GetCount() > 0
    local b = rg2:GetCount() > 0
    return Duel.GetTurnPlayer() == tp and VgF.RuleCardCondtion(e) and (a or b)
end
function VgD.RideUpOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local rc = VgF.GetVMonster(tp)
    if not rc then return end
    local lv = rc:GetLevel()
    local code = rc:GetCode()
    local rg1 = Duel.GetMatchingGroup(VgD.RideUpFilter1, tp, LOCATION_HAND + LOCATION_RIDE, 0, nil, lv, code, rc)
    local rg2 = Duel.GetMatchingGroup(VgD.RideUpFilter2, tp, LOCATION_HAND, 0, nil, lv, code, rc)
    local a = rg1:GetCount() > 0
    local b = rg2:GetCount() > 0
    local off = 1
    local ops = {}
    if a then
        ops[off] = VgF.Stringid(VgID, 3)
        off = off + 1
    end
    if b then
        ops[off] = VgF.Stringid(VgID, 4)
        off = off + 1
    end
    ops[off] = VgF.Stringid(VgID, 5)
    local sel = Duel.SelectOption(tp, table.unpack(ops))
    if sel == 0 and a then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CALL)
        local sg = rg1:FilterSelect(tp, Card.IsLocation, 1, 1, nil, LOCATION_HAND + LOCATION_RIDE)
        local sc = sg:GetFirst()
        if sc:IsLocation(LOCATION_EXTRA) then
            if Duel.IsPlayerAffectedByEffect(tp, AFFECT_CODE_OVERLAY_INSTEAD_WHEN_RIDE) and Duel.SelectYesNo(tp, VgF.Stringid(VgID, 14)) then
                VgF.DamageCost(1)(e, tp, eg, ep, ev, re, r, rp, 1)
            else
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
                local g = Duel.SelectMatchingCard(tp, VgD.DisCardRideUpFilter, tp, LOCATION_HAND, 0, 1, 1, nil, e, lv, code, rc)
                VgF.Sendto(LOCATION_DROP, g, REASON_COST + REASON_DISCARD)
            end
        end
        local mg = rc:GetOverlayGroup()
        if mg:GetCount() ~= 0 then
            VgF.Sendto(LOCATION_OVERLAY, mg, sc)
        end
        sc:SetMaterial(Group.FromCards(rc))
        VgF.Sendto(LOCATION_OVERLAY, Group.FromCards(rc), sc)
        VgF.Sendto(LOCATION_MZONE, sc, SUMMON_TYPE_RIDE, tp, 0x20)
        if VgF.IsExistingMatchingCard(Card.IsType, tp, LOCATION_RIDE, 0, 1, nil, TYPE_EMBLEM) then
            local tc = Duel.GetMatchingGroup(Card.IsType, tp, LOCATION_RIDE, 0, nil, TYPE_EMBLEM):GetFirst()
            VgF.Sendto(LOCATION_EMBLEM, tc, tp, POS_FACEUP_DEFENSE, REASON_EFFECT)
        end
    elseif sel == 0 or (sel == 1 and a and b) then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CALL)
        local sg = rg2:Select(tp, 1, 1, nil)
        local sc = sg:GetFirst()
        local mg = rc:GetOverlayGroup()
        if mg:GetCount() ~= 0 then
            VgF.Sendto(LOCATION_OVERLAY, mg, sg)
        end
        sc:SetMaterial(Group.FromCards(rc))
        VgF.Sendto(LOCATION_OVERLAY, Group.FromCards(rc), sc)
        VgF.Sendto(LOCATION_MZONE, sc, SUMMON_TYPE_SELFRIDE, tp, 0x20)
        Duel.Draw(tp, 1, REASON_EFFECT)
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetTargetRange(LOCATION_MZONE, 0)
        e1:SetValue(10000)
        e1:SetTarget(VgD.SelfRideAtk)
        e1:SetReset(RESET_PHASE + PHASE_END)
        Duel.RegisterEffect(e1, tp)
    end
end
function VgD.SelfRideAtk(e, c)
    return VgF.IsSequence(c, 0, 4, 5)
end
function VgD.RideZeroCondition(e, tp, eg, ep, ev, re, r, rp)
    local rc = Duel.GetMatchingGroup(VgF.VMonsterFilter, tp, LOCATION_MZONE, 0, nil):GetFirst()
    if rc then return false end
    local ct = Duel.GetMatchingGroupCount(Card.IsLevel, tp, LOCATION_RIDE, 0, nil, 0)
    return VgF.RuleTurnCondtion(e) and ct > 0 and VgF.RuleCardCondtion(e)
end
function VgD.RideZeroOperation(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(Card.IsLevel, tp, LOCATION_RIDE, 0, nil, 0)
    if g:GetCount() > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CALL)
        g = g:Select(tp, 1, 1, nil)
    end
    VgF.Sendto(LOCATION_MZONE, g, SUMMON_TYPE_RIDE, tp, 0x20)
end

---使卡片具有触发卡的功能，已包含在 vgd.VgCard(c) 内
---@param c Card 要注册触发功能的卡
function VgD.CardTrigger(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_CANNOT_DISABLE + EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_MOVE)
    e1:SetCondition(VgD.CardTriggerCondtion('Damage'))
    e1:SetOperation(VgD.CardTriggerOperation('Damage'))
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCondition(VgD.CardTriggerCondtion('Normal'))
    e2:SetOperation(VgD.CardTriggerOperation('Normal'))
    c:RegisterEffect(e2)
    local e3 = e1:Clone()
    e3:SetCondition(VgD.CardTriggerCondtion('EffectDamage'))
    e3:SetOperation(VgD.CardTriggerOperation('EffectDamage'))
    c:RegisterEffect(e3)
end
function VgD.CardTriggerCondtion(chkcon)
    return function (e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        if chkcon == 'EffectDamage' then
            return c:IsLocation(LOCATION_TRIGGER) and Duel.GetFlagEffect(tp, FLAG_EFFECT_DAMAGE) > 0
        end
        local cp = tp
        if chkcon == 'Damage' then
            cp = 1 - tp
        end
        return Duel.GetAttacker() and Duel.GetAttacker():GetControler() == cp and c:IsLocation(LOCATION_TRIGGER) and Duel.GetFlagEffect(tp, FLAG_EFFECT_DAMAGE) == 0
    end
end
function VgD.CardTriggerOperation(chkop)
    return function (e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        if c:IsRace(TRIGGER_CRITICAL_STRIKE) then
            local g1 = VgF.SelectMatchingCard(HINTMSG_CRITICAL_STRIKE, e, tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
            VgF.StarUp(c, g1, 1, nil)
            local g2 = VgF.SelectMatchingCard(HINTMSG_ATKUP, e, tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
            VgF.AtkUp(c, g2, 10000, nil)
        elseif c:IsRace(TRIGGER_DRAW) then
            local g = VgF.SelectMatchingCard(HINTMSG_ATKUP, e, tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
            VgF.AtkUp(c, g, 10000, nil)
            Duel.Draw(tp, 1, REASON_TRIGGER)
        elseif c:IsRace(TRIGGER_HEAL) then
            local g = VgF.SelectMatchingCard(HINTMSG_ATKUP, e, tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
            VgF.AtkUp(c, g, 10000, nil)
            if Duel.GetMatchingGroupCount(nil, tp, LOCATION_DAMAGE, 0, nil) >= Duel.GetMatchingGroupCount(nil, tp, 0, LOCATION_DAMAGE, nil) then
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODROP)
                local tc = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_DAMAGE, 0, 1, 1, nil):GetFirst()
                if tc then
                    VgF.Sendto(LOCATION_DROP, tc, REASON_TRIGGER)
                    Duel.Recover(tp, 1, REASON_RULE)
                end
            end
        elseif c:IsRace(TRIGGER_ADVANCE) then
            local g = Duel.GetMatchingGroup(VgF.IsSequence, tp, LOCATION_MZONE, 0, nil, 0, 4, 5)
            VgF.AtkUp(c, g, 10000, nil)
        end
        if chkop == 'Damage' then
            if c:IsRace(TRIGGER_SUPER) then
                local ops = {}
                local sel = {}
                if c:IsRelateToEffect(e) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 3))
                    table.insert(sel, function ()
                        VgF.Sendto(LOCATION_EXILE, c, REASON_TRIGGER)
                    end)
                end
                if true then
                    table.insert(ops, VgF.Stringid(VgID + 5, 4))
                    table.insert(sel, function ()
                        Duel.Draw(tp, 1, REASON_TRIGGER)
                    end)
                end
                if VgF.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, 0, 1, nil) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 5))
                    table.insert(sel, function ()
                        local g = VgF.SelectMatchingCard(HINTMSG_ATKUP, e, tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
                        VgF.AtkUp(c, g, 100000000, nil)
                    end)
                end
                if VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 0) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 5))
                    table.insert(sel, function ()
                        VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 1)
                    end)
                end
                while #ops > 0 do
                    local i = Duel.SelectOption(tp, table.unpack(ops)) + 1
                    sel[i]()
                    table.remove(ops, i)
                    table.remove(sel, i)
                end
            else
                if VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 0) then VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 1) end
                if c:IsRelateToEffect(e) then
                    VgF.Sendto(LOCATION_DAMAGE, c, tp, POS_FACEUP_ATTACK, REASON_EFFECT)
                    Duel.Damage(tp, 1, REASON_TRIGGER)
                end
            end
            local bc = Duel.GetAttackTarget()
            local label = bc:GetFlagEffectLabel(FLAG_DAMAGE_TRIGGER)
            if not label then return end
            if label > 0 then
                label = label - 1
                Duel.RaiseEvent(c, EVENT_CUSTOM + EVENT_TRIGGER, e, 0, tp, tp, 0)
                bc:ResetFlagEffect(FLAG_DAMAGE_TRIGGER)
                bc:RegisterFlagEffect(FLAG_DAMAGE_TRIGGER, RESET_EVENT + RESETS_STANDARD, 0, 1, label)
            elseif label == 0 then
                bc:ResetFlagEffect(FLAG_DAMAGE_TRIGGER)
                Duel.RaiseEvent(bc, EVENT_CUSTOM + EVENT_DAMAGE_TRIGGER, e, 0, tp, tp, 0)
            end
        elseif chkop == 'Normal' then
            if c:IsRace(TRIGGER_SUPER) then
                local ops = {}
                local sel = {}
                if c:IsRelateToEffect(e) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 3))
                    table.insert(sel, function ()
                        VgF.Sendto(LOCATION_EXILE, c, REASON_TRIGGER)
                    end)
                end
                if true then
                    table.insert(ops, VgF.Stringid(VgID + 5, 4))
                    table.insert(sel, function ()
                        Duel.Draw(tp, 1, REASON_TRIGGER)
                    end)
                end
                if VgF.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, 0, 1, nil) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 5))
                    table.insert(sel, function ()
                        local g = VgF.SelectMatchingCard(HINTMSG_ATKUP, e, tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
                        VgF.AtkUp(c, g, 100000000, nil)
                    end)
                end
                if VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 0) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 6))
                    table.insert(sel, function ()
                    return VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 1)
                end)
                end
                while #ops > 0 do
                    local i = Duel.SelectOption(tp, table.unpack(ops)) + 1
                    sel[i]()
                    table.remove(ops, i)
                    table.remove(sel, i)
                end
            else
                if VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 0) then VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 1) end
                if c:IsRelateToEffect(e) then VgF.Sendto(LOCATION_HAND, c, nil, REASON_TRIGGER) end
            end
            local bc = Duel.GetAttacker()
            local label = bc:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER)
            if not label then return end
            if label > 1 then
                label = label - 1
                Duel.RaiseEvent(c, EVENT_CUSTOM + EVENT_TRIGGER, e, 0, tp, tp, 0)
                bc:ResetFlagEffect(FLAG_ATTACK_TRIGGER)
                bc:RegisterFlagEffect(FLAG_ATTACK_TRIGGER, RESET_EVENT + RESETS_STANDARD, 0, 1, label)
            elseif label == 1 then
                bc:ResetFlagEffect(FLAG_ATTACK_TRIGGER)
            end
        else
            if c:IsRace(TRIGGER_SUPER) then
                local ops = {}
                local sel = {}
                if c:IsRelateToEffect(e) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 3))
                    table.insert(sel, function ()
                        VgF.Sendto(LOCATION_EXILE, c, REASON_TRIGGER)
                    end)
                end
                if true then
                    table.insert(ops, VgF.Stringid(VgID + 5, 4))
                    table.insert(sel, function ()
                        Duel.Draw(tp, 1, REASON_TRIGGER)
                    end)
                end
                if VgF.IsExistingMatchingCard(nil, tp, LOCATION_MZONE, 0, 1, nil) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 5))
                    table.insert(sel, function ()
                        local g = VgF.SelectMatchingCard(HINTMSG_ATKUP, e, tp, nil, tp, LOCATION_MZONE, 0, 1, 1, nil)
                        VgF.AtkUp(c, g, 100000000, nil)
                    end)
                end
                if VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 0) then
                    table.insert(ops, VgF.Stringid(VgID + 5, 5))
                    table.insert(sel, function ()
                        VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 1)
                    end)
                end
                while #ops > 0 do
                    local i = Duel.SelectOption(tp, table.unpack(ops)) + 1
                    sel[i]()
                    table.remove(ops, i)
                    table.remove(sel, i)
                end
            else
                if VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 0) then VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, 1) end
                if c:IsRelateToEffect(e) then
                    VgF.Sendto(LOCATION_DAMAGE, c, tp, POS_FACEUP_ATTACK, REASON_EFFECT)
                    Duel.Damage(tp, 1, REASON_EFFECT)
                end
            end
            if VgF.GetValueType(VgF.EffectDamageE) ~= "Effect" then return end
            local bc = VgF.EffectDamageE:GetHandler()
            local label = bc:GetFlagEffectLabel(FLAG_DAMAGE_TRIGGER)
            if not label then return end
            if label > 0 then
                label = label - 1
                Duel.RaiseEvent(c, EVENT_CUSTOM + EVENT_TRIGGER, e, 0, tp, tp, 0)
                bc:ResetFlagEffect(FLAG_DAMAGE_TRIGGER)
                bc:RegisterFlagEffect(FLAG_DAMAGE_TRIGGER, 0, 0, 1, label)
            elseif label == 0 then
                bc:ResetFlagEffect(FLAG_DAMAGE_TRIGGER)
                VgF.EffectDamageE:Reset()
                VgF.EffectDamageE = nil
            end
        end
    end
end

function VgD.OperationWhenCardTrigger(e, tp, eg, ep, ev, re, r, rp, c, chk)
    local effect_when_trigger = c.effect_when_trigger
    local cost, con, tg = true, true, true
    if not effect_when_trigger or #effect_when_trigger == 0 then return end
    if (VgF.GetValueType(effect_when_trigger[5]) == "boolean" and not effect_when_trigger[5]) or (VgF.GetValueType(effect_when_trigger[5]) ~= "boolean" and Duel.GetTurnPlayer() ~= c:GetControler()) then return false end
    if VgF.GetValueType(effect_when_trigger[2]) == "function" then cost = effect_when_trigger[2](e, tp, eg, ep, ev, re, r, rp, 0) end
    if VgF.GetValueType(effect_when_trigger[3]) == "function" then con = effect_when_trigger[3](e, tp, eg, ep, ev, re, r, rp) end
    if VgF.GetValueType(effect_when_trigger[4]) == "function" then tg = effect_when_trigger[4](e, tp, eg, ep, ev, re, r, rp, 0) end
    if VgF.GetValueType(effect_when_trigger[1]) == "function" and cost and con and tg then
        if chk == 0 then return true end
        local activate_chk = true
        if VgF.GetValueType(effect_when_trigger[2]) == "function" then activate_chk = Duel.SelectYesNo(tp, VgF.Stringid(VgID, 15)) end
        if activate_chk then
            Duel.HintSelection(Group.FromCards(c))
            local _, m = c:GetOriginalCode()
            Duel.Hint(HINT_CARD, 0, m)
            if VgF.GetValueType(effect_when_trigger[2]) == "function" then effect_when_trigger[2](e, tp, eg, ep, ev, re, r, rp, 1) end
            if VgF.GetValueType(effect_when_trigger[4]) == "function" then effect_when_trigger[4](e, tp, eg, ep, ev, re, r, rp, 1) end
            effect_when_trigger[1](e, tp, eg, ep, ev, re, r, rp)
        end
    end
    return false
end

---使卡片具有Call到R位的功能，已包含在 vgd.VgCard(c) 内
---@param c Card 要注册Call到R位功能的卡
function VgD.CallToR(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(1152)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK, 0)
    e1:SetCondition(VgD.CallCondition)
    e1:SetOperation(VgD.CallOperation)
    c:RegisterEffect(e1)
end
function VgD.CallCondition(e, c)
    if c == nil then return true end
    local tp = e:GetHandlerPlayer()
    if VgF.GetAvailableLocation(tp) <= 0 then return end
    return VgF.LvCondition(e)
end
function VgD.CallFilter(c, tp, zone)
    return VgF.RMonsterFilter(c) and zone == VgF.SequenceToGlobal(tp, c:GetLocation(), c:GetSequence())
end
function VgD.CallOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local z = bit.bnot(VgF.GetAvailableLocation(tp))
    local rg = Duel.GetMatchingGroup(Card.IsPosition, tp, LOCATION_MZONE, 0, nil, POS_FACEDOWN_ATTACK)
    for tc in VgF.Next(rg) do
        local szone = VgF.SequenceToGlobal(tp, tc:GetLocation(), tc:GetSequence())
        z = bit.bor(z, szone)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CallZONE)
    local zone = Duel.SelectField(tp, 1, LOCATION_MZONE, 0, z)
    if VgF.IsExistingMatchingCard(VgD.CallFilter, tp, LOCATION_MZONE, 0, 1, nil, tp, zone) then
        local tc = Duel.GetMatchingGroup(VgD.CallFilter, tp, LOCATION_MZONE, 0, nil, tp, zone):GetFirst()
        VgF.Sendto(LOCATION_DROP, tc, REASON_COST)
    end
    e:SetValue(function () return SUMMON_VALUE_CALL, zone end)
end

---使卡片遵守VG的战斗规则，已包含在 vgd.VgCard(c) 内
---@param c Card 要注册战斗规则的卡
function VgD.MonsterBattle(c)
    --攻击转守备
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetOperation(VgD.MonsterPosDefenseOperation)
    c:RegisterEffect(e1)
    --回合开始转攻
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_ALL)
    e2:SetCountLimit(1, VgID + 4)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCondition(VgF.RuleCardCondtion)
    e2:SetOperation(VgD.MonsterPosAttackOperation)
    c:RegisterEffect(e2)
    --扣血
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCondition(VgD.MonsterBattleDamageCondition)
    e3:SetOperation(VgD.MonsterBattleDamageOperation)
    c:RegisterEffect(e3)
    --攻击判定
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_F)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCondition(VgD.MonsterAttackCondition)
    e4:SetCost(VgD.MonsterAttackCost)
    e4:SetOperation(VgD.TriggerCard)
    c:RegisterEffect(e4)
    --多次判定
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_CUSTOM + EVENT_TRIGGER)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCondition(VgD.MonsterNextTrigger)
    e5:SetOperation(VgD.TriggerCard)
    c:RegisterEffect(e5)
    --支援
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetCondition(VgD.SupportCondition)
    e6:SetOperation(VgD.SupportOperation)
    c:RegisterEffect(e6)
    local e9 = Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    e9:SetRange(LOCATION_MZONE)
    e9:SetValue(VgD.SupportValue)
    c:RegisterEffect(e9)
    --防御
    local e7 = Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DEFENDER)
    e7:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_BATTLE_START)
    e7:SetRange(LOCATION_MZONE)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetCountLimit(1)
    e7:SetCondition(VgD.SendToGCondition(LOCATION_MZONE))
    e7:SetOperation(VgD.SendToGOperation)
    c:RegisterEffect(e7)
    local e17 = e7:Clone()
    e17:SetRange(LOCATION_HAND)
    e17:SetCondition(VgD.SendToGCondition(LOCATION_HAND))
    c:RegisterEffect(e17)
    local e8 = Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_DAMAGE_STEP_END)
    e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_DELAY)
    e8:SetRange(LOCATION_ALL)
    e8:SetCondition(VgF.RuleCardCondtion)
    e8:SetOperation(VgD.GToGraveOperation)
    c:RegisterEffect(e8)
    --其他永续
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_DEFENSE_ATTACK)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e10:SetValue(1)
    c:RegisterEffect(e10)
    local e11 = Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e11:SetCondition(VgD.MonsterAttackAnnounceCondition)
    c:RegisterEffect(e11)
    local e12 = Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e12)
    local e13 = Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE)
    e13:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e13:SetValue(1)
    c:RegisterEffect(e13)
    local e14 = Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_SINGLE)
    e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
    e14:SetRange(LOCATION_MZONE)
    e14:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e14:SetCondition(VgD.MonsterCannotBeDestoryCondition)
    e14:SetValue(1)
    c:RegisterEffect(e14)
    local e15 = Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_SINGLE)
    e15:SetCode(EFFECT_EXTRA_ATTACK)
    e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e15:SetValue(100)
    c:RegisterEffect(e15)
    local e16 = Effect.CreateEffect(c)
    e16:SetType(EFFECT_TYPE_SINGLE)
    e16:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e16:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
    e16:SetRange(LOCATION_MZONE)
    e16:SetCondition(VgD.MonsterCannotBeAttackedCondition)
    e16:SetValue(VgF.True)
    c:RegisterEffect(e16)
end
function VgD.TriggerCard(e, tp, eg, ep, ev, re, r, rp)
    local tg = Duel.GetDecktopGroup(tp, 1)
    Duel.DisableShuffleCheck()
    VgF.Sendto(LOCATION_TRIGGER, tg:GetFirst())
end
function VgD.MonsterPosDefenseOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.ChangePosition(c, POS_FACEUP_DEFENSE)
    local label = 1
    if c:IsAttribute(SKILL_TWICE_TRIGGER) then
        label = label + 1
    elseif c:IsAttribute(SKILL_THRICE_TRIGGER) then
        label = label + 2
    end
    c:RegisterFlagEffect(FLAG_ATTACK_TRIGGER, RESET_EVENT + RESETS_STANDARD, 0, 1, label)
    Duel.RaiseEvent(c, EVENT_CUSTOM + EVENT_TRIGGERCOUNTUP, e, 0, tp, tp, 0)
end
function VgD.MonsterPosAttackOperation(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(Card.IsPosition, tp, LOCATION_MZONE, 0, nil, POS_FACEUP_DEFENSE)
    if g:GetCount() > 0 and Duel.GetTurnPlayer() == tp then
        Duel.ChangePosition(g, POS_FACEUP_ATTACK)
        Duel.Hint(HINT_LINES, tp, VgF.Stringid(VgID, 8))
    end
end
function VgD.MonsterBattleDamageCondition(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local bc = c:GetBattleTarget()
    if not bc or not bc:IsRelateToBattle() then return false end
    local atk = bc:GetAttack()
    local def = c:GetAttack()
    if Duel.GetAttackTarget():GetFlagEffect(FLAG_DEFENSE_ENTIRELY) > 0 and Duel.GetAttackTarget():GetFlagEffectLabel(FLAG_DEFENSE_ENTIRELY) == 10402017 and bc:IsLevelBelow(2) then return false end
    if Duel.GetAttackTarget():GetFlagEffect(FLAG_DEFENSE_ENTIRELY) > 0 and Duel.GetAttackTarget():GetFlagEffectLabel(FLAG_DEFENSE_ENTIRELY) == 0 then return false end
    return VgF.VMonsterFilter(c) and c == Duel.GetAttackTarget() and atk >= def and bc:GetLeftScale() > 0
end
function VgD.MonsterBattleDamageOperation(e, tp, eg, ep, ev, re, r, rp)
    local bc = Duel.GetAttacker()
    local label = bc:GetLeftScale() - 1
    bc:RegisterFlagEffect(FLAG_DAMAGE_TRIGGER, RESET_EVENT + RESETS_STANDARD, 0, 1, label)
    VgD.TriggerCard(e, tp, eg, ep, ev, re, r, rp)
end
function VgD.MonsterNextTrigger(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return VgF.ReturnCard(eg):GetControler() == tp and VgF.VMonsterFilter(c) and Duel.GetFlagEffect(tp, FLAG_EFFECT_DAMAGE) == 0
end
function VgD.SupportCondition(e, tp, eg, ep, ev, re, r, rp)
    return VgF.GetColumnGroup(Duel.GetAttacker()):IsContains(e:GetHandler()) and Duel.GetTurnPlayer() == tp and e:GetHandler():IsAttribute(SKILL_SUPPORT)
end
function VgD.SupportOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.ChangePosition(c, POS_FACEUP_DEFENSE)
    c:RegisterFlagEffect(FLAG_SUPPORT, RESET_EVENT + RESETS_STANDARD, 0, 1)
    Duel.GetAttacker():RegisterFlagEffect(FLAG_SUPPORTED, RESET_EVENT + RESETS_STANDARD, 0, 1)
    Duel.RaiseEvent(c, EVENT_CUSTOM + EVENT_SUPPORT, e, 0, tp, tp, 0)
end
function VgD.SupportValue(e)
        local tp = e:GetHandlerPlayer()
        local atk = 0
        if Duel.GetAttacker() == e:GetHandler() then
        local g = Duel.GetMatchingGroup(function (c)
            return c:GetFlagEffect(FLAG_SUPPORT) > 0
        end, tp, LOCATION_MZONE, 0, nil)
        for tc in VgF.Next(g) do
            atk = atk + tc:GetAttack()
        end
        return atk
    elseif Duel.GetAttackTarget() == e:GetHandler() then
        local g = Duel.GetMatchingGroup(nil, tp, LOCATION_GZONE, 0, nil)
        for tc in VgF.Next(g) do
            local def = tc:GetDefense()
            if def < 0 then def = 0 end
            atk = atk + def
        end
        return atk
    else
        return 0
    end
end
function VgD.SendToGCondition(loc)
    return function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local bc = Duel.GetAttackTarget()
        return bc and bc:IsControler(tp) and bc ~= c and VgF.IsAbleToGZone(c, loc)
    end
end
function VgD.SendToGOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    VgF.Sendto(LOCATION_GZONE, c, tp, POS_FACEUP, REASON_EFFECT)
end
function VgD.GToGraveOperation(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(tp, LOCATION_GZONE, 0)
    if g:GetCount() > 0 then VgF.Sendto(LOCATION_DROP, g, REASON_RULE) end
end
function VgD.MonsterAttackAnnounceCondition(e, c)
    return e:GetHandler():IsPosition(POS_DEFENSE) or (VgF.IsSequence(e:GetHandler(), 1, 2, 3) and e:GetHandler():GetFlagEffect(FLAG_ATTACK_AT_REAR) == 0)
end
function VgD.MonsterAttackCondition(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not VgF.VMonsterFilter(c) and c:GetFlagEffect(FLAG_ALSO_CAN_TRIGGER) == 0 then return false end
    local a = c:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER) and c:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER) > 0
    return a and Duel.GetAttacker() == c
end
function VgD.MonsterAttackCost(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    if chk == 0 then return c:GetFlagEffect(FLAG_COUNT_TRIGGER) == 0 end
    c:RegisterFlagEffect(FLAG_COUNT_TRIGGER, RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_DAMAGE_CAL, 0, 1)
end
function VgD.MonsterCannotBeDestoryCondition(e)
    local c = e:GetHandler()
    return VgF.VMonsterFilter(c) or Duel.GetAttacker() == e:GetHandler()
end
function VgD.MonsterCannotBeAttackedCondition(e, c)
    return VgF.IsSequence(e:GetHandler(), 1, 2, 3)
end

--起自永以外关键字----------------------------------------------------------------------------------------

---使卡片具有超限舞装的功能
---@param c Card 要注册超限舞装功能的卡
---@param filter number 卡名为 filter 的后防者，或符合 filter 的后防者等
---@return Effect 这个效果
function VgD.OverDress(c, filter)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(VgF.Stringid(VgID, 9))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK, 0)
    e1:SetCondition(VgD.OverDressCondition(filter))
    e1:SetOperation(VgD.OverDressOperation(filter))
    c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(VgD.OverDressSum)
    c:RegisterEffect(e2)
    return e1
end
function VgD.OverDressCondition(filter)
    return function (e, c)
        if c == nil then return true end
        local tp = e:GetHandlerPlayer()
        return VgF.LvCondition(e) and VgF.IsExistingMatchingCard(VgD.OverDressFilter, tp, LOCATION_MZONE, 0, 1, nil, filter)
    end
end
function VgD.OverDressFilter(c, filter, tp, zone)
    if not c:IsFaceup() then return false end
    if zone and zone ~= VgF.SequenceToGlobal(tp, c:GetLocation(), c:GetSequence()) then return false end
    return not filter or (type(filter) == "function" and filter(c)) or (type(filter) == "number" and c:IsCode(filter))
end
function VgD.OverDressOperation(filter)
    return function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local g = Duel.GetMatchingGroup(VgD.OverDressFilter, tp, LOCATION_MZONE, 0, nil, filter, tp)
        local zone, szone = 0, 0
        for tc in VgF.Next(g) do
            zone = bit.bor(zone, VgF.SequenceToGlobal(tp, tc:GetLocation(), tc:GetSequence()))
        end
        if zone == 0 then return end
        zone = bit.bnot(zone)
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CallZONE)
        szone = Duel.SelectField(tp, 1, LOCATION_MZONE, 0, zone)
        e:SetValue(function () return SUMMON_VALUE_CALL + SUMMON_VALUE_OverDress, szone end)
        local mg = Duel.GetMatchingGroup(VgD.OverDressFilter, tp, LOCATION_MZONE, 0, nil, filter, tp, szone)
        if #mg == 0 then return end
        local og = tc:GetOverlayGroup()
        if #og ~= 0 then
            VgF.Sendto(LOCATION_OVERLAY, og, c)
        end
        c:SetMaterial(Group.FromCards(tc))
        VgF.Sendto(LOCATION_OVERLAY, mg, c)
    end
end
function VgD.OverDressSum(e, tp, eg, ep, ev, re, r, rp)
    e:GetHandler():RegisterFlagEffect(FLAG_CONDITION, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 201, VgF.Stringid(10101006, 0))
end

---使卡片具有交织超限舞装的功能
---@param c Card 要注册交织超限舞装功能的卡
---@param filter number 卡名为 filter 的后防者，或符合 filter 的后防者等
---@return Effect 这个效果
function VgD.XOverDress(c, filter)

end

---使卡片具有舞装加身的功能
---@param c Card 要注册舞装加身功能的卡
---@param code number 指定卡的卡号
---@return Effect 这个效果
function VgD.DressUp(c, code)
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_SINGLE)
    e:SetCode(EFFECT_ADD_CODE)
    e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e:SetValue(code)
    c:RegisterEffect(e)
    return e
end

--指令卡相关----------------------------------------------------------------------------------------

---使卡片可以作为指令卡发动
---@param c Card 要注册指令卡功能的卡
---@param m number|nil 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param op function|nil 作为指令卡的效果
---@param cost function|nil 作为指令卡的发动费用
---@param con function|nil 作为指令卡的发动条件
---@return Effect 这个效果
function VgD.SpellActivate(c, m, op, cost, con)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("SpellActivate")
    if fchk.con(con) or fchk.cost(cost) or fchk.op(op) then return end
    -- set param
    m = m or c:GetOriginalCode()
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetDescription(VgF.Stringid(m, 0))
    e:SetType(EFFECT_TYPE_ACTIVATE)
    e:SetCode(EVENT_FREE_CHAIN)
    e:SetCondition(VgD.SpellCondtion(con))
    e:SetCost(VgD.MixCost(cost))
    e:SetTarget(VgD.SpellTarget)
    e:SetOperation(VgD.SpellOperation(op))
    c:RegisterEffect(e)
    return e
end
function VgD.SpellCondtion(con)
    return function(e, tp, eg, ep, ev, re, r, rp)
        return VgF.LvCondition(e) and (not con or con(e, tp, eg, ep, ev, re, r, rp))
    end
end
function VgD.MixCost(cost)
    return function(e, tp, eg, ep, ev, re, r, rp, chk)
        cost = cost or aux.TRUE
        local c = e:GetHandler()
        local alchemagic_g = Duel.GetMatchingGroup(VgD.MixCostFilter, tp, LOCATION_DROP, 0, nil, e, tp, eg, ep, ev, re, r, rp, c)
        local alchemagic_chk = Duel.IsPlayerAffectedByEffect(tp, AFFECT_CODE_MIX) and #alchemagic_g > 0
        local cost_chk = cost(e, tp, eg, ep, ev, re, r, rp, 0)
        if chk == 0 then return cost_chk or alchemagic_chk end
        if alchemagic_chk and (not cost_chk or Duel.SelectYesNo(tp, VgF.Stringid(VgID, 6))) then
            local alchemagic_c = alchemagic_g:Select(tp, 1, 1, nil):GetFirst()
            VgF.Sendto(LOCATION_LOCK, alchemagic_c, POS_FACEUP, REASON_COST)
            e:SetLabelObject(alchemagic_c)
            VgD.MixCostOperation(c, alchemagic_c, tp)
        else
            cost(e, tp, eg, ep, ev, re, r, rp, 1)
        end
    end
end
function VgD.MixCostFilter(c, e, tp, eg, ep, ev, re, r, rp, mc)
    if Duel.IsPlayerAffectedByEffect(tp, AFFECT_CODE_MIX_DIFFERENT_NAME) and c:IsCode(mc:GetCode()) then return false end
    --得到需要支付的费用（从哪来，几张卡，什么卡）
    local cfrom, cval, cfilter, mcfrom, mcval, mcfilter
    table.copy(cfrom, c.cos_from)
    table.copy(cval, c.cos_val)
    table.copy(cfilter, c.cos_filter)
    table.copy(mcfrom, mc.cos_from)
    table.copy(mcval, mc.cos_val)
    table.copy(mcfilter, mc.cos_filter)
    --如果都有费用要付，则合成费用
    if #cfrom > 0 and #mcfrom > 0 then
        for cv = 1, #cfrom do
            local c_cost_from = VgF.ShiftLocationFromString(cfrom[cv])
            local pos = 0
            for mcv = 1, #mcfrom do
                local mc_cost_from = VgF.ShiftLocationFromString(mcfrom[mcv])
                if mc_cost_from == c_cost_from then
                    local mc_cos_val = mcval[mcv]
                    local c_cos_val = cval[cv]
                    if VgF.GetValueType(mc_cos_val) ~= "number" then mc_cos_val = 0 end
                    if VgF.GetValueType(c_cos_val) ~= "number" then c_cos_val = 0 end
                    local both_cos_val = mc_cos_val + c_cos_val
                    --判断其他减少费用的效果
                    if mc_cost_from == LOCATION_OVERLAY and Duel.GetFlagEffect(tp, AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) > 0 then mc_cos_val, c_cos_val, both_cos_val = 0, 0, 0 end
                    local mcg = VgF.GetMatchingGroup(mcfilter[mcv], tp, mc_cost_from, 0, c, e, tp)
                    local cg = VgF.GetMatchingGroup(cfilter[cv], tp, c_cost_from, 0, mc, e, tp)
                    local a = mcg:GetCount() < mc_cos_val
                    local b = cg:GetCount() < c_cos_val
                    if mc_cost_from == LOCATION_DAMAGE and Duel.GetFlagEffect(tp, 10402010) > 0 then
                        local c_10402010 = Duel.GetFlagEffectLabel(tp, 10402010)
                        if both_cos_val > c_10402010 then both_cos_val = both_cos_val - c_10402010
                        else both_cos_val = 0
                        end
                        if a then
                            if mc_cos_val - mcg:GetCount() <= c_10402010 then
                                a = false
                                c_10402010 = c_10402010 - (mc_cos_val - mcg:GetCount())
                            end
                        end
                        if b then
                            if c_cos_val - cg:GetCount() <= c_10402010 then
                                b = false
                                c_10402010 = c_10402010 - (c_cos_val - cg:GetCount())
                            end
                        end
                    end
                    --判断是否足够支付费用
                    if a or b then return false end
                    mcg:Merge(cg)
                    if mcg:GetCount() < both_cos_val then return false end
                    pos = mcv
                end
            end
            --如果合成了，则删去已合成的内容
            if pos > 0 then
                table.remove(mcfrom, pos)
                table.remove(mcval, pos)
                table.remove(mcfilter, pos)
            --如果没有合成，则在原费用上操作
            else
                local c_cos_val = cval[cv]
                if VgF.GetValueType(c_cos_val) ~= "number" then c_cos_val = 0 end
                --判断其他减少费用的效果
                if c_cost_from == LOCATION_OVERLAY and Duel.GetFlagEffect(tp, AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) > 0 then c_cos_val = 0 end
                if c_cost_from == LOCATION_DAMAGE and Duel.GetFlagEffect(tp, 10402010) > 0 then
                    local c_10402010 = Duel.GetFlagEffectLabel(tp, 10402010)
                    if c_cos_val > c_10402010 then c_cos_val = c_cos_val - c_10402010
                    else c_cos_val = 0
                    end
                end
                local cg = VgF.GetMatchingGroup(cfilter[cv], tp, c_cost_from, 0, mc, e, tp)
                if cg:GetCount() < c_cos_val then return false end
            end
        end
    --如果本体需要支付而合成的卡不需要支付
    elseif #mcfrom > 0 then
        for mcv = 1, #mcfrom do
            local mc_cost_from = VgF.ShiftLocationFromString(mcfrom[mcv])
            local mc_cos_val = mcval[mcv]
            if VgF.GetValueType(mc_cos_val) ~= "number" then mc_cos_val = 0 end
            --判断其他减少费用的效果
            if mc_cost_from == LOCATION_OVERLAY and Duel.GetFlagEffect(tp, AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) > 0 then mc_cos_val = 0 end
            local mcg = VgF.GetMatchingGroup(mcfilter[mcv], tp, mc_cost_from, 0, c, e, tp)
            if mc_cost_from == LOCATION_DAMAGE and Duel.GetFlagEffect(tp, 10402010) > 0 then
                local c_10402010 = Duel.GetFlagEffectLabel(tp, 10402010)
                if mc_cos_val > c_10402010 then mc_cos_val = mc_cos_val - c_10402010
                else mc_cos_val = 0
                end
            end
            --判断是否足够支付费用
            if mcg:GetCount() < mc_cos_val then return false end
        end
    --如果本体不需要支付而合成的卡需要支付
    elseif #cfrom > 0 then
        for cv = 1, #cfrom do
            local c_cost_from = VgF.ShiftLocationFromString(cfrom[cv])
            local c_cos_val = mcval[cv]
            if VgF.GetValueType(c_cos_val) ~= "number" then c_cos_val = 0 end
            --判断其他减少费用的效果
            if c_cost_from == LOCATION_OVERLAY and Duel.GetFlagEffect(tp, AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) > 0 then c_cos_val = 0 end
            local cg = VgF.GetMatchingGroup(cfilter[cv], tp, c_cost_from, 0, c, e, tp)
            if c_cost_from == LOCATION_DAMAGE and Duel.GetFlagEffect(tp, 10402010) > 0 then
                local c_10402010 = Duel.GetFlagEffectLabel(tp, 10402010)
                if c_cos_val > c_10402010 then c_cos_val = c_cos_val - c_10402010
                else c_cos_val = 0
                end
            end
            --判断是否足够支付费用
            if cg:GetCount() < c_cos_val then return false end
        end
    --都不需要支付
    else return true
    end
    return VgF.LvCondition(c)
end
function VgD.MixCostOperation(c, bc, tp)
    --得到需要支付的费用（从哪来，到哪去，最少几张卡，最多几张卡，什么卡）
    local cfrom, cto, cval, cval_max, cfilter, bcfrom, bcto, bcval, bcval_max, bcfilter
    table.copy(cfrom, c.cos_from)
    table.copy(cto, c.cos_to)
    table.copy(cval, c.cos_val)
    table.copy(cval_max, c.cos_val_max)
    table.copy(cfilter, bc.cos_filter)
    table.copy(bcfrom, bc.cos_from)
    table.copy(bcto, bc.cos_to)
    table.copy(bcval, bc.cos_val)
    table.copy(bcval_max, bc.cos_val_max)
    table.copy(bcfilter, bc.cos_filter)
    local g_from = {}
    local g_to = {}
    local g_filter_c = {}
    local g_filter_bc = {}
    local g_val_c = {}
    local g_val_bc = {}
    local g_val_c_max = {}
    local g_val_bc_max = {}
    local except_group = Group.FromCards(c, bc)
    --在这里合成
    if #bcfrom > 0 and #cfrom > 0 then
        for bcv = 1, #bcfrom do
            local bc_cost_from = VgF.ShiftLocationFromString(bcfrom[bcv])
            local pos = 0
            for cv = 1, #cfrom do
                local c_cost_from = VgF.ShiftLocationFromString(cfrom[cv])
                if bc_cost_from == c_cost_from and VgF.ShiftLocationFromString(cto[cv]) == VgF.ShiftLocationFromString(bcto[bcv]) then
                    pos = bcv
                    table.insert(g_from, cfrom[cv])
                    table.insert(g_to, cto[cv])
                    table.insert(g_filter_c, cfilter[cv])
                    table.insert(g_filter_bc, bcfilter[bcv])
                    if VgF.GetValueType(cval[cv]) == "number" then table.insert(g_val_c, cval[cv]) else table.insert(g_val_c, 0) end
                    if VgF.GetValueType(bcval[bcv]) == "number" then table.insert(g_val_bc, bcval[bcv]) else table.insert(g_val_bc, 0) end
                    if VgF.GetValueType(cval_max[cv]) == "number" then table.insert(g_val_c_max, cval_max[cv]) else table.insert(g_val_c_max, 0) end
                    if VgF.GetValueType(bcval_max[bcv]) == "number" then table.insert(g_val_bc_max, bcval_max[bcv]) else table.insert(g_val_bc_max, 0) end
                end
            end
            if pos > 0 then
                table.remove(bcfrom, pos)
                table.remove(bcto, pos)
                table.remove(bcval, pos)
                table.remove(bcval_max, pos)
                table.remove(bcfilter, pos)
            else
                table.insert(g_from, bcfrom[bcv])
                table.insert(g_to, bcto[bcv])
                table.insert(g_filter_c, VgF.False())
                table.insert(g_filter_bc, bcfilter[bcv])
                table.insert(g_val_c, 0)
                if VgF.GetValueType(bcval[bcv]) == "number" then table.insert(g_val_bc, bcval[bcv]) else table.insert(g_val_bc, 0) end
                table.insert(g_val_c_max, 0)
                if VgF.GetValueType(bcval_max[bcv]) == "number" then table.insert(g_val_bc_max, bcval_max[bcv]) else table.insert(g_val_bc_max, 0) end
            end
        end
    elseif #bcfrom > 0 then
        for bcv = 1, #bcfrom do
            table.insert(g_from, bcfrom[bcv])
            table.insert(g_to, bcto[bcv])
            table.insert(g_filter_c, VgF.False())
            table.insert(g_filter_bc, bcfilter[bcv])
            table.insert(g_val_c, 0)
            if VgF.GetValueType(bcval[bcv]) == "number" then table.insert(g_val_bc, bcval[bcv]) else table.insert(g_val_bc, 0) end
            table.insert(g_val_c_max, 0)
            if VgF.GetValueType(bcval_max[bcv]) == "number" then table.insert(g_val_bc_max, bcval_max[bcv]) else table.insert(g_val_bc_max, 0) end
        end
    elseif #cfrom > 0 then
        for cv = 1, #cfrom do
            table.insert(g_from, cfrom[cv])
            table.insert(g_to, cto[cv])
            table.insert(g_filter_c, cfilter[cv])
            table.insert(g_filter_bc, VgF.False())
            if VgF.GetValueType(cval[cv]) == "number" then table.insert(g_val_c, cval[cv]) else table.insert(g_val_c, 0) end
            table.insert(g_val_bc, 0)
            if VgF.GetValueType(cval_max[cv]) == "number" then table.insert(g_val_c_max, cval_max[cv]) else table.insert(g_val_c_max, 0) end
            table.insert(g_val_bc_max, 0)
        end
    end
    --开始支付合成完的费用
    for i = 1, #g_from do
        local tg_from = VgF.ShiftLocationFromString(g_from[i])
        local tg_to = VgF.ShiftLocationFromString(g_to[i])
        local tg = VgF.GetMatchingGroup(nil, tp, tg_from, 0, except_group)
        local tg_filter_c = g_filter_c[i]
        local tg_filter_bc = g_filter_bc[i]
        local tg_val_c = g_val_c[i]
        local tg_val_bc = g_val_bc[i]
        local tg_val_c_max = g_val_c_max[i]
        local tg_val_bc_max = g_val_bc_max[i]
        local hintmsg = HINTMSG_SELECT
        local ext_params = {}
        if tg_val_c_max < tg_val_c then tg_val_c_max = tg_val_c end
        if tg_val_bc_max < tg_val_bc then tg_val_bc_max = tg_val_bc end
        --判断其他减少费用的效果
        --继承的少女 亨德莉娜
        if tg_from == LOCATION_OVERLAY and Duel.GetFlagEffect(tp, AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) > 0 then
            if tg:GetCount() < tg_val_c + tg_val_bc or tg:FilterCount(tg_filter_c, nil) < tg_val_c or tg:FilterCount(tg_filter_bc, nil) < tg_val_bc then
                Duel.ResetFlagEffect(tp, AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX)
                goto continue
            elseif Duel.SelectYesNo(tp, VgF.Stringid(10401023, 1)) then
                Duel.ResetFlagEffect(tp, AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX)
                goto continue
            end
        end
        --鬼首狩灵
        if tg_from == LOCATION_DAMAGE and Duel.GetFlagEffect(tp, 10402010) > 0 then
            local c_10402010 = Duel.GetFlagEffectLabel(tp, 10402010)
            local filter_count_c = tg:FilterCount(tg_filter_c, nil)
            local filter_count_bc = tg:FilterCount(tg_filter_bc, nil)
            if filter_count_c < tg_val_c and tg_val_c - filter_count_c <= c_10402010 then
                c_10402010 = c_10402010 - (tg_val_c - filter_count_c)
                tg_val_c = filter_count_c
            end
            if filter_count_bc < tg_val_bc and tg_val_bc - filter_count_bc <= c_10402010 then
                c_10402010 = c_10402010 - (tg_val_bc - filter_count_bc)
                tg_val_bc = filter_count_bc
            end
            if filter_count_c < tg_val_c or filter_count_bc < tg_val_bc then
                Debug.Message("There is a value error in mixing costs")
                goto continue
            else Duel.ResetFlagEffect(tp, 10402010)
            end
        end
        if tg:GetCount() < tg_val_c + tg_val_bc then goto continue end
        if VgF.GetValueType(tg_to) == "number" then
            if tg_to == LOCATION_DROP then
                if tg_from == LOCATION_MZONE then
                    hintmsg = HINTMSG_LEAVEFIELD
                elseif tg_from == LOCATION_OVERLAY then hintmsg = HINTMSG_REMOVEXYZ
                else hintmsg = HINTMSG_TODROP end
                ext_params = {REASON_COST}
            elseif bit.band(tg_to, LOCATION_LOCK) > 0 then
                hintmsg = HINTMSG_LOCK
                if bit.band(tg_to, POS_FACEUP) > 0 then ext_params = {POS_FACEUP, REASON_COST} end
                if bit.band(tg_to, POS_FACEDOWN) > 0 then ext_params = {POS_FACEDOWN, REASON_COST} end
            elseif bit.band(tg_to, LOCATION_EXILE) > 0 then
                hintmsg = HINTMSG_REMOVE
                if bit.band(tg_to, POS_FACEUP) > 0 then ext_params = {tp, POS_FACEUP, REASON_COST} end
                if bit.band(tg_to, POS_FACEDOWN) > 0 then ext_params = {tp, POS_FACEDOWN, REASON_COST} end
            elseif tg_to == LOCATION_DECK then
                hintmsg = HINTMSG_TODECK
                ext_params = {tp, SEQ_DECKSHUFFLE, REASON_COST}
            elseif tg_to == LOCATION_HAND then
                hintmsg = HINTMSG_ATOHAND
                ext_params = {nil, REASON_COST}
            elseif tg_to == LOCATION_OVERLAY then
                hintmsg = HINTMSG_XMATERIAL
                ext_params = {VgF.GetVMonster(tp)}
            end
        elseif VgF.GetValueType(tg_to) == "string" and tg_to == "POSCHANGE" then hintmsg = HINTMSG_POSCHANGE
        end
        Duel.Hint(HINT_SELECTMSG, tp, hintmsg)
        local sg = tg:SelectDoubleSubGroup(tp, tg_filter_c, tg_val_c, tg_val_c_max, tg_filter_bc, tg_val_bc, tg_val_bc_max, Group.FromCards(c, bc))
        if VgF.GetValueType(tg_to) == "string" and tg_to == "POSCHANGE" and tg_from == LOCATION_DAMAGE then Duel.ChangePosition(sg, POS_FACEDOWN_ATTACK, POS_FACEUP_ATTACK)
        elseif VgF.GetValueType(tg_to) == "string" and tg_to == "POSCHANGE" and tg_from ~= LOCATION_DAMAGE then Duel.ChangePosition(sg, POS_FACEUP_DEFENCE, POS_FACEDOWN_ATTACK, POS_FACEUP_ATTACK, POS_FACEDOWN_DEFENCE)
        elseif VgF.GetValueType(tg_to) == "number" then VgF.Sendto(tg_to, sg, table.unpack(ext_params))
        end
        ::continue::
    end
end
function VgD.SpellTarget(e, tp, eg, ep, ev, re, r, rp, chk)
    local ct1 = Duel.GetFlagEffectLabel(tp, FLAG_SPELL_COUNT_LIMIT) or 1
    local ct2 = Duel.GetFlagEffectLabel(tp, FLAG_SPELL_USED_COUNT) or 0
    if chk == 0 then return ct2 < ct1 end
    Duel.RegisterFlagEffect(tp, FLAG_SPELL_USED_COUNT, RESET_PHASE + PHASE_END, 0, 1, ct2 + 1)
end
function VgD.SpellOperation(op)
    return function(e, tp, eg, ep, ev, re, r, rp, no_alchemagic)
        if op then op(e, tp, eg, ep, ev, re, r, rp, true) end
        local mc = e:GetLabelObject()
        if no_alchemagic or not mc then return end
        local alchemagic_op = mc:GetActivateEffect():GetOperation()
        if alchemagic_op then alchemagic_op(e, tp, eg, ep, ev, re, r, rp, true) end
    end
end

---使卡片可以作为闪现指令卡发动
---@param c Card 要注册闪现指令卡功能的卡
---@param op function|nil 作为指令卡的效果
---@param cost function|nil 作为指令卡的发动费用
---@param con function|nil 作为指令卡的发动条件
---@param tg function|nil 作为指令卡的发动检查
---@return Effect 这个效果
function VgD.QuickSpell(c, op, cost, con, tg)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("QuickSpell")
    if fchk.con(con) or fchk.cost(cost) or fchk.tg(tg) or fchk.op(op) then return end
    -- set param
    local condition = function(e, tp, eg, ep, ev, re, r, rp)
        local bc = Duel.GetAttackTarget()
        return bc and bc:IsControler(tp) and VgD.SpellCondtion(con)(e, tp, eg, ep, ev, re, r, rp)
    end
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_ACTIVATE)
    e:SetCode(EVENT_BATTLE_START)
    e:SetCondition(condition)
    if cost then e:SetCost(cost) end
    if tg then e:SetTarget(tg) end
    if op then e:SetOperation(op) end
    c:RegisterEffect(e)
    return e
end

---使卡片可以作为设置指令卡发动
---@param c Card 要注册设置指令卡功能的卡
---@param cost function|nil 作为指令卡的发动费用
---@param con function|nil 作为指令卡的发动条件
---@param tg function|nil 作为指令卡的发动检查
---@return Effect 这个效果
function VgD.ContinuousSpell(c, cost, con, tg)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("ContinuousSpell")
    if fchk.con(con) or fchk.cost(cost) or fchk.tg(tg) then return end
    -- set param
    local operation = function(e, tp, eg, ep, ev, re, r, rp)
        VgF.Sendto(LOCATION_ORDER, e:GetHandler(), tp, POS_FACEUP_ATTACK, REASON_RULE)
    end
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_ACTIVATE)
    e:SetCode(EVENT_FREE_CHAIN)
    e:SetCountLimit(1, VgID + EFFECT_COUNT_CODE_OATH)
    e:SetCondition(VgD.SpellCondtion(con))
    if cost then e:SetCost(cost) end
    if tg then e:SetTarget(tg) end
    e:SetOperation(operation)
    c:RegisterEffect(e)
    return e
end

--自相关----------------------------------------------------------------------------------------

---【自】效果模板：当单位在loc时，code时点被触发时执行的效果
---@param c Card 拥有这个效果的卡 
---@param m number|nil 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param loc number 可以发动的区域
---@param typ number 若是自己状态变化引发，则填EFFECT_TYPE_SINGLE；<br>若是场上任意一卡状态变化引发，则填EFFECT_TYPE_FIELD。
---@param code number 触发的时点
---@param op function|nil 这个效果的处理函数
---@param cost function|nil 这个效果的费用函数
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的检查函数
---@param count number|nil 同一回合内最多发动的次数
---@param property number|nil 这个效果的特殊属性。
---@param id number|nil 提示脚本的卡号索引
---@return Effect 这个效果
function VgD.EffectTypeTrigger(c, m, loc, typ, code, op, cost, con, tg, count, property, id)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("EffectTypeTrigger")
    if fchk.con(con) or fchk.cost(cost) or fchk.tg(tg) or fchk.op(op) then return end
    -- set param
    m = m or c:GetOriginalCode()
    _G["c"..m].is_has_trigger = true
    typ = (typ or EFFECT_TYPE_SINGLE) + (cost and EFFECT_TYPE_TRIGGER_O or EFFECT_TYPE_TRIGGER_F)
    loc, con = VgF.GetLocCondition(loc, con)
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetDescription(VgF.Stringid(VgID + 1, id or 1))
    e:SetType(typ)
    e:SetCode(code)
    e:SetRange(loc)
    e:SetProperty((property or 0) + EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    if count then e:SetCountLimit(count) end
    e:SetCondition(con)
    if cost then e:SetCost(cost) end
    if tg then e:SetTarget(tg) end
    if op then e:SetOperation(op) end
    c:RegisterEffect(e)
    return e
end

---【自】攻击击中时触发
---@param c Card 拥有这个效果的卡 
---@param m number|nil 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param loc number 可以发动的区域
---@param typ number 若是自己状态变化引发，则填EFFECT_TYPE_SINGLE；<br>若是场上任意一卡状态变化引发，则填EFFECT_TYPE_FIELD
---@param op function|nil 这个效果的处理函数
---@param cost function|nil 这个效果的费用函数
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的检查函数
---@param count number|nil 同一回合内最多发动的次数
---@param p number|nil 被击中的卡的控制者
---@param property number|nil 这个效果的特殊属性。
---@param id number|nil 提示脚本的卡号索引
---@return Effect 这个效果 *回传两个效果*
function VgD.EffectTypeTriggerWhenHitting(c, m, loc, typ, op, cost, con, tg, count, p, property, id)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("EffectTypeTriggerWhenHitting")
    if fchk.con(con) or fchk.cost(cost) or fchk.tg(tg) or fchk.op(op) then return end
    -- set param
    typ = typ or EFFECT_TYPE_SINGLE 
    -- set effect
    local e1 = VgD.EffectTypeTrigger(c, m, loc, typ, EVENT_BATTLE_DESTROYING, op, cost, con, tg, count, property, id)
    local e2 = VgD.EffectTypeTrigger(c, m, loc, EFFECT_TYPE_FIELD, EVENT_CUSTOM + EVENT_DAMAGE_TRIGGER, op, cost, VgD.EffectTypeTriggerWhenHittingCon(typ, con, p), tg, count, property, id)
    return e1, e2
end
function VgD.EffectTypeTriggerWhenHittingCon(typ, con, p)
    return function (e, tp, eg, ep, ev, re, r, rp)
        if con and not con(e, tp, eg, ep, ev, re, r, rp) then return false end
        if eg:GetFirst():IsControler(p or e:GetOwner():GetControl()) then return false end
        return typ == EFFECT_TYPE_FIELD or Duel.GetAttacker() == e:GetHandler()
    end
end

---【自】这个单位被放置到G时触发
---@param c Card 拥有这个效果的卡
---@param m number|nil 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param op function|nil 这个效果的处理函数
---@param cost function|nil 这个效果的费用函数
---@param con function|nil 这个效果的条件函数
---@return Effect 这个效果
function VgD.CardToG(c, m, op, cost, con)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("CardToG")
    if fchk.con(con) or fchk.cost(cost) or fchk.op(op) then return end
    -- set param
    m = m or c:GetOriginalCode()
    _G["c"..m].is_has_trigger = true
    local typ = cost and EFFECT_TYPE_TRIGGER_O or EFFECT_TYPE_TRIGGER_F 
    op = op or VgD.CardToGOperation
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetDescription(VgF.Stringid(VgID, 2))
    e:SetType(EFFECT_TYPE_SINGLE + typ)
    e:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_DAMAGE_STEP)
    e:SetCode(EVENT_MOVE)
    if cost then e:SetCost(cost) end
    e:SetCondition(VgD.CardToGCondition(con))
    e:SetOperation(op)
    c:RegisterEffect(e)
    return e
end
function VgD.CardToGCondition(con)
    return function(e, tp, eg, ep, ev, re, r, rp)
        return (not con or con(e, tp, eg, ep, ev, re, r, rp)) and e:GetHandler():IsLocation(LOCATION_GZONE) and Duel.GetAttackTarget()
    end
end
function VgD.CardToGOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetAttackTarget()
    if vgf.RMonsterFilter(tc) then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
        vgf.EffectReset(c, e1, EVENT_BATTLED)
    elseif vgf.VMonsterFilter(tc) then
        tc:RegisterFlagEffect(FLAG_DEFENSE_ENTIRELY, RESET_EVENT + RESETS_STANDARD, 0, 1)
    end
end

---【自】这个单位被 Ride 时触发
---@param c Card 被Ride的卡
---@param m number|nil 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param filter number|nil Ride c 的卡
---@param op function|nil 这个效果的处理函数
---@param cost function|nil 这个效果的费用函数
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的检查函数
---@param id number|nil 提示脚本的卡号索引
---@return Effect 这个效果
function VgD.BeRidedByCard(c, m, filter, op, cost, con, tg, id)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("BeRidedByCard")
    if fchk.con(con) or fchk.cost(cost) or fchk.tg(tg) or fchk.op(op) then return end
    -- set param
    m = m or c:GetOriginalCode()
    _G["c"..m].is_has_trigger = true
    local desc = VgF.Stringid(m, id or 2)
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e:SetCode(EVENT_BE_MATERIAL)
    e:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e:SetCondition(VgD.BeRidedByCardCondition(con, filter))
    e:SetOperation(VgD.BeRidedByCardOperation(desc, op, cost, tg))
    c:RegisterEffect(e)
    return e
end
function VgD.BeRidedByCardCondition(con, filter)
    return function (e, tp, eg, ep, ev, re, r, rp)
        if r ~= REASON_RIDEUP or (con and not con(e, tp, eg, ep, ev, re, r, rp)) then return false end
        local c, rc = e:GetHandler(), e:GetHandler():GetReasonCard()
        filter = filter or vgf.True
        if type(filter) == "number" then 
            filter = function(c, rc)
                return rc:IsCode(filter)
            end 
        end
        return filter(c:GetReasonCard(), c)
    end
end
function VgD.BeRidedByCardOperation(desc, op, cost, tg)
    return function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local rc = c:GetReasonCard()
        local typ = cost and EFFECT_TYPE_TRIGGER_O or EFFECT_TYPE_TRIGGER_F 
        local e = Effect.CreateEffect(rc)
        e:SetDescription(desc)
        e:SetType(typ + EFFECT_TYPE_FIELD)
        e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_IGNORE_IMMUNE)
        e:SetCode(EVENT_SPSUMMON_SUCCESS)
        e:SetLabelObject(c)
        e:SetRange(LOCATION_MZONE)
        e:SetCondition(VgD.BeRidedByCardOpCondtion)
        if cost then e:SetCost(cost) end
        if tg then e:SetTarget(tg) end
        if op then e:SetOperation(op) end
        e:SetReset(RESET_EVENT + RESETS_STANDARD)
        rc:RegisterEffect(e)
    end
end
function VgD.BeRidedByCardOpCondtion(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetLabelObject()
    return eg:GetFirst() == e:GetHandler() and e:GetHandler():GetOverlayGroup():IsContains(c)
end

--起相关----------------------------------------------------------------------------------------

---【起】效果模板：当单位在loc时，可以发动的【起】效果
---@param c Card 要触发效果的卡 
---@param m number|nil 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param loc number 可以发动的区域
---@param op function|nil 这个效果的处理函数
---@param cost function|nil 这个效果的费用函数
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的检查函数
---@param count number|nil 同一回合内最多发动的次数
---@param property number|nil 这个效果的特殊属性。
---@param id number|nil 提示脚本的卡号索引
---@return Effect 这个效果
function VgD.EffectTypeIgnition(c, m, loc, op, cost, con, tg, count, property, id)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("EffectTypeIgnition")
    if fchk.con(con) or fchk.cost(cost) or fchk.tg(tg) or fchk.op(op) then return end
    -- set param
    m = m or c:GetOriginalCode()
    _G["c"..m].is_has_ignition = true
    loc, con = VgF.GetLocCondition(loc, con)
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetDescription(VgF.Stringid(VgID + 2, id or 1))
    e:SetType(EFFECT_TYPE_IGNITION)
    e:SetRange(loc)
    if property then e:SetProperty(property) end
    if count then e:SetCountLimit(count) end
    e:SetCondition(con)
    if cost then e:SetCost(cost) end
    if tg then e:SetTarget(tg) end
    if op then e:SetOperation(op) end
    c:RegisterEffect(e)
    return e
end

--永相关----------------------------------------------------------------------------------------

---【永】效果模板
---@param c Card 效果的创建者
---@param m number|nil 效果的创建者的卡号
---@param loc number 生效的区域
---@param typ number 只影响自己，则填EFFECT_TYPE_SINGLE；<br>影响场上，则填EFFECT_TYPE_FIELD。
---@param code number 触发的效果
---@param val number 触发的效果的数值
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的影响目标(全域)
---@param loc_self number|nil 这个效果影响的自己区域，影响全域范围才需填
---@param loc_op number|nil 这个效果影响的对方区域，影响全域范围才需填
---@param reset number|nil 效果的重置条件
---@param hc Card|nil 效果的拥有者, 没有则为 c
---@return Effect 这个效果
function VgD.EffectTypeContinuous(c, m, loc, typ, code, val, con, tg, loc_self, loc_op, reset, hc)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("EffectTypeContinuous")
    if fchk.con(con) or fchk.tg(tg) then return end
    -- set param
    local cm = _G["c"..(m or c:GetOriginalCode())]
    cm.is_has_continuous = cm.is_has_continuous or not reset
    loc, con = VgF.GetLocCondition(loc, con)
    hc = hc or c
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetType(typ or EFFECT_TYPE_SINGLE)
    e:SetCode(code)
    e:SetRange(loc)
    if typ == EFFECT_TYPE_FIELD then e:SetTargetRange(loc_self or 0, loc_op or 0) end
    e:SetCondition(con)
    e:SetValue(val)
    if tg then e:SetTarget(tg) end
    if reset then e:SetReset(RESET_EVENT + RESETS_STANDARD + reset) end
    hc:RegisterEffect(e)
    return e
end

---【永】力量数值变更
---@param c Card 效果的创建者
---@param m number|nil 效果的创建者的卡号
---@param loc number 生效的区域
---@param typ number 只影响自己，则填EFFECT_TYPE_SINGLE；<br>影响场上，则填EFFECT_TYPE_FIELD。
---@param val number 变更的数值
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的影响目标(全域)
---@param loc_self number|nil 这个效果影响的自己区域，影响全域范围才需填
---@param loc_op number|nil 这个效果影响的对方区域，影响全域范围才需填
---@param reset number|nil 效果的重置条件
---@param hc Card|nil 效果的拥有者, 没有则为 c
---@return Effect 这个效果
function VgD.EffectTypeContinuousChangeAttack(c, m, loc, typ, val, con, tg, loc_self, loc_op, reset, hc)
    return VgD.EffectTypeContinuous(c, m, loc, typ, EFFECT_UPDATE_ATTACK, val, con, tg, loc_self, loc_op, reset, hc)
end

---【永】盾护数值变更
---@param c Card 效果的创建者
---@param m number|nil 效果的创建者的卡号
---@param typ number 只影响自己，则填EFFECT_TYPE_SINGLE；<br>影响场上，则填EFFECT_TYPE_FIELD。
---@param val number 变更的数值
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的影响目标(全域)
---@param loc_self number|nil 这个效果影响的自己区域，影响全域范围才需填
---@param loc_op number|nil 这个效果影响的对方区域，影响全域范围才需填
---@param reset number|nil 效果的重置条件
---@param hc Card|nil 效果的拥有者, 没有则为 c
---@return Effect 这个效果
function VgD.EffectTypeContinuousChangeDefense(c, m, typ, val, con, tg, loc_self, loc_op, reset, hc)
    return VgD.EffectTypeContinuous(c, m, LOCATION_GZONE, typ, EFFECT_UPDATE_DEFENSE, val, con, tg, loc_self, loc_op, reset, hc)
end

---【永】暴击数值变更
---@param c Card 效果的创建者
---@param m number|nil 效果的创建者的卡号
---@param typ number 只影响自己，则填EFFECT_TYPE_SINGLE；<br>影响场上，则填EFFECT_TYPE_FIELD。
---@param val number 变更的数值
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的影响目标(全域)
---@param loc_self number|nil 这个效果影响的自己区域，影响全域范围才需填
---@param loc_op number|nil 这个效果影响的对方区域，影响全域范围才需填
---@param reset number|nil 效果的重置条件
---@param hc Card|nil 效果的拥有者, 没有则为 c
---@return Effect 两个效果
function VgD.EffectTypeContinuousChangeStar(c, m, typ, val, con, tg, loc_self, loc_op, reset, hc)
    local e1 = VgD.EffectTypeContinuous(c, m, LOCATION_MZONE, typ, EFFECT_UPDATE_LSCALE, val, con, tg, loc_self, loc_op, reset, hc)
    local e2 = VgD.EffectTypeContinuous(c, m, LOCATION_MZONE, typ, EFFECT_UPDATE_RSCALE, val, con, tg, loc_self, loc_op, reset, hc)
    return e1, e2
end

---【永】驱动数值变更
---@param c Card 效果的创建者
---@param m number|nil 效果的创建者的卡号
---@param num number 变更的数值
---@param con function|nil 这个效果的条件函数
---@param reset number|nil 效果的重置条件
---@param hc Card|nil 效果的拥有者, 没有则为 c
---@return Effect 这个效果
function VgD.TriggerCountUp(c, m, num, con, reset, hc)
    -- check func
    if VgF.IllegalFunctionCheck("TriggerCountUp").con(con) then return end
    -- set param
    local cm = _G["c"..(m or c:GetOriginalCode())]
    cm.is_has_continuous = cm.is_has_continuous or not reset
    local condition = function(e, tp, eg, ep, ev, re, r, rp)
        return (not con or con(e, tp, eg, ep, ev, re, r, rp)) and VgF.ReturnCard(eg) == e:GetHandler()
    end
    hc = hc and VgF.ReturnCard(hc) or c
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e:SetRange(LOCATION_MZONE)
    e:SetCode(EVENT_CUSTOM + EVENT_TRIGGERCOUNTUP)
    e:SetProperty(EFFECT_FLAG_DELAY)
    e:SetCondition(condition)
    if reset then e:SetReset(RESET_EVENT + RESETS_STANDARD + reset) end
    e:SetOperation(VgD.TriggerCountUpOperation(num))
    hc:RegisterEffect(e)
    return e
end
function VgD.TriggerCountUpOperation(num)
    return function (e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local label = c:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER)
        if not label then label = 0 end
        label = label + num
        if label < 0 then label = 0 end
        c:ResetFlagEffect(FLAG_ATTACK_TRIGGER)
        c:RegisterFlagEffect(FLAG_ATTACK_TRIGGER, RESET_EVENT + RESETS_STANDARD, 0, 1, label)
    end
end

---【永】这个单位不会被对手的卡片的效果选择
---@param c Card 拥有这个效果的卡
---@param m number|nil 效果的拥有者的卡号
---@param loc number 生效的区域
---@param typ number 只影响自己，则填EFFECT_TYPE_SINGLE；<br>影响场上，则填EFFECT_TYPE_FIELD。
---@param val number 不会被 val 的效果选择
---@param con function|nil 这个效果的条件函数
---@param tg function|nil 这个效果的影响目标，影响全域范围才需填
---@param loc_self number|nil 这个效果影响的自己区域，影响全域范围才需填
---@return Effect 这个效果
function VgD.CannotBeTarget(c, m, loc, typ, val, con, tg, loc_self)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("CannotBeTarget")
    if fchk.con(con) or fchk.tg(tg) then return end
    -- set param
    local cm = _G["c"..(m or c:GetOriginalCode())]
    cm.is_has_continuous = true
    typ = typ or EFFECT_TYPE_SINGLE 
    loc, con = VgF.GetLocCondition(loc, con)
    val = val or function(e, re, rp)
        return rp == 1 - e:GetHandlerPlayer()
    end
    -- set effect
    local e = Effect.CreateEffect(c)
    e:SetRange(loc)
    e:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e:SetCondition(con)
    e:SetValue(val)
    if typ == EFFECT_TYPE_FIELD or tg or loc_self then
        e:SetType(EFFECT_TYPE_FIELD)
        e:SetTargetRange(loc_self or LOCATION_MZONE , 0)
        if tg then e:SetTarget(tg) end
    else
        e:SetType(EFFECT_TYPE_SINGLE)
        e:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    end
    c:RegisterEffect(e)
    return e
end

---【永】【指令区】：你的指令区中没有世界卡以外的设置指令卡的话，根据你的指令区中的卡的张数生效以下全部的效果。
---●1张——你的世界卡的内容变为黑夜。
---●2张以上——你的世界卡的内容变为深渊黑夜。
---@param c Card 要注册以上功能的卡
---@param m number|nil 效果的创建者的卡号
---@return Effect 两个效果
function VgD.NightEffect(c, m)
    -- set param
    local cm = _G["c"..(m or c:GetOriginalCode())]
    cm.is_has_continuous = true
    local condition = function(equl_one)
        return function(e)
            local og = vgf.GetMatchingGroup(nil, e:GetHandlerPlayer(), LOCATION_ORDER, 0, nil)
            if og:IsExists(VgD.NightFilter, 1, nil) then return false end
            if equl_one then return #og == 1 end
            return #og >= 2
        end
    end
    -- set effect
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(AFFECT_CODE_NIGHT)
    e1:SetRange(LOCATION_ORDER)
    e1:SetTargetRange(1, 0)
    e1:SetCondition(condition(true))
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(AFFECT_CODE_DEEP_NIGHT)
    e2:SetCondition(condition(false))
    c:RegisterEffect(e2)
    return e1, e2
end
function VgD.NightFilter(c)
    return not c:IsSetCard(0x5040) and c:IsType(TYPE_CONTINUOUS)
end

---【永】【指令区】：对手在可以将后防者通常CALL出场的时段，对手可以将以下的效果执行。
---●灵魂爆发1。这样做了的话，选择被收容的他自己的1张卡，CALL到他自己的R上。
---●计数爆发1。这样做了的话，选择被收容的他自己的2张卡，CALL到他自己的R上。
---@param c Card 要注册以上功能的卡
---@param m number|nil 效果的创建者的卡号
---@return Effect 两个效果
function VgD.CallInPrison(c, m)
    -- set param
    local cm = _G["c"..(m or c:GetOriginalCode())]
    cm.is_has_continuous = true
    -- set effect
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(VgF.Stringid(VgID, 11))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC_G)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_BOTH_SIDE)
    e1:SetRange(LOCATION_ORDER)
    e1:SetCondition(VgD.CallInPrisonCondition(1))
    e1:SetOperation(VgD.CallInPrisonOperation(1))
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetDescription(VgF.Stringid(VgID, 12))
    e2:SetCondition(VgD.CallInPrisonCondition(2))
    e2:SetOperation(VgD.CallInPrisonOperation(2))
    c:RegisterEffect(e2)
    return e1, e2
end
function VgD.CallInPrisonCondition(val)
    return function (e, c, og)
        local tp = 1 - e:GetHandlerPlayer()
        local eg, ep, ev, re, r, rp
        if Duel.GetTurnPlayer() == e:GetHandlerPlayer() then return false end
        if val == 1 then
            return (VgF.OverlayCost(1)(e, tp, eg, ep, ev, re, r, rp, 0) and VgF.IsExistingMatchingCard(VgD.CallInPrisonFilter, tp, LOCATION_HAND, 0, 1, nil, e, tp))
        elseif val == 2 then
            return (VgF.DamageCost(1)(e, tp, eg, ep, ev, re, r, rp, 0) and VgF.IsExistingMatchingCard(VgD.CallInPrisonFilter, tp, LOCATION_HAND, 0, 2, nil, e, tp))
        end
    end
end
function VgD.CallInPrisonOperation(val)
    return function(e, tp, eg, ep, ev, re, r, rp, c, sg, og)
        if val == 1 then
            VgF.OverlayCost(1)(e, tp, eg, ep, ev, re, r, rp, 1)
            local g = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, VgD.CallInPrisonFilter, tp, LOCATION_ORDER, 0, 1, 1, nil, e, tp)
            if g:GetFirst():IsType(TYPE_MONSTER) then
                VgF.Sendto(LOCATION_MZONE, g, 0, tp)
            else
                VgF.Sendto(LOCATION_DROP, g, REASON_EFFECT)
            end
        elseif val == 2 then
            VgF.DamageCost(1)(e, tp, eg, ep, ev, re, r, rp, 1)
            local tg = VgF.SelectMatchingCard(HINTMSG_CALL, e, tp, VgD.CallInPrisonFilter, tp, LOCATION_ORDER, 0, 2, 2, nil, e, tp)
            local g = tg:Filter(Card.IsType, nil, TYPE_MONSTER)
            if g:GetCount() > 0 then
                VgF.Sendto(LOCATION_MZONE, g, 0, tp)
                tg:Sub(g)
            end
            if tg:GetCount() > 0 then
                VgF.Sendto(LOCATION_DROP, tg, REASON_EFFECT)
            end
        end
        sg = Group.CreateGroup()
        Duel.AdjustAll()
    end
end
function VgD.CallInPrisonFilter(c, e, tp)
    return c:GetFlagEffect(FLAG_IMPRISON) > 0 and (vgf.IsCanBeCalled(c, e, tp) or not c:IsType(TYPE_MONSTER))
end

--其他----------------------------------------------------------------------------------------

---建立一个全局检查
---@param c Card 效果的创建者
---@param m number|nil 效果的创建者的卡号
---@param code number 触发的时点
---@param op function|nil 这个效果的处理函数
---@param con function|nil 这个效果的条件函数
function VgD.GlobalCheckEffect(c, m, code, con, op)
    -- check func
    local fchk = VgF.IllegalFunctionCheck("GlobalCheckEffect")
    if fchk.con(con) or fchk.op(op) then return end
    -- set param and check global
    m = m or c:GetOriginalCode()
    local cm = _G["c"..m]
    cm.global_check = cm.global_check or {}
    cm.global_check[code] = cm.global_check[code] or {}
    local code_tab = cm.global_check[code]
    local key, tab = next(code_tab)
    if next(code_tab) then
        while key do
            if tab.con == con and tab.op == op then return end
            key, tab = next(code_tab, key)
        end
    end
    cm.global_check[code][#code_tab + 1] = {con = con, op = op}
    op = op or function(e, tp, eg, ep, ev, re, r, rp)
        Duel.RegisterFlagEffect(rp, m, RESET_PHASE + PHASE_END, 0, 1)
    end
    -- set effect
    Debug.Message("set")
    local ge = Effect.CreateEffect(c)
    ge:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    ge:SetCode(code)
    if con then ge:SetCondition(con) end
    ge:SetOperation(op)
    Duel.RegisterEffect(ge, 0)
end