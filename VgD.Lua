VgD={}
vgd=VgD

--骑升
function VgD.RideUp(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetCountLimit(1,VgID)
    e1:SetRange(LOCATION_ALL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCondition(VgD.RideZeroCondition)
    e1:SetOperation(VgD.RideZeroOperation)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_ALL)
    e2:SetCountLimit(1,VgID+1)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCondition(VgD.RideUpCondition)
    e2:SetOperation(VgD.RideUpOperation)
	c:RegisterEffect(e2)
end
function VgD.RideUpMaterialCheck(c,rc)
    if VgF.GetValueType(c.ride_material_code_chk)=="nil" and VgF.GetValueType(c.ride_material_setcard_chk)=="nil" then return true end
    if VgF.GetValueType(c.ride_material_code_chk)=="number" then
        if VgF.GetValueType(rc.ride_code)=="number" and c.ride_material_code_chk==rc.ride_code then return true
        elseif VgF.GetValueType(rc.ride_code)=="tabel" then
            for code in ipairs(rc.ride_code) do
                if c.ride_material_code_chk==code then return true end
            end
        end
        return c.ride_material_code_chk==rc:GetCode()
    elseif VgF.GetValueType(c.ride_material_code_chk)=="tabel" then
        for i in ipairs(c.ride_material_code_chk) do
            if VgF.GetValueType(rc.ride_code)=="number" and i==rc.ride_code then return true
            elseif VgF.GetValueType(rc.ride_code)=="tabel" then
                for code in ipairs(rc.ride_code) do
                    if i==code then return true end
                end
            end
            if rc:IsCode(i) then return true end
        end
    end
    if VgF.GetValueType(c.ride_material_setcard_chk)=="number" then
        if VgF.GetValueType(rc.ride_setcard)=="number" and c.ride_material_setcard_chk==rc.ride_setcard then return true
        elseif VgF.GetValueType(rc.ride_setcard)=="tabel" then
            for setcard in ipairs(rc.ride_setcard) do
                if c.ride_material_code_chk==setcard then return true end
            end
        end
        return rc:IsSetCard(c.ride_material_setcard_chk)
    elseif VgF.GetValueType(c.ride_material_setcard_chk)=="tabel" then
        for i in ipairs(c.ride_material_setcard_chk) do
            if VgF.GetValueType(rc.ride_setcard)=="number" and i==rc.ride_setcard then return true
            elseif VgF.GetValueType(rc.ride_setcard)=="tabel" then
                for setcard in ipairs(rc.ride_setcard) do
                    if i==setcard then return true end
                end
            end
            if rc:IsSetCard(i) then return true end
        end
    end
    return false
end
function VgD.RideUpFilter1(c,lv,code,rc)
    local tp=c:GetControler()
    if not c:IsType(TYPE_MONSTER) then return false end
    if rc:IsAttribute(SKILL_SELF_RIDE) and c:IsCode(code) then return false end
    if (c:IsLevel(lv,lv+1) and c:IsLocation(LOCATION_HAND)) then return VgD.RideUpMaterialCheck(c,rc) end
    if (c:IsLevel(lv+1) and c:IsLocation(LOCATION_RIDE) and (VgF.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_OVERLAY_INSTEAD_WHEN_RIDE) and VgF.GetVMonster(tp):GetOverlayCount()>0))) then return VgD.RideUpMaterialCheck(c,rc) end
    return false
end
function VgD.DisCardRideUpFilter(c,e,lv,code,rc)
    local tp=c:GetControler()
    return c:IsDiscardable() and VgF.IsExistingMatchingCard(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,1,c,lv,code,rc)
end
function VgD.RideUpFilter2(c,lv,code,rc)
    return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsCode(code) and rc:IsAttribute(SKILL_SELF_RIDE)
end
function VgD.RideUpCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return false end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,lv,code,rc)
    local rg2=Duel.GetMatchingGroup(VgD.RideUpFilter2,tp,LOCATION_HAND,0,nil,lv,code,rc)
    local a=rg1:GetCount()>0
    local b=rg2:GetCount()>0
    return Duel.GetTurnPlayer()==tp and VgF.RuleCardCondtion(e) and (a or b)
end
function VgD.RideUpOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=VgF.GetVMonster(tp)
    if not rc then return end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,lv,code,rc)
    local rg2=Duel.GetMatchingGroup(VgD.RideUpFilter2,tp,LOCATION_HAND,0,nil,lv,code,rc)
    local a=rg1:GetCount()>0
    local b=rg2:GetCount()>0
    local off=1
    local ops={}
    if a then
        ops[off]=VgF.Stringid(VgID,3)
        off=off+1
    end
    if b then
        ops[off]=VgF.Stringid(VgID,4)
        off=off+1
    end
    ops[off]=VgF.Stringid(VgID,5)
    local sel=Duel.SelectOption(tp,table.unpack(ops))
    if sel==0 and a then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
        local sg=rg1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_HAND+LOCATION_RIDE)
        local sc=sg:GetFirst()
        if sc:IsLocation(LOCATION_EXTRA) then
            if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_OVERLAY_INSTEAD_WHEN_RIDE) and Duel.SelectYesNo(tp,VgF.Stringid(VgID,14)) then
                VgF.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,1)
            else
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
                local g=Duel.SelectMatchingCard(tp,VgD.DisCardRideUpFilter,tp,LOCATION_HAND,0,1,1,nil,e,lv,code,rc)
                VgF.Sendto(LOCATION_DROP,g,REASON_COST+REASON_DISCARD)
            end
        end
        local mg=rc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            VgF.Sendto(LOCATION_OVERLAY,mg,sc)
        end
        sc:SetMaterial(Group.FromCards(rc))
        VgF.Sendto(LOCATION_OVERLAY,Group.FromCards(rc),sc)
        VgF.Sendto(LOCATION_MZONE,sc,SUMMON_TYPE_RIDE,tp,0x20)
        if VgF.IsExistingMatchingCard(Card.IsType,tp,LOCATION_RIDE,0,1,nil,TYPE_EMBLEM) then
            local tc=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_RIDE,0,nil,TYPE_EMBLEM):GetFirst()
            VgF.Sendto(LOCATION_EMBLEM,tc,tp,POS_FACEUP_DEFENSE,REASON_EFFECT)
        end
    elseif sel==0 or (sel==1 and a and b) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
        local sg=rg2:Select(tp,1,1,nil)
        local sc=sg:GetFirst()
        local mg=rc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            VgF.Sendto(LOCATION_OVERLAY,mg,sg)
        end
        sc:SetMaterial(Group.FromCards(rc))
        VgF.Sendto(LOCATION_OVERLAY,Group.FromCards(rc),sc)
        VgF.Sendto(LOCATION_MZONE,sc,SUMMON_TYPE_SELFRIDE,tp,0x20)
        Duel.Draw(tp,1,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetValue(10000)
        e1:SetTarget(VgD.SelfRideAtk)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function VgD.SelfRideAtk(e,c)
    return VgF.IsSequence(c,0,4,5)
end
function VgD.RideZeroCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if rc then return false end
    local ct=Duel.GetMatchingGroupCount(Card.IsLevel,tp,LOCATION_RIDE,0,nil,0)
    return VgF.RuleTurnCondtion(e) and ct>0 and VgF.RuleCardCondtion(e)
end
function VgD.RideZeroOperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_RIDE,0,nil,0)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
        g=g:Select(tp,1,1,nil)
    end
    VgF.Sendto(LOCATION_MZONE,g,SUMMON_TYPE_RIDE,tp,0x20)
end
--Call到R位
function VgD.CallToR(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1152)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,0)
    e1:SetCondition(VgD.CallCondition)
    e1:SetOperation(VgD.CallOperation)
    c:RegisterEffect(e1)
end
function VgD.CallCondition(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    if VgF.GetAvailableLocation(tp)<=0 then return end
    return VgF.LvCondition(e)
end
function VgD.CallFilter(c,tp,zone)
    return VgF.RMonsterFilter(c) and zone==VgF.SequenceToGlobal(tp,c:GetLocation(),c:GetSequence())
end
function VgD.CallOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local z=bit.bnot(VgF.GetAvailableLocation(tp))
    local rg=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEDOWN_ATTACK)
    for tc in VgF.Next(rg) do
        local szone=VgF.SequenceToGlobal(tp,tc:GetLocation(),tc:GetSequence())
        z=bit.bor(z,szone)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CallZONE)
    local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,z)
    if VgF.IsExistingMatchingCard(VgD.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,zone) then
        local tc=Duel.GetMatchingGroup(VgD.CallFilter,tp,LOCATION_MZONE,0,nil,tp,zone):GetFirst()
        VgF.Sendto(LOCATION_DROP,tc,REASON_COST)
    end
    e:SetValue(function () return SUMMON_VALUE_CALL,zone end)
end

--超限舞装
function VgD.OverDress(c,f)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(VgF.Stringid(VgID,9))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP_ATTACK,0)
    e2:SetCondition(VgD.OverDressCondition(f))
    e2:SetOperation(VgD.OverDressOperation(f))
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetOperation(VgD.OverDressSum)
    c:RegisterEffect(e3)
end
function VgD.OverDressCondition(f)
    return function (e,c)
    if c==nil then return true end
        local tp=e:GetHandlerPlayer()
        return VgF.LvCondition(e) and VgF.IsExistingMatchingCard(VgD.OverDressFilter,tp,LOCATION_MZONE,0,1,nil,f)
    end
end
function VgD.OverDressFilter(c,f,tp,zone)
    if zone and zone>0 then
        if zone~=VgF.SequenceToGlobal(tp,c:GetLocation(),c:GetSequence()) then return false end
    end
    return ((VgF.GetValueType(f)=="function" and f(c)) or (VgF.GetValueType(f)=="number" and c:IsCode(f))) and c:IsFaceup()
end
function VgD.OverDressOperation(f)
    return function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local g=Duel.GetMatchingGroup(VgD.OverDressFilter,tp,LOCATION_MZONE,0,nil,f,tp)
        local szone
        local zone=0x00
        for tc in VgF.Next(g) do
            zone=bit.bor(zone,VgF.SequenceToGlobal(tp,tc:GetLocation(),tc:GetSequence()))
        end
        if zone==0x00 then return end
        zone=bit.bnot(zone)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CallZONE)
        szone=Duel.SelectField(tp,1,LOCATION_MZONE,0,zone)
        e:SetValue(function () return SUMMON_VALUE_CALL+SUMMON_VALUE_OverDress,szone end)
        local tc=Duel.GetMatchingGroup(VgD.OverDressFilter,tp,LOCATION_MZONE,0,nil,f,tp,szone):GetFirst()
        if not tc then return end
        local mg=tc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            VgF.Sendto(LOCATION_OVERLAY,mg,c)
        end
        c:SetMaterial(Group.FromCards(tc))
        VgF.Sendto(LOCATION_OVERLAY,Group.FromCards(tc),c)
    end
end
function VgD.OverDressSum(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:RegisterFlagEffect(FLAG_CONDITION,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,201,VgF.Stringid(10101006,0))
end

--战斗阶段
function VgD.MonsterBattle(c)
    --攻击转守备
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetOperation(VgD.MonsterPosDefenseOperation)
    c:RegisterEffect(e1)
    --回合开始转攻
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_ALL)
    e2:SetCountLimit(1,VgID+4)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCondition(VgF.RuleCardCondtion)
    e2:SetOperation(VgD.MonsterPosAttackOperation)
    c:RegisterEffect(e2)
    --扣血
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCondition(VgD.MonsterBattleDamageCondition)
    e3:SetOperation(VgD.MonsterBattleDamageOperation)
    c:RegisterEffect(e3)
    --攻击判定
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_F)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCondition(VgD.MonsterAttackCondition)
    e4:SetCost(VgD.MonsterAttackCost)
    e4:SetOperation(VgD.TriggerCard)
    c:RegisterEffect(e4)
    --多次判定
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_CUSTOM+EVENT_TRIGGER)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCondition(VgD.MonsterNextTrigger)
    e5:SetOperation(VgD.TriggerCard)
    c:RegisterEffect(e5)
    --支援
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetCondition(VgD.SupportCondition)
    e6:SetOperation(VgD.SupportOperation)
    c:RegisterEffect(e6)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    e9:SetRange(LOCATION_MZONE)
    e9:SetValue(VgD.SupportValue)
    c:RegisterEffect(e9)
    --防御
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DEFENDER)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_BATTLE_START)
    e7:SetRange(LOCATION_MZONE)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetCountLimit(1)
    e7:SetCondition(VgD.SendToGCondition(LOCATION_MZONE))
    e7:SetOperation(VgD.SendToGOperation)
    c:RegisterEffect(e7)
    local e17=e7:Clone()
    e17:SetRange(LOCATION_HAND)
    e17:SetCondition(VgD.SendToGCondition(LOCATION_HAND))
    c:RegisterEffect(e17)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_DAMAGE_STEP_END)
    e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
    e8:SetRange(LOCATION_ALL)
    e8:SetCondition(VgF.RuleCardCondtion)
    e8:SetOperation(VgD.GToGraveOperation)
    c:RegisterEffect(e8)
    --其他永续
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_DEFENSE_ATTACK)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e10:SetValue(1)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e11:SetCondition(VgD.MonsterAttackAnnounceCondition)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE)
    e13:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e13:SetValue(1)
    c:RegisterEffect(e13)
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_SINGLE)
    e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e14:SetRange(LOCATION_MZONE)
    e14:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e14:SetCondition(VgD.MonsterCannotBeDestoryCondition)
    e14:SetValue(1)
    c:RegisterEffect(e14)
    local e15=Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_SINGLE)
    e15:SetCode(EFFECT_EXTRA_ATTACK)
    e15:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e15:SetValue(100)
    c:RegisterEffect(e15)
    local e16=Effect.CreateEffect(c)
    e16:SetType(EFFECT_TYPE_SINGLE)
    e16:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e16:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e16:SetRange(LOCATION_MZONE)
    e16:SetCondition(VgD.MonsterCannotBeAttackedCondition)
    e16:SetValue(VgF.True)
    c:RegisterEffect(e16)
end
function VgD.TriggerCard(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetDecktopGroup(tp,1)
    Duel.DisableShuffleCheck()
    VgF.Sendto(LOCATION_TRIGGER,tg:GetFirst())
end
function VgD.MonsterPosDefenseOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    local label=1
    if c:IsAttribute(SKILL_TWICE_TRIGGER) then
        label=label+1
    elseif c:IsAttribute(SKILL_THRICE_TRIGGER) then
        label=label+2
    end
    c:RegisterFlagEffect(FLAG_ATTACK_TRIGGER,RESET_EVENT+RESETS_STANDARD,0,1,label)
    Duel.RaiseEvent(c,EVENT_CUSTOM+EVENT_TRIGGERCOUNTUP,e,0,tp,tp,0)
end
function VgD.MonsterPosAttackOperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
    if g:GetCount()>0 and Duel.GetTurnPlayer()==tp then
        Duel.ChangePosition(g,POS_FACEUP_ATTACK)
        Duel.Hint(HINT_LINES,tp,VgF.Stringid(VgID,8))
    end
end
function VgD.MonsterBattleDamageCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not bc or not bc:IsRelateToBattle() then return false end
    local atk=bc:GetAttack()
    local def=c:GetAttack()
    return VgF.VMonsterFilter(c) and c==Duel.GetAttackTarget() and atk>=def and bc:GetLeftScale()>0 and Duel.GetAttackTarget():GetFlagEffect(FLAG_DEFENSE_ENTIRELY)==0
end
function VgD.MonsterBattleDamageOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local label=bc:GetLeftScale()-1
    bc:RegisterFlagEffect(FLAG_DAMAGE_TRIGGER,RESET_EVENT+RESETS_STANDARD,0,1,label)
    VgD.TriggerCard(e,tp,eg,ep,ev,re,r,rp)
end
function VgD.MonsterNextTrigger(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return eg:GetFirst():GetControler()==tp and VgF.VMonsterFilter(c)
end
function VgD.SupportCondition(e,tp,eg,ep,ev,re,r,rp)
    return VgF.GetColumnGroup(Duel.GetAttacker()):IsContains(e:GetHandler()) and Duel.GetTurnPlayer()==tp and e:GetHandler():IsAttribute(SKILL_SUPPORT)
end
function VgD.SupportOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    c:RegisterFlagEffect(FLAG_SUPPORT,RESET_EVENT+RESETS_STANDARD,0,1)
    Duel.GetAttacker():RegisterFlagEffect(FLAG_SUPPORTED,RESET_EVENT+RESETS_STANDARD,0,1)
    Duel.RaiseEvent(c,EVENT_CUSTOM+EVENT_SUPPORT,e,0,tp,tp,0)
end
function VgD.SupportValue(e)
        local tp=e:GetHandlerPlayer()
        local atk=0
        if Duel.GetAttacker()==e:GetHandler() then
        local g=Duel.GetMatchingGroup(function (c)
            return c:GetFlagEffect(FLAG_SUPPORT)>0
        end,tp,LOCATION_MZONE,0,nil)
        for tc in VgF.Next(g) do
            atk=atk+tc:GetAttack()
        end
        return atk
    elseif Duel.GetAttackTarget()==e:GetHandler() then
        local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GZONE,0,nil)
        for tc in VgF.Next(g) do
            local def=tc:GetDefense()
            if def<0 then def=0 end
            atk=atk+def
        end
        return atk
    else
        return 0
    end
end
function VgD.SendToGCondition(loc)
    return function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local bc=Duel.GetAttackTarget()
        return bc and bc:IsControler(tp) and bc~=c and VgF.IsAbleToGZone(c,loc)
    end
end
function VgD.SendToGOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    VgF.Sendto(LOCATION_GZONE,c,tp,POS_FACEUP,REASON_EFFECT)
end
function VgD.GToGraveOperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_GZONE,0)
    if g:GetCount()>0 then VgF.Sendto(LOCATION_DROP,g,REASON_RULE) end
end
function VgD.MonsterAttackAnnounceCondition(e,c)
    return e:GetHandler():IsPosition(POS_DEFENSE) or (VgF.IsSequence(e:GetHandler(),1,2,3) and e:GetHandler():GetFlagEffect(FLAG_ATTACK_AT_REAR)==0)
end
function VgD.MonsterAttackCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not VgF.VMonsterFilter(c) and c:GetFlagEffect(FLAG_ALSO_CAN_TRIGGER)==0 then return false end
    local a=c:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER) and c:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER)>0
    return a and Duel.GetAttacker()==c
end
function VgD.MonsterAttackCost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(FLAG_COUNT_TRIGGER)==0 end
    c:RegisterFlagEffect(FLAG_COUNT_TRIGGER,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function VgD.MonsterCannotBeDestoryCondition(e)
    local c=e:GetHandler()
    return VgF.VMonsterFilter(c) or Duel.GetAttacker()==e:GetHandler()
end
function VgD.MonsterCannotBeAttackedCondition(e,c)
    return VgF.IsSequence(e:GetHandler(),1,2,3)
end

--送去g区
function vgd.CardToG(c,m,cost,op)
    local cm=_G["c"..m]
    if not cm.is_has_trigger then cm.is_has_trigger=true end
    local type=EFFECT_TYPE_TRIGGER_F
    if VgF.GetValueType(cost)=="function" then type=EFFECT_TYPE_TRIGGER_O end
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(VgF.Stringid(VgID,2))
    e1:SetType(EFFECT_TYPE_SINGLE+type)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_MOVE)
    if VgF.GetValueType(cost)=="function" then e1:SetCost(cost) end
    e1:SetCondition(VgD.CardToGCondition)
    if VgF.GetValueType(op)~="function" then e1:SetOperation(VgD.CardToGOperation) else  e1:SetOperation(op) end
    c:RegisterEffect(e1)
end
function VgD.CardToGCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GZONE) and Duel.GetAttackTarget()
end
function VgD.CardToGOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if vgf.RMonsterFilter(tc) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
        vgf.EffectReset(c,e1,EVENT_BATTLED)
    elseif vgf.VMonsterFilter(tc) then
        tc:RegisterFlagEffect(FLAG_DEFENSE_ENTIRELY,RESET_EVENT+RESETS_STANDARD,0,1)
    end
end

--判定
function VgD.CardTrigger(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_MOVE)
    e1:SetCondition(VgD.CardTriggerCondtion(0))
    e1:SetOperation(VgD.CardTriggerOperation(0))
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCondition(VgD.CardTriggerCondtion(1))
    e2:SetOperation(VgD.CardTriggerOperation(1))
    c:RegisterEffect(e2)
end
function VgD.CardTriggerCondtion(chkcon)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local cp=tp
        if chkcon==0 then
            cp=1-tp
        end
        return Duel.GetTurnPlayer()==cp and c:IsLocation(LOCATION_TRIGGER)
    end
end
function VgD.CardTriggerOperation(chkop,f)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsRace(TRIGGER_CRITICAL_STRIKE) then
            local g1=VgF.SelectMatchingCard(HINTMSG_CRITICAL_STRIKE,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            VgF.StarUp(c,g1,1,nil)
            local g2=VgF.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            VgF.AtkUp(c,g2,10000,nil)
        elseif c:IsRace(TRIGGER_DRAW) then
            local g=VgF.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            VgF.AtkUp(c,g,10000,nil)
            Duel.Draw(tp,1,REASON_TRIGGER)
        elseif c:IsRace(TRIGGER_HEAL) then
            local g=VgF.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            VgF.AtkUp(c,g,10000,nil)
            if Duel.GetMatchingGroupCount(nil,tp,LOCATION_DAMAGE,0,nil)>=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_DAMAGE,nil) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODROP)
                local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DAMAGE,0,1,1,nil):GetFirst()
                if tc then
                    VgF.Sendto(LOCATION_DROP,tc,REASON_TRIGGER)
                    Duel.Recover(tp,1,REASON_RULE)
                end
            end
        elseif c:IsRace(TRIGGER_ADVANCE) then
            local g=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,0,4,5)
            VgF.AtkUp(c,g,10000,nil)
        end
        if chkop==0 then
            if c:IsRace(TRIGGER_SUPER) then
                local ops={}
                local sel={}
                if c:IsRelateToEffect(e) then
                    table.insert(ops,VgF.Stringid(VgID+5,3))
                    table.insert(sel,function ()
                        VgF.Sendto(LOCATION_EXILE,c,REASON_TRIGGER)
                    end)
                end
                if true then
                    table.insert(ops,VgF.Stringid(VgID+5,4))
                    table.insert(sel,function ()
                        Duel.Draw(tp,1,REASON_TRIGGER)
                    end)
                end
                if VgF.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) then
                    table.insert(ops,VgF.Stringid(VgID+5,5))
                    table.insert(sel,function ()
                        local g=VgF.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
                        VgF.AtkUp(c,g,100000000,nil)
                    end)
                end
                if VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,0) then
                    table.insert(ops,VgF.Stringid(VgID+5,5))
                    table.insert(sel,function ()
                        VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,1)
                    end)
                end
                while #ops>0 do
                    local i=Duel.SelectOption(tp,table.unpack(ops))+1
                    sel[i]()
                    table.remove(ops,i)
                    table.remove(sel,i)
                end
            else
                if VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,0) then VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,1) end
                if c:IsRelateToEffect(e) then
                    VgF.Sendto(LOCATION_DAMAGE,c,tp,POS_FACEUP_ATTACK,REASON_EFFECT)
                    Duel.Damage(tp,1,REASON_TRIGGER)
                end
            end
            local rc=VgF.GetVMonster(tp)
            local bc=rc:GetBattleTarget()
            local label=bc:GetFlagEffectLabel(FLAG_DAMAGE_TRIGGER)
            if not label then return end
            if label>0 then
                label=label-1
                Duel.RaiseEvent(c,EVENT_CUSTOM+EVENT_TRIGGER,e,0,tp,tp,0)
                bc:ResetFlagEffect(FLAG_DAMAGE_TRIGGER)
                bc:RegisterFlagEffect(FLAG_DAMAGE_TRIGGER,RESET_EVENT+RESETS_STANDARD,0,1,label)
            elseif label==0 then
                bc:ResetFlagEffect(FLAG_DAMAGE_TRIGGER)
                Duel.RaiseEvent(rc,EVENT_CUSTOM+EVENT_DAMAGE_TRIGGER,e,0,tp,tp,0)
            end
        else
            if c:IsRace(TRIGGER_SUPER) then
                local ops={}
                local sel={}
                if c:IsRelateToEffect(e) then
                    table.insert(ops,VgF.Stringid(VgID+5,3))
                    table.insert(sel,function ()
                        VgF.Sendto(LOCATION_EXILE,c,REASON_TRIGGER)
                    end)
                end
                if true then
                    table.insert(ops,VgF.Stringid(VgID+5,4))
                    table.insert(sel,function ()
                        Duel.Draw(tp,1,REASON_TRIGGER)
                    end)
                end
                if VgF.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) then
                    table.insert(ops,VgF.Stringid(VgID+5,5))
                    table.insert(sel,function ()
                        local g=VgF.SelectMatchingCard(HINTMSG_ATKUP,e,tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
                        VgF.AtkUp(c,g,100000000,nil)
                    end)
                end
                if VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,0) then
                    table.insert(ops,VgF.Stringid(VgID+5,6))
                    table.insert(sel,function ()
                    return VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,1)
                end)
                end
                while #ops>0 do
                    local i=Duel.SelectOption(tp,table.unpack(ops))+1
                    sel[i]()
                    table.remove(ops,i)
                    table.remove(sel,i)
                end
            else
                if VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,0) then VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,1) end
                if c:IsRelateToEffect(e) then VgF.Sendto(LOCATION_HAND,c,nil,REASON_TRIGGER) end
            end
            local rc=VgF.GetVMonster(tp)
            local label=rc:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER)
            if not label then return end
            if label>1 then
                label=label-1
                Duel.RaiseEvent(c,EVENT_CUSTOM+EVENT_TRIGGER,e,0,tp,tp,0)
                rc:ResetFlagEffect(FLAG_ATTACK_TRIGGER)
                rc:RegisterFlagEffect(FLAG_ATTACK_TRIGGER,RESET_EVENT+RESETS_STANDARD,0,1,label)
            elseif label==1 then
                rc:ResetFlagEffect(FLAG_ATTACK_TRIGGER)
            end
        end
    end
end

function VgD.OperationWhenCardTrigger(e,tp,eg,ep,ev,re,r,rp,c,chk)
    local effect_when_trigger=c.effect_when_trigger
    local cost,con,tg=true,true,true
    if not effect_when_trigger or #effect_when_trigger==0 then return end
    if (VgF.GetValueType(effect_when_trigger[5])=="boolean" and not effect_when_trigger[5]) or (VgF.GetValueType(effect_when_trigger[5])~="boolean" and Duel.GetTurnPlayer()~=c:GetControler()) then return false end
    if VgF.GetValueType(effect_when_trigger[2])=="function" then cost=effect_when_trigger[2](e,tp,eg,ep,ev,re,r,rp,0) end
    if VgF.GetValueType(effect_when_trigger[3])=="function" then con=effect_when_trigger[3](e,tp,eg,ep,ev,re,r,rp) end
    if VgF.GetValueType(effect_when_trigger[4])=="function" then tg=effect_when_trigger[4](e,tp,eg,ep,ev,re,r,rp,0) end
    if VgF.GetValueType(effect_when_trigger[1])=="function" and cost and con and tg then
        if chk==0 then return true end
        local activate_chk=true
        if VgF.GetValueType(effect_when_trigger[2])=="function" then activate_chk=Duel.SelectYesNo(tp,VgF.Stringid(VgID,15)) end
        if activate_chk then
            Duel.HintSelection(Group.FromCards(c))
            local _,m=c:GetOriginalCode()
            Duel.Hint(HINT_CARD,0,m)
            if VgF.GetValueType(effect_when_trigger[2])=="function" then effect_when_trigger[2](e,tp,eg,ep,ev,re,r,rp,1) end
            if VgF.GetValueType(effect_when_trigger[4])=="function" then effect_when_trigger[4](e,tp,eg,ep,ev,re,r,rp,1) end
            effect_when_trigger[1](e,tp,eg,ep,ev,re,r,rp)
        end
    end
    return false
end

--vg规则
function VgD.Rule(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_DRAW)
    e1:SetRange(LOCATION_ALL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCountLimit(1,VgID+2)
    e1:SetCondition(VgD.RuelDrawCondition)
    e1:SetOperation(VgD.RuelDrawOperation)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLED)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(VgD.ResetOperation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_ALL)
    e3:SetCountLimit(1,VgID+3)
    e3:SetCondition(VgF.RuleCardCondtion)
    e3:SetOperation(VgD.EventRideStart)
	c:RegisterEffect(e3)
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_HAND_LIMIT)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e10:SetRange(LOCATION_ALL)
    e10:SetTargetRange(1,0)
    e10:SetValue(100)
    e10:SetCondition(VgF.RuleCardCondtion)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_ADJUST)
    e11:SetRange(LOCATION_ALL)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e11:SetCondition(VgF.RuleCardCondtion)
    e11:SetOperation(VgD.RuleWin)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_SKIP_M2)
    e12:SetRange(LOCATION_ALL)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetTargetRange(1,0)
    c:RegisterEffect(e12)
    local e13=e12:Clone()
    e13:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e13)
    local e14=e12:Clone()
    e14:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e14)
    local e15=e12:Clone()
    e15:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e15)
    local e16=Effect.CreateEffect(c)
    e16:SetType(EFFECT_TYPE_FIELD)
    e16:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e16:SetRange(LOCATION_ALL)
    e16:SetCondition(VgF.RuleCardCondtion)
    e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e16:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e16)
end
function VgD.EventRideStart(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetTurnPlayer()==tp then
        Duel.RaiseEvent(c,EVENT_CUSTOM+EVENT_RIDE_START,e,0,tp,tp,0)
    end
end
function VgD.RuleWin(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentChain()>0 then return end
    local g1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    local g2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
    if g1==0 and g2==0 then
        Duel.Win(PLAYER_NONE,0x2)
    elseif g1==0 then
        Duel.Win(1-tp,0x2)
    elseif g2==0 then
        Duel.Win(tp,0x2)
     end
end
function VgD.RuelDrawCondition(e,tp,eg,ep,ev,re,r,rp)
    return VgF.RuleTurnCondtion(e) and VgF.RuleCardCondtion(e)
end
function VgD.RuelDrawOperation(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,0,ct,nil)
    if g:GetCount()>0 then
        ct=Duel.SendtoDeck(g,tp,1,REASON_PHASEDRAW)
        Duel.Draw(tp,ct,REASON_PHASEDRAW)
        Duel.ShuffleDeck(tp)
    end
    if Duel.GetTurnPlayer()==tp then
        Duel.Draw(tp,1,REASON_PHASEDRAW)
    end
end
function VgD.ResetOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(FLAG_SUPPORT)>0 then c:ResetFlagEffect(FLAG_SUPPORT) end
    if c:GetFlagEffect(FLAG_SUPPORTED)>0 then c:ResetFlagEffect(FLAG_SUPPORTED) end
    if c:GetFlagEffect(FLAG_DEFENSE_ENTIRELY)>0 then c:ResetFlagEffect(FLAG_DEFENSE_ENTIRELY) end
end

--指令卡
---使c可以作为指令卡发动。
---@param c Card 要操作的卡
---@param m integer 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param op function|nil 作为指令卡的效果
---@param con function|nil 作为指令卡的发动条件
---@param cost function|nil 作为指令卡的发动费用
function VgD.SpellActivate(c,m,op,cost,con)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(VgF.Stringid(m, 0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(VgD.MixCost(cost))
    e1:SetCondition(VgD.SpellCondtion(con))
    e1:SetTarget(VgD.SpellTarget)
    e1:SetOperation(VgD.SpellOperation(op))
    c:RegisterEffect(e1)
end
function VgD.MixCostFilter(c,e,tp,eg,ep,ev,re,r,rp,mc,chk)
    if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_MIX_DIFFERENT_NAME) and c:IsCode(mc:GetCode()) then return false end
    local ce = c:GetActivateEffect()
    if not ce or (ce:GetCost() and not ce:GetCost()(e,tp,eg,ep,ev,re,r,rp,0)) then return false end
    local cfrom, cval, cfilter, mcfrom, mcval, mcfilter
    table.copy(cfrom,c.cos_from)
    table.copy(cval,c.cos_val)
    table.copy(cfilter,c.cos_filter)
    table.copy(mcfrom,mc.cos_from)
    table.copy(mcval,mc.cos_val)
    table.copy(mcfilter,mc.cos_filter)
    if #cfrom>0 and #mcfrom>0 then
        for cv=1,#cfrom do
            local c_cost_from=VgF.ShiftLocationFromString(cfrom[cv])
            local pos=0
            for mcv=1,#mcfrom do
                local mc_cost_from=VgF.ShiftLocationFromString(mcfrom[mcv])
                if mc_cost_from==c_cost_from then
                    local mc_cos_val=mcval[mcv]
                    local c_cos_val=cval[cv]
                    if VgF.GetValueType(mc_cos_val)~="number" then mc_cos_val=0 end
                    if VgF.GetValueType(c_cos_val)~="number" then c_cos_val=0 end
                    if mc_cost_from==LOCATION_OVERLAY and Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) then mc_cos_val,c_cos_val=0,0 end
                    local mcg=VgF.GetMatchingGroup(mcfilter[mcv],tp,mc_cost_from,0,c,e,tp)
                    local cg=VgF.GetMatchingGroup(cfilter[cv],tp,c_cost_from,0,mc,e,tp)
                    if mcg:GetCount()<mc_cos_val or cg:GetCount()<c_cos_val then return false end
                    mcg:Merge(cg)
                    if mcg:GetCount()<mc_cos_val+c_cos_val then return false end
                    pos=mcv
                end
            end
            if pos>0 then
                table.remove(mcfrom,pos)
                table.remove(mcval,pos)
                table.remove(mcfilter,pos)
            else
                local c_cos_val=cval[cv]
                    if VgF.GetValueType(c_cos_val)~="number" then c_cos_val=0 end
                    if c_cost_from==LOCATION_OVERLAY and Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) then c_cos_val=0 end
                local cg=VgF.GetMatchingGroup(cfilter[cv],tp,c_cost_from,0,mc,e,tp)
                if cg:GetCount()<c_cos_val then return false end
            end
        end
    elseif #mcfrom>0 and not chk then return false
    end
    return VgF.LvCondition(c)
end
function VgD.MixCost(cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
        local chk_return=VgF.GetValueType(cost)~="function" or cost(e,tp,eg,ep,ev,re,r,rp,0)
		if chk==0 then return chk_return end
		if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_MIX) and VgF.IsExistingMatchingCard(VgD.MixCostFilter,tp,LOCATION_DROP,0,1,nil,e,tp,eg,ep,ev,re,r,rp,c,chk_return) and Duel.SelectYesNo(tp,VgF.Stringid(VgID,6)) then
			local bc=Duel.SelectMatchingCard(tp,VgD.MixCostFilter,tp,LOCATION_DROP,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,c,chk_return):GetFirst()
            if bc then
                VgF.Sendto(LOCATION_LOCK,bc,POS_FACEUP,REASON_COST)
                e:SetLabelObject(bc)
                local bce = bc:GetActivateEffect()
                if VgF.GetValueType(cost)=="function" and bce and bce:GetCost() then VgD.MixCostOperation(c,bc,e,tp)
                elseif VgF.GetValueType(cost)=="function" then cost(e,tp,eg,ep,ev,re,r,rp)
                elseif bce and bce:GetCost() then bce:GetCost()(e,tp,eg,ep,ev,re,r,rp,chk) end
            end
        else
            if VgF.GetValueType(cost)=="function" then cost(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
function VgD.MixCostOperation(c,bc,e,tp)
    local cfrom, cto, cval, cval_max, cfilter, bcfrom, bcto, bcval, bcval_max, bcfilter
    table.copy(cfrom,c.cos_from)
    table.copy(cto,c.cos_to)
    table.copy(cval,c.cos_val)
    table.copy(cval_max,c.cos_val_max)
    table.copy(cfilter,bc.cos_filter)
    table.copy(bcfrom,bc.cos_from)
    table.copy(bcto,bc.cos_to)
    table.copy(bcval,bc.cos_val)
    table.copy(bcval_max,bc.cos_val_max)
    table.copy(bcfilter,bc.cos_filter)
    local g_from={}
    local g_to={}
    local g_filter_c={}
    local g_filter_bc={}
    local g_val_c={}
    local g_val_bc={}
    local g_val_c_max={}
    local g_val_bc_max={}
    local except_group=Group.FromCards(c,bc)
    for bcv=1,#bcfrom do
        local bc_cost_from=VgF.ShiftLocationFromString(bcfrom[bcv])
        local pos=0
        for cv=1,#cfrom do
            local c_cost_from=VgF.ShiftLocationFromString(cfrom[cv])
            if bc_cost_from==c_cost_from and VgF.ShiftLocationFromString(cto[cv])==VgF.ShiftLocationFromString(bcto[bcv]) then
                pos=bcv
                table.insert(g_from,cfrom[cv])
                table.insert(g_to,cto[cv])
                table.insert(g_filter_c,cfilter[cv])
                table.insert(g_filter_bc,bcfilter[bcv])
                table.insert(g_val_c,cval[cv])
                table.insert(g_val_bc,bcval[bcv])
                table.insert(g_val_c_max,cval_max[cv])
                table.insert(g_val_bc_max,bcval_max[bcv])
            end
        end
        if pos>0 then
            table.remove(bcfrom,pos)
            table.remove(bcto,pos)
            table.remove(bcval,pos)
            table.remove(bcval_max,pos)
            table.remove(bcfilter,pos)
        end
    end
    for i=1,#g_from do
        local tg_from=VgF.ShiftLocationFromString(g_from[i])
        local tg_to=VgF.ShiftLocationFromString(g_to[i])
        local tg=VgF.GetMatchingGroup(nil,tp,tg_from,0,except_group)
        local tg_filter_c=g_filter_c[i]
        local tg_filter_bc=g_filter_bc[i]
        local tg_val_c=g_val_c[i]
        local tg_val_bc=g_val_bc[i]
        local tg_val_c_max=g_val_c_max[i]
        local tg_val_bc_max=g_val_bc_max[i]
        local hintmsg=HINTMSG_SELECT
        local ext_params={}
        if tg_from==LOCATION_OVERLAY and Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_OVERLAY_COST_FREE_WHEN_MIX) and Duel.SelectYesNo(tp,VgF.Stringid(10401023,1)) then tg_val_c,tg_val_bc=0,0 end
        if tg:GetCount()<tg_val_c+tg_val_bc then goto continue end
        if VgF.GetValueType(tg_to)=="number" then
            if tg_to==LOCATION_DROP then
                if tg_from==LOCATION_MZONE then
                    hintmsg=HINTMSG_LEAVEFIELD
                elseif tg_from==LOCATION_OVERLAY then hintmsg=HINTMSG_REMOVEXYZ
                else hintmsg=HINTMSG_TODROP end
                ext_params={REASON_COST}
            elseif bit.band(tg_to,LOCATION_LOCK)>0 then
                hintmsg=HINTMSG_LOCK
                if bit.band(tg_to,POS_FACEUP)>0 then ext_params={POS_FACEUP,REASON_COST} end
                if bit.band(tg_to,POS_FACEDOWN)>0 then ext_params={POS_FACEDOWN,REASON_COST} end
            elseif bit.band(tg_to,LOCATION_EXILE)>0 then
                hintmsg=HINTMSG_REMOVE
                if bit.band(tg_to,POS_FACEUP)>0 then ext_params={tp,POS_FACEUP,REASON_COST} end
                if bit.band(tg_to,POS_FACEDOWN)>0 then ext_params={tp,POS_FACEDOWN,REASON_COST} end
            elseif tg_to==LOCATION_DECK then
                hintmsg=HINTMSG_TODECK
                ext_params={tp,SEQ_DECKSHUFFLE,REASON_COST}
            elseif tg_to==LOCATION_HAND then
                hintmsg=HINTMSG_ATOHAND
                ext_params={nil,REASON_COST}
            elseif tg_to==LOCATION_OVERLAY then
                hintmsg=HINTMSG_XMATERIAL
                ext_params={VgF.GetVMonster(tp)}
            end
        elseif VgF.GetValueType(tg_to)=="string" and tg_to=="POSCHANGE" then hintmsg=HINTMSG_POSCHANGE
        end
        Duel.Hint(HINT_SELECTMSG,tp,hintmsg)
        local sg=tg:SelectDoubleSubGroup(tp,tg_filter_c,tg_val_c,tg_val_c_max,tg_filter_bc,tg_val_bc,tg_val_bc_max,Group.FromCards(c,bc))
        if VgF.GetValueType(tg_to)=="string" and tg_to=="POSCHANGE" and tg_from==LOCATION_DAMAGE then Duel.ChangePosition(sg,POS_FACEDOWN_ATTACK,POS_FACEUP_ATTACK)
        elseif VgF.GetValueType(tg_to)=="string" and tg_to=="POSCHANGE" and tg_from~=LOCATION_DAMAGE then Duel.ChangePosition(sg,POS_FACEUP_DEFENCE,POS_FACEDOWN_ATTACK,POS_FACEUP_ATTACK,POS_FACEDOWN_DEFENCE)
        elseif VgF.GetValueType(tg_to)=="number" then VgF.Sendto(tg_to,sg,table.unpack(ext_params))
        end
        ::continue::
    end
end
function VgD.SpellCondtion(con)
    return function (e,tp,eg,ep,ev,re,r,rp)
        if VgF.GetValueType(con)=="function" and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
        return VgF.LvCondition(e)
    end
end
function VgD.SpellTarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct1=Duel.GetFlagEffectLabel(tp,FLAG_SPELL_COUNT_LIMIT)
    local ct2=Duel.GetFlagEffectLabel(tp,FLAG_SPELL_USED_COUNT)
    if VgF.GetValueType(ct1)~="number" then ct1=1 end
    if VgF.GetValueType(ct2)~="number" then ct2=0 end
    if chk==0 then return ct2<ct1 end
    Duel.RegisterFlagEffect(tp,FLAG_SPELL_USED_COUNT,RESET_PHASE+PHASE_END,0,1,ct2+1)
end
function VgD.SpellOperation(op)
    return function (e,tp,eg,ep,ev,re,r,rp,bool)
        if op then op(e,tp,eg,ep,ev,re,r,rp,1) end
        local mc=e:GetLabelObject()
        if bool or not mc then return end
        local te=mc:GetActivateEffect()
        local op2=te:GetOperation()
        if op2 then op2(e,tp,eg,ep,ev,re,r,rp,true) end
    end
end
---当c被卡号为code的卡Ride时触发的效果。
---@param c Card 被Ride的卡
---@param m integer 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param code integer|nil Ride的卡
---@param op function|nil 触发的效果
---@param cost function|nil 效果的费用
---@param con function|nil 效果的条件
---@param tg function|nil 
function VgD.BeRidedByCard(c,m,code,op,cost,con,tg)
    local cm=_G["c"..m]
    if not cm.is_has_trigger then cm.is_has_trigger=true end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
    e1:SetCondition(VgD.BeRidedByCardCondition(code,con))
    e1:SetOperation(VgD.BeRidedByCardOperation(m,op,cost,tg))
    c:RegisterEffect(e1)
end
function VgD.BeRidedByCardCondition(code,f)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if VgF.GetValueType(code)=="function" and not code(c:GetReasonCard()) then return false
        elseif VgF.GetValueType(code)=="number" and not c:GetReasonCard():IsCode(code) then return false end
        return r==REASON_RIDEUP and (VgF.GetValueType(f)=="nil" or f(e,tp,eg,ep,ev,re,r,rp))
    end
end
function VgD.BeRidedByCardOperation(m,op,cost,tg,stringid)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local rc=c:GetReasonCard()
        local type=EFFECT_TYPE_TRIGGER_F
        if not stringid then stringid=2 end
        if VgF.GetValueType(cost)=="function" then type=EFFECT_TYPE_TRIGGER_O end
        local e1=Effect.CreateEffect(rc)
        e1:SetDescription(VgF.Stringid(m,stringid))
        e1:SetType(type+EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_DELAY)
        e1:SetCode(EVENT_SPSUMMON_SUCCESS)
        e1:SetLabelObject(c)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(VgD.BeRidedByCardOpCondtion)
        if VgF.GetValueType(cost)=="function" then e1:SetCost(cost) end
        if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
        if VgF.GetValueType(op)=="function" then e1:SetOperation(op) end
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        rc:RegisterEffect(e1,true)
    end
end
function VgD.BeRidedByCardOpCondtion(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetLabelObject()
    return eg:GetFirst()==e:GetHandler() and e:GetHandler():GetOverlayGroup():IsContains(c)
end

---当c在loc时，code时点被触发时执行的效果。
---@param c Card 要触发效果的卡 
---@param m integer 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param loc integer 发动时所处的位置
---@param typ integer 若是自己状态变化引发，则填EFFECT_TYPE_SINGLE；<br>若是场上任意一卡状态变化引发，则填EFFECT_TYPE_FIELD。
---@param code integer 触发的时点
---@param op function|nil 触发的效果
---@param cost function|nil 效果的费用
---@param con function|nil 效果触发的条件
---@param tg function|nil 
---@param count integer|nil 指示效果在同一回合内最多发动的次数
---@param property integer|nil 指示效果的特殊属性。如确有必要填，请咨询群主。
function VgD.EffectTypeTrigger(c,m,loc,typ,code,op,cost,con,tg,count,property,stringid)
    local cm=_G["c"..m]
    if not cm.is_has_trigger then cm.is_has_trigger=true end
    local type2=EFFECT_TYPE_TRIGGER_F
    if VgF.GetValueType(cost)=="function" then type2=EFFECT_TYPE_TRIGGER_O end
    if not typ then typ=EFFECT_TYPE_SINGLE end
    if not loc then loc=LOCATION_MZONE end
    if not stringid then stringid=1 end
    if not property then property=0 end
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(VgF.Stringid(VgID+1,stringid))
    e1:SetType(typ+type2)
    if VgF.GetValueType(loc)=="number" then e1:SetRange(loc) end
    e1:SetCode(code)
    e1:SetProperty(property+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    if count and count>0 then e1:SetCountLimit(count) end
    if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
    if VgF.GetValueType(cost)=="function" then e1:SetCost(cost) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
    if VgF.GetValueType(op)=="function" then e1:SetOperation(op) end
    c:RegisterEffect(e1)
end
---当c在loc时，可以发动的【起】效果。
---@param c Card 要触发效果的卡 
---@param m integer 指示脚本的整数。cxxx的脚本应填入xxx。cm的脚本应填入m。
---@param loc integer 发动时所处的位置
---@param op function|nil 触发的效果
---@param cost function|nil 效果的费用
---@param con function|nil 效果触发的条件
---@param tg function|nil 
---@param count integer|nil 指示效果在同一回合内最多发动的次数
---@param property integer|nil 指示效果的特殊属性。如确有必要填，请咨询群主。
function VgD.EffectTypeIgnition(c,m,loc,op,cost,con,tg,count,property,stringid)
    local cm=_G["c"..m]
    if not cm.is_has_ignition then cm.is_has_ignition=true end
    if not loc then loc=LOCATION_MZONE end
    if not stringid then stringid=1 end
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(VgF.Stringid(VgID+2,stringid))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(loc)
    if property and property>0 then e1:SetProperty(property) end
    if count and count>0 then e1:SetCountLimit(count) end
    if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
    if VgF.GetValueType(cost)=="function" then e1:SetCost(cost) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(VgD.EffectTypeIgnitionTarget(tg)) end
    if VgF.GetValueType(op)=="function" then e1:SetOperation(op) end
    c:RegisterEffect(e1)
end
function VgD.EffectTypeIgnitionTarget(tg)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then
            return VgF.GetValueType(tg)~="function" or tg(e,tp,eg,ep,ev,re,r,rp,chk)
        end
        local c=e:GetLabelObject()
        Duel.SetTargetCard(c)
        tg(e,tp,eg,ep,ev,re,r,rp,chk)
    end
end
function VgD.EffectTypeTriggerWhenHitting(c,m,loc,typ,op,cost,con,tg,count,p,property,stringid)
    if not typ or typ==0 then typ=EFFECT_TYPE_SINGLE end
    if not p then p=c:GetControler() end
    VgD.EffectTypeTrigger(c,m,loc,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_DAMAGE_TRIGGER,op,cost,VgD.EffectTypeTriggerWhenHittingCon(typ,con,p),tg,count,property,stringid)
    VgD.EffectTypeTrigger(c,m,loc,typ,EVENT_BATTLE_DESTROYING,op,cost,con,tg,count,property,stringid)
end
function VgD.EffectTypeTriggerWhenHittingCon(typ,con,p)
    return function (e,tp,eg,ep,ev,re,r,rp)
        if eg:GetFirst():GetControler()==p and (VgF.GetValueType(con)=="function" and not con(e,tp,eg,ep,ev,re,r,rp)) then return false end
        if typ==EFFECT_TYPE_SINGLE then
            return Duel.GetAttacker()==e:GetHandler()
        end
        return true
    end
end
function VgD.QuickSpell(c,op,cost,con,tg)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
        if VgF.GetValueType(con)=="function" and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
        local bc=Duel.GetAttackTarget()
        return bc and bc:IsControler(tp) and VgF.LvCondition(e)
    end)
    if VgF.GetValueType(cost)=="function" then e1:SetCost(cost) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
    if VgF.GetValueType(op)=="function" then e1:SetOperation(op) end
    c:RegisterEffect(e1)
end
function VgD.ContinuousSpell(c,cost,con,tg)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,VgID+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
        if VgF.GetValueType(con)=="function" and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
        return VgF.LvCondition(e)
    end)
    if VgF.GetValueType(cost)=="function" then e1:SetCost(cost) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
    e1:SetOperation(VgD.ContinuousSpellOperation)
    c:RegisterEffect(e1)
end
function VgD.ContinuousSpellOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    VgF.Sendto(LOCATION_ORDER,c,tp,POS_FACEUP_ATTACK,REASON_RULE)
end
function VgD.EffectTypeContinuousChangeAttack(c,m,typ,val,con,tg,loc_self,loc_op,reset,mc)
    local cm=_G["c"..m]
    if not cm.is_has_continuous and not reset then cm.is_has_continuous=true end
    if VgF.GetValueType(mc)~="Card" then mc=c end
    if not typ then typ=EFFECT_TYPE_SINGLE end
    if not loc_self then loc_self=0 end
    if not loc_op then loc_op=0 end
    local e1=Effect.CreateEffect(c)
    e1:SetType(typ)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    if VgF.GetValueType(reset)=="number" then e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset) end
    if typ==EFFECT_TYPE_FIELD then e1:SetTargetRange(loc_self,loc_op) end
    if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
    e1:SetValue(val)
    mc:RegisterEffect(e1)
end
function VgD.EffectTypeContinuousChangeDefense(c,m,typ,val,con,tg,loc_self,loc_op,reset,mc)
    local cm=_G["c"..m]
    if not cm.is_has_continuous and not reset then cm.is_has_continuous=true end
    if VgF.GetValueType(mc)~="Card" then mc=c end
    if not typ then typ=EFFECT_TYPE_SINGLE end
    if not loc_self then loc_self=0 end
    if not loc_op then loc_op=0 end
    local e1=Effect.CreateEffect(c)
    e1:SetType(typ)
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetRange(LOCATION_GZONE)
    if VgF.GetValueType(reset)=="number" then e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset) end
    if typ==EFFECT_TYPE_FIELD then e1:SetTargetRange(loc_self,loc_op) end
    if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
    e1:SetValue(val)
    mc:RegisterEffect(e1)
end
function VgD.EffectTypeContinuousChangeStar(c,m,typ,val,con,tg,loc_self,loc_op,reset,mc)
    local cm=_G["c"..m]
    if not cm.is_has_continuous and not reset then cm.is_has_continuous=true end
    if VgF.GetValueType(mc)~="Card" then mc=c end
    if not typ then typ=EFFECT_TYPE_SINGLE end
    if not loc_self then loc_self=0 end
    if not loc_op then loc_op=0 end
    local e1=Effect.CreateEffect(c)
    e1:SetType(typ)
    e1:SetCode(EFFECT_UPDATE_LSCALE)
    e1:SetRange(LOCATION_MZONE)
    if VgF.GetValueType(reset)=="number" then e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset) end
    if typ==EFFECT_TYPE_FIELD then e1:SetTargetRange(loc_self,loc_op) end
    if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
    e1:SetValue(val)
    mc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_RSCALE)
    mc:RegisterEffect(e2)
end
function VgD.TriggerCountUp(c,m,num,reset,tc)
    local cm=_G["c"..m]
    if not cm.is_has_continuous and not reset then cm.is_has_continuous=true end
    if tc then tc=VgF.ReturnCard(tc) else tc=c end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_CUSTOM+EVENT_TRIGGERCOUNTUP)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
        return VgF.ReturnCard(eg)==e:GetHandler()
    end)
    if VgF.GetValueType(reset)=="number" then e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset) end
    e1:SetOperation(VgD.TriggerCountUpOperation(num))
    tc:RegisterEffect(e1)
end
function VgD.TriggerCountUpOperation(num)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local label=c:GetFlagEffectLabel(FLAG_ATTACK_TRIGGER)
        if not label then label=0 end
        label=label+num
        if label<0 then label=0 end
        c:ResetFlagEffect(FLAG_ATTACK_TRIGGER)
        c:RegisterFlagEffect(FLAG_ATTACK_TRIGGER,RESET_EVENT+RESETS_STANDARD,0,1,label)
    end
end
function VgD.GlobalCheckEffect(c,m,code,con,op)
    local typ=EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS
    local cm=_G["c"..m]
    if not cm.global_check then
        cm.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(typ)
        ge1:SetCode(code)
        if VgF.GetValueType(con)=="function" then ge1:SetCondition(con) end
        if VgF.GetValueType(op)=="function" then ge1:SetOperation(op) else
            ge1:SetOperation(function (e,tp,eg,ep,ev,re,r,rp)
                Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            end)
        end
        Duel.RegisterEffect(ge1,0)
    end
end

function VgD.CannotBeTarget(c,m,con,val,loc)
    local cm=_G["c"..m]
    if not cm.is_has_continuous then cm.is_has_continuous=true end
    if not loc then loc=LOCATION_MZONE end
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(loc)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
	if VgF.GetValueType(val)=="function" then e1:SetValue(val) else
        e1:SetValue(function (e,re,rp)
            return rp==1-e:GetHandlerPlayer()
        end)
    end
    c:RegisterEffect(e1)
end
function VgD.NightEffect(c,m)
    local cm=_G["c"..m]
    if not cm.is_has_continuous then cm.is_has_continuous=true end
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(AFFECT_CODE_NIGHT)
    e1:SetRange(LOCATION_ORDER)
    e1:SetTargetRange(1,0)
	e1:SetCondition(function (e)
        local tp=e:GetHandlerPlayer()
        return not vgf.IsExistingMatchingCard(VgD.NightFilter,tp,LOCATION_ORDER,0,1,nil) and vgf.GetMatchingGroupCount(nil,tp,LOCATION_ORDER,0,nil)==1
    end)
    c:RegisterEffect(e1)
end
function VgD.DeepNightEffect(c,m)
    local cm=_G["c"..m]
    if not cm.is_has_continuous then cm.is_has_continuous=true end
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(AFFECT_CODE_DEEP_NIGHT)
    e1:SetRange(LOCATION_ORDER)
    e1:SetTargetRange(1,0)
	e1:SetCondition(function (e)
        local tp=e:GetHandlerPlayer()
        return not vgf.IsExistingMatchingCard(VgD.NightFilter,tp,LOCATION_ORDER,0,1,nil) and vgf.GetMatchingGroupCount(nil,tp,LOCATION_ORDER,0,nil)>=2
    end)
    c:RegisterEffect(e1)
end
function VgD.NightFilter(c)
    return not c:IsSetCard(0x5040) and c:IsType(TYPE_CONTINUOUS)
end
function VgD.CallInPrison(c,m)
    local cm=_G["c"..m]
    if not cm.is_has_continuous then cm.is_has_continuous=true end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(VgF.Stringid(VgID,11))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_ORDER)
	e1:SetCondition(VgD.CallInPrisonCondition(1))
	e1:SetOperation(VgD.CallInPrisonOperation(1))
	c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetDescription(VgF.Stringid(VgID,12))
    e2:SetCondition(VgD.CallInPrisonCondition(2))
	e2:SetOperation(VgD.CallInPrisonOperation(2))
	c:RegisterEffect(e2)
end
function VgD.CallInPrisonCondition(val)
    return function (e,c,og)
        local tp=1-e:GetHandlerPlayer()
        local eg,ep,ev,re,r,rp
        if Duel.GetTurnPlayer()==e:GetHandlerPlayer() then return false end
        if val==1 then
            return (VgF.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,0) and VgF.IsExistingMatchingCard(VgD.CallInPrisonFilter,tp,LOCATION_HAND,0,1,nil,e,tp))
        elseif val==2 then
            return (VgF.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,0) and VgF.IsExistingMatchingCard(VgD.CallInPrisonFilter,tp,LOCATION_HAND,0,2,nil,e,tp))
        end
    end
end
function VgD.CallInPrisonOperation(val)
    return function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
        if val==1 then
            VgF.OverlayCost(1)(e,tp,eg,ep,ev,re,r,rp,1)
            local g=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,VgD.CallInPrisonFilter,tp,LOCATION_ORDER,0,1,1,nil,e,tp)
            if g:GetFirst():IsType(TYPE_MONSTER) then
                VgF.Sendto(LOCATION_MZONE,g,0,tp)
            else
                VgF.Sendto(LOCATION_DROP,g,REASON_EFFECT)
            end
        elseif val==2 then
            VgF.DamageCost(1)(e,tp,eg,ep,ev,re,r,rp,1)
            local tg=VgF.SelectMatchingCard(HINTMSG_CALL,e,tp,VgD.CallInPrisonFilter,tp,LOCATION_ORDER,0,2,2,nil,e,tp)
            local g=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
            if g:GetCount()>0 then
                VgF.Sendto(LOCATION_MZONE,g,0,tp)
                tg:Sub(g)
            end
            if tg:GetCount()>0 then
                VgF.Sendto(LOCATION_DROP,tg,REASON_EFFECT)
            end
        end
        sg=Group.CreateGroup()
    end
end
function VgD.CallInPrisonFilter(c,e,tp)
	return c:GetFlagEffect(FLAG_IMPRISON)>0 and (vgf.IsCanBeCalled(c,e,tp) or not c:IsType(TYPE_MONSTER))
end