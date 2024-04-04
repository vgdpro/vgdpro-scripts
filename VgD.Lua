VgD={}
vgd=VgD

--骑升
function VgD.RideUp(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetCountLimit(1,VgID)
    e1:SetRange(LOCATION_ALL)
    e1:SetCondition(VgD.RideZeroCondition)
    e1:SetOperation(VgD.RideZeroOperation)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e2:SetRange(LOCATION_ALL)
    e2:SetCountLimit(1,VgID+1)
    e2:SetCondition(VgD.RideUpCondition)
    e2:SetOperation(VgD.RideUpOperation)
	c:RegisterEffect(e2)
end
function VgD.RideUpFilter1(c,e,lv,code,rc)
    local tp=c:GetControler()
    if rc:IsAttribute(SKILL_SELF_RIDE) and c:IsCode(code) then
        return false
    end
    return ((c:IsLevel(lv,lv+1) and c:IsLocation(LOCATION_HAND)) or (c:IsLevel(lv+1) and c:IsLocation(LOCATION_RIDE))) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RIDE,tp,false,false,POS_FACEUP_ATTACK)
end
function VgD.DisCardRideUpFilter(c,e,lv,code,rc)
    local tp=c:GetControler()
    return c:IsDiscardable() and Duel.IsExistingMatchingCard(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,1,c,e,lv,code,rc)
end
function VgD.RideUpFilter2(c,e,lv,code,rc)
    return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsCode(code) and rc:IsAttribute(SKILL_SELF_RIDE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RIDE,tp,false,false,POS_FACEUP_ATTACK)
end
function VgD.RideUpCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return false end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,e,lv,code,rc)
    local rg2=Duel.GetMatchingGroup(VgD.RideUpFilter2,tp,LOCATION_HAND,0,nil,e,lv,code,rc)
    local a=rg1:GetCount()>0
    local b=rg2:GetCount()>0
    return Duel.GetTurnPlayer()==tp and VgF.RuleCardCondtion(e) and (a or b)
end
function VgD.RideUpOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,e,lv,code,rc)
    local rg2=Duel.GetMatchingGroup(VgD.RideUpFilter2,tp,LOCATION_HAND,0,nil,e,lv,code,rc)
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
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,VgD.DisCardRideUpFilter,tp,LOCATION_HAND,0,1,1,nil,e,lv,code,rc)
        Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
        local sg=rg1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_HAND+LOCATION_RIDE)
        local sc=sg:GetFirst()
        local mg=rc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(rc))
        Duel.Overlay(sc,Group.FromCards(rc))
        VgF.Call(sc,SUMMON_TYPE_RIDE,tp,0x20)
        if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_RIDE,0,1,nil,10400855) then
            local tc=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_RIDE,0,nil,10400855):GetFirst()
            Duel.Sendto(tc,tp,LOCATION_EMBLEM,POS_FACEUP,REASON_EFFECT)
        end
    elseif sel==0 or (sel==1 and a and b) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
        local sg=rg2:Select(tp,1,1,nil)
        local sc=sg:GetFirst()
        local mg=rc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(rc))
        Duel.Overlay(sc,Group.FromCards(rc))
        VgF.Call(sc,SUMMON_TYPE_RIDE,tp,0x20)
        Duel.Draw(tp,1,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetValue(10000)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function VgD.RideZeroCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if rc then return false end
    local ct=Duel.GetMatchingGroupCount(VgD.RideZeroFilter,tp,LOCATION_RIDE,0,nil,e,tp)
    return VgF.RuleTurnCondtion(e) and ct>0 and VgF.RuleCardCondtion(e)
end
function VgD.RideZeroOperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(VgD.RideZeroFilter,tp,LOCATION_RIDE,0,nil,e,tp)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
        g=g:Select(tp,1,1,nil)
    end
    VgF.Call(g,SUMMON_TYPE_RIDE,tp,0x20)
end
function VgD.RideZeroFilter(c,e,tp)
    return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RIDE,tp,false,false,POS_FACEUP_ATTACK)
end

--Call到R位
function VgD.CallToR(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,0)
    e1:SetValue(SUMMON_TYPE_CALL)
    e1:SetCondition(VgD.CallCondition)
    e1:SetOperation(VgD.CallOperation)
    c:RegisterEffect(e1)
end
function VgD.CallCondition(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return VgF.LvCondition(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_CALL,tp,false,false,POS_FACEUP_ATTACK)
end
function VgD.CallFilter(c,tp,zone)
    return VgF.RMonsterFilter(c) and zone==VgF.SequenceToGlobal(tp,c:GetLocation(),c:GetSequence())
end
function VgD.CallOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil,0x0000e0)
    if Duel.IsExistingMatchingCard(VgD.CallFilter,tp,LOCATION_MZONE,0,1,nil,tp,zone) then
        local tc=Duel.GetMatchingGroup(tp,VgD.CallFilter,tp,LOCATION_MZONE,0,1,1,nil,tp,zone):GetFirst()
        Duel.SendtoGrave(tc,REASON_COST)
    end
    e:SetValue(function () return 0,zone end)
end

--战斗阶段
function VgD.MonsterBattle(c)
    --攻击转守备
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetOperation(VgD.MonsterPosDefenseOperation)
    c:RegisterEffect(e1)
    --回合开始转攻
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetCondition(VgD.MonsterPosAttackCondition)
    e2:SetOperation(VgD.MonsterPosAttackOperation)
    c:RegisterEffect(e2)
    --扣血
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(VgD.MonsterBattleDamageCondition)
    e3:SetOperation(VgD.MonsterBattleDamageOperation)
    c:RegisterEffect(e3)
    --攻击判定
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_F)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e4:SetCondition(VgD.MonsterAttackCondition)
    e4:SetCost(VgD.MonsterAttackCost)
    e4:SetOperation(VgD.TriggerCard)
    c:RegisterEffect(e4)
    --多次判定
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_CUSTOM+EVENT_TRIGGER)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(VgD.MonsterNextTrigger)
    e5:SetOperation(VgD.TriggerCard)
    c:RegisterEffect(e5)
    --支援
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e6:SetCondition(VgD.SupportCondition)
    e6:SetOperation(VgD.SupportOperation)
    c:RegisterEffect(e6)
    --防御
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_ATTACK_ANNOUNCE)
    e7:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(VgD.SendToGCondition)
    e7:SetOperation(VgD.SendToGOperation)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCode(EVENT_DAMAGE_STEP_END)
    e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e8:SetRange(LOCATION_GZONE)
    e8:SetOperation(VgD.GToGraveOperation)
    c:RegisterEffect(e8)
    --其他永续
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_DEFENSE_ATTACK)
    e10:SetValue(1)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e11:SetCondition(VgD.MonsterAttackAnnounceCondition)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE)
    e13:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e13:SetValue(1)
    c:RegisterEffect(e13)
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_SINGLE)
    e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e14:SetRange(LOCATION_MZONE)
    e14:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e14:SetCondition(VgF.VMonsterCondition)
    e14:SetValue(1)
    c:RegisterEffect(e14)
    local e15=Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_SINGLE)
    e15:SetCode(EFFECT_EXTRA_ATTACK)
    e15:SetValue(100)
    c:RegisterEffect(e15)
    local e16=e15:Clone()
    e16:SetType(EFFECT_TYPE_SINGLE)
    e16:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e16:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e16:SetCondition(VgD.MonsterCannotBeAttackedCondition)
    e16:SetValue(VgF.True)
    c:RegisterEffect(e16)
end
function VgD.TriggerCard(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetDecktopGroup(tp,1)
    Duel.DisableShuffleCheck()
    Duel.MoveToField(tg:GetFirst(),tp,tp,LOCATION_TRIGGER,POS_FACEUP,true)
end
function VgD.MonsterPosDefenseOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    local label=0
    if c:IsAttribute(SKILL_TWICE_TRIGGER) then
        label=label+1
    elseif c:IsAttribute(SKILL_THRICE_TRIGGER) then
        label=label+2
    end
    c:RegisterFlagEffect(AttackTriggerFlag,RESET_EVENT+RESETS_STANDARD+EVENT_PRE_BATTLE_DAMAGE,0,1,label)
end
function VgD.MonsterPosAttackCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetTurnPlayer()==tp and c:IsPosition(POS_DEFENSE) and (VgF.RMonsterFilter(c) or VgF.VMonsterFilter(c))
end
function VgD.MonsterPosAttackOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.ChangePosition(c,POS_FACEUP_ATTACK)
    Duel.Hint(HINT_LINES,tp,VgF.Stringid(VgID,0))
end
function VgD.MonsterBattleDamageCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not bc or not bc:IsRelateToBattle() then return false end
    local atk=bc:GetAttack()
    local def=c:GetAttack()
    return VgF.VMonsterFilter(c) and c==Duel.GetAttackTarget() and atk>=def and bc:GetLeftScale()>0 and Duel.GetFlagEffect(tp,DefenseEntirelyFlag)==0
end
function VgD.MonsterBattleDamageOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local label=bc:GetLeftScale()-1
    bc:RegisterFlagEffect(DamageTriggerFlag,RESET_EVENT+RESETS_STANDARD+EVENT_PRE_BATTLE_DAMAGE,0,1,label)
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
    if not Duel.SelectYesNo(tp,VgF.Stringid(VgID,8)) then return end
    local c=e:GetHandler()
    Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_DAMAGE_STEP_END)
    e1:SetValue(c:GetAttack())
    Duel.GetAttacker():RegisterEffect(e1)
end
function VgD.SendToGCost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsPublic() and (not Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_SendtoG) or Duel.IsExistingMatchingCard(VgF.Not(Card.IsPublic),tp,LOCATION_HAND,0,1,c)) end
    local g=Group.FromCards(c)
    if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_SendtoG) then
        local sg=Duel.SelectMatchingCard(tp,VgF.Not(Card.IsPublic),tp,LOCATION_HAND,0,1,1,c)
        g:Merge(sg)
    end
    for tc in VgF.Next(g) do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_CHAIN_SOLVED)
        tc:RegisterEffect(e1)
    end
end
function VgD.SendToGCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=Duel.GetAttackTarget()
    return bc and bc:IsControler(tp) and bc~=c and VgF.IsAbleToGZone(c)
end
function VgD.SendToGOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=Duel.GetAttackTarget()
    if not bc or not VgF.IsAbleToGZone(c) or not c:IsRelateToEffect(e) then return false end
    Duel.Sendto(c,tp,LOCATION_GZONE,POS_FACEUP,REASON_EFFECT)
    local def=c:GetDefense()
    if def==0 then
        Duel.RegisterFlagEffect(tp,DefenseEntirelyFlag,RESET_EVENT+EVENT_DAMAGE_STEP_END,0,1)
    else
        VgF.AtkUp(c,bc,def,nil)
    end
end
function VgD.GToGraveOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.SendtoGrave(c,REASON_RULE)
end
function VgD.MonsterAttackAnnounceCondition(e,c)
    return e:GetHandler():IsPosition(POS_DEFENSE) or VgF.IsSequence(e:GetHandler(),1,2,3)
end
function VgD.MonsterAttackCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and Duel.GetAttackTarget()==bc and VgF.VMonsterFilter(c)
end
function VgD.MonsterAttackCost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(CountTriggerFlag)==0 end
    c:RegisterFlagEffect(CountTriggerFlag,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function VgD.MonsterCannotBeAttackedCondition(e,c)
    return VgF.IsSequence(e:GetHandler(),1,2,3)
end

--判定
function VgD.CardTrigger(c,f)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_MOVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(VgD.CardTriggerCondtion(0))
    e1:SetOperation(VgD.CardTriggerOperation(0,f))
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCondition(VgD.CardTriggerCondtion(1))
    e2:SetOperation(VgD.CardTriggerOperation(1,f))
    c:RegisterEffect(e2)
end
function VgD.CardTriggerCondtion(chkcon)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local cp=tp
        if chkcon==0 then cp=1-tp end
        return Duel.GetTurnPlayer()==cp and c:IsLocation(LOCATION_TRIGGER)
    end
end
function VgD.CardTriggerOperation(chkop,f)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsRace(TRRIGGER_CRITICAL_STRIKE) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CRITICAL_STRIKE)
            local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g1)
            VgF.StarUp(c,g1,1,nil)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
            local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g2)
            VgF.AtkUp(c,g2,10000,nil)
        elseif c:IsRace(TRRIGGER_DRAW) then
            Duel.Draw(tp,1,REASON_TRIGGER)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
            local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g)
            VgF.AtkUp(c,g,10000,nil)
        elseif c:IsRace(TRRIGGER_HEAL) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODROP)
            local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DAMAGE,0,1,1,nil):GetFirst()
            if tc then
                Duel.SendtoGrave(tc,REASON_TRIGGER)
            end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
            local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g)
            VgF.AtkUp(c,g,10000,nil)
        elseif c:IsRace(TRRIGGER_ADVANCE) then
            local g=Duel.GetMatchingGroup(VgF.IsSequence,tp,LOCATION_MZONE,0,nil,0,4,5)
            for tc in VgF.Next(g) do
                VgF.AtkUp(c,tc,10000,nil)
            end
        end
        if chkop==0 then
            if c:IsRace(TRRIGGER_SUPER) then
                Duel.Exile(c,REASON_TRIGGER)
                Duel.Draw(tp,1,REASON_TRIGGER)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
                local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
                Duel.HintSelection(g)
                VgF.AtkUp(c,g,100000000,nil)
            else
                Duel.Sendto(c,tp,LOCATION_DAMAGE,POS_FACEUP,REASON_EFFECT)
                Duel.Damage(tp,1,REASON_TRIGGER)
            end
            local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
            local bc=rc:GetBattleTarget()
            local label=bc:GetFlagEffectLabel(DamageTriggerFlag)
            if not label then return end
            if label>0 then
                label=label-1
                Duel.RaiseEvent(c,EVENT_CUSTOM+EVENT_TRIGGER,e,0,tp,tp,0)
                bc:ResetFlagEffect(DamageTriggerFlag)
                bc:RegisterFlagEffect(DamageTriggerFlag,RESET_EVENT+RESETS_STANDARD+EVENT_DAMAGE_STEP_END,0,1,label)
            elseif label==0 then
                bc:ResetFlagEffect(DamageTriggerFlag)
            end
        else
            if c:IsRace(TRRIGGER_SUPER) then
                Duel.Draw(tp,1,REASON_TRIGGER)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
                local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
                Duel.HintSelection(g)
                VgF.AtkUp(c,g,100000000,nil)
                if f then f(e,tp,eg,ep,ev,re,r,rp) end
                Duel.Exile(c,REASON_TRIGGER)
            else
                Duel.SendtoHand(c,nil,REASON_TRIGGER)
                Duel.ConfirmCards(1-tp,c)
            end
            local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
            local label=rc:GetFlagEffectLabel(AttackTriggerFlag)
            if not label then return end
            if label>0 then
                label=label-1
                Duel.RaiseEvent(c,EVENT_CUSTOM+EVENT_TRIGGER,e,0,tp,tp,0)
                rc:ResetFlagEffect(AttackTriggerFlag)
                rc:RegisterFlagEffect(AttackTriggerFlag,RESET_EVENT+RESETS_STANDARD+EVENT_PRE_BATTLE_DAMAGE,0,1,label)
            elseif label==0 then
                rc:ResetFlagEffect(AttackTriggerFlag)
            end
        end
    end
end

--vg规则
function VgD.Rule(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_DRAW)
    e1:SetRange(LOCATION_ALL)
    e1:SetCountLimit(1,VgID+2)
    e1:SetCondition(VgD.RuelDrawCondition)
    e1:SetOperation(VgD.RuelDrawOperation)
	c:RegisterEffect(e1)
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_HAND_LIMIT)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e10:SetRange(LOCATION_ALL)
    e10:SetTargetRange(1,0)
    e10:SetValue(100)
    e10:SetCondition(VgF.RuleCardCondtion)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_ADJUST)
    e11:SetRange(LOCATION_ALL)
    e11:SetCondition(VgF.RuleCardCondtion)
    e11:SetOperation(VgD.RuleWin)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetCode(EFFECT_SKIP_M2)
    e12:SetRange(LOCATION_ALL)
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
end
function VgD.RuleWin(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentChain()>0 then return end
    for WinReason=0x1, 0xff, 1 do
        if WinReason==0x2 then
            local g1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
            local g2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
            if g1==0 and g2==0 then
                Duel.Win(PLAYER_NONE,WinReason)
            elseif g1==0 then
                Duel.Win(1-tp,WinReason)
            elseif g2==0 then
                Duel.Win(tp,WinReason)
            end
        end
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

--指令卡cost
function VgD.SpellActivate(c,m,op,con,specialchk,num1,num2,num3,num4,num5)
    if not specialchk then specialchk=0 end
    if not num1 then num1=0 end
    if not num2 then num2=0 end
    if not num3 then num3=0 end
    if not num4 then num4=0 end
    if not num5 then num5=0 end
    VgD.SpellCostCategory(m,specialchk,num1,num2,num3,num4,num5)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,VgID+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(VgD.SpellCost(num1,num2,num3,num4,num5))
    if VgF.GetValueType(con)=="function" then e1:SetCondition(con) end
    e1:SetOperation(VgD.SpellOperation(op))
    c:RegisterEffect(e1)
end
function VgD.SpellCost(num1,num2,num3,num4,num5)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
            local c=e:GetHandler()
            local mg=Group.FromCards(c)
            local g
            if chk==0 then
            local b1,b2,b3,b4,b5=true,true,true,true,true
            local b6=false
            if c.Vg_SpecialCost>0 then g=VgD.SpellSpecialChk(c,mg) else g=mg end
            if g:GetCount()>0 or c.Vg_SpecialCost==0 then
                if g then mg:Merge(g) end
                b6=true
            end
            if num1>0 then b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,num1,mg) end
            if num2>0 then b2=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EMBLEM,0,num2,nil,20401001) end
            if num3>0 then b3=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil,mg):GetFirst():GetOverlayGroup():FilterCount(VgF.True,mg)>=num3 end
            if num4>0 then b4=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=num4 end
            if num5>0 then b5=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,num5,mg) end
            return b1 and b2 and b3 and b4 and b5 and b6
        end
        local rc=nil
        if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_MIX) and Duel.IsExistingMatchingCard(VgD.SpellMixFilter,tp,LOCATION_DROP,0,1,nil,c,num1,num2,num3,num4,num5)
            and Duel.SelectYesNo(tp,VgF.Stringid(VgID,6)) then
            rc=Duel.SelectMatchingCard(tp,VgD.SpellMixFilter,tp,LOCATION_DROP,0,1,1,nil,c,num1,num2,num3,num4,num5):GetFirst()
        end
        VgD.SpellCostOp(e,tp,eg,ep,ev,re,r,rp,chk,c,rc,num1,num2,num3,num4,num5)
    end
end
function VgD.SpellCostCategory(m,specialchk,num1,num2,num3,num4,num5)
    local cm=_G["c"..m]
    cm.Vg_SpecialCost=specialchk
    cm.Vg_DisCard=num1
    cm.Vg_Energe=num2
    cm.Vg_OverLay=num3
    cm.Vg_OverLayFill=num4
    cm.Vg_Damage=num5
end
function VgD.SpellMixFilter(c,mc,num1,num2,num3,num4,num5)
    local mg=Group.FromCards(c,mc)
    local tp=c:GetControler()
    local b1,b2,b3,b4,b5=true,true,true,true,true
    local b6,b7=false,false
    local g1=Group.CreateGroup()
    local g2=Group.CreateGroup()
    if c.Vg_DisCard>0 then num1=num1+c.Vg_DisCard end
    if c.Vg_Energe>0 then num2=num2+c.Vg_Energe end
    if c.Vg_OverLay>0 then num3=num3+c.Vg_OverLay end
    if c.Vg_OverLayFill>0 then num4=num4+c.Vg_OverLayFill end
    if c.Vg_Damage>0 then num5=num5+c.Vg_Damage end
    if c.Vg_SpecialCost>0 then g1=VgD.SpellSpecialChk(c,mg) end
    if g1:GetCount()>0 or c.Vg_SpecialCost==0 then
        if g1 then mg:Merge(g1) end
        b6=true
    end
    if mc.Vg_SpecialCost>0 then g2=VgD.SpellSpecialChk(c,mg) end
    if g2:GetCount()>0 or mc.Vg_SpecialCost==0 then
        if g2 then mg:Merge(g2) end
        b7=true
    end
    if num1>0 then b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,num1,mg) end
    if num2>0 then b2=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_EMBLEM,0,num2,nil,20401001) end
    if num3>0 then b3=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil,mg):GetFirst():GetOverlayGroup():FilterCount(Card.IsAbleToGraveAsCost,mg)>=num3 end
    if num4>0 then b4=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=num4 end
    if num5>0 then b5=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,num5,mg) end
    return b1 and b2 and b3 and b4 and b5 and b6 and b7
end
function VgD.SpellSpecialChk(c,mg)
    local t={}
    local g
    for i, v in ipairs(t) do
        if c.Vg_SpecialCost==v then
            local a
        end
    end
    return mg
end
function VgD.SpellCostOp(e,tp,eg,ep,ev,re,r,rp,chk,c,mc,num1,num2,num3,num4,num5)
    local mg=Group.FromCards(c)
    if mc then
        Duel.Remove(mc,POS_FACEUP,REASON_COST)
        e:SetLabelObject(mc)
        mg:AddCard(mc)
        if mc.Vg_DisCard>0 then num1=num1+mc.Vg_DisCard end
        if mc.Vg_Energe>0 then num2=num2+mc.Vg_Energe end
        if mc.Vg_OverLay>0 then num3=num3+mc.Vg_OverLay end
        if mc.Vg_OverLayFill>0 then num4=num4+mc.Vg_OverLayFill end
        if mc.Vg_Damage>0 then num5=num5+mc.Vg_Damage end
        local t={}
        for i, v in ipairs(t) do
            if mc.Vg_SpecialCost==v then
                local a
            end
        end
    end
    if num1>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,num1,num1,mg)
        Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    end
    if num2>0 then
        local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_EMBLEM,0,num2,num2,nil,20401001)
        Duel.SendtoGrave(g,REASON_COST)
    end
    if num3>0 then
        local g=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,num3,num3,mg)
        Duel.SendtoGrave(g,REASON_COST)
    end
    if num4>0 then
        local rc=Duel.GetMatchingGroup(VgF.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
        local g=Duel.GetDecktopGroup(tp,num4)
        Duel.DisableShuffleCheck()
        Duel.Overlay(rc,g)
    end
    if num5>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DAMAGE)
        local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_DAMAGE,0,num5,num5,mg)
        Duel.ChangePosition(g,POS_FACEDOWN)
    end
end
function VgD.SpellOperation(op)
    return function (e,tp,eg,ep,ev,re,r,rp,bool)
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
        local mc=e:GetLabelObject()
        if bool or not mc then return end
        local te=mc:GetActivateEffect()
        local op2=te:GetOperation()
        if op2 then op2(e,tp,eg,ep,ev,re,r,rp,true) end
    end
end
function VgD.BeRidedByCard(c,m,code,property,con,cost,op,tg)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(VgF.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(VgD.BeRidedByCardCondition(code,con))
    if property then e1:SetProperty(property) end
    if VgF.GetValueType(cost)=="function" then e1:SetCost(cost) end
    if VgF.GetValueType(tg)=="function" then e1:SetTarget(tg) end
    if VgF.GetValueType(op)=="function" then e1:SetOperation(op) end
    c:RegisterEffect(e1)
end
function VgD.BeRidedByCardCondition(code,f)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        return c:IsCode(code) and (VgF.GetValueType(f)=="nil" or f(e,tp,eg,ep,ev,re,r,rp))
    end
end