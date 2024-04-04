vgd={}

--骑升
function vgd.RideUp(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetCountLimit(1,vgID)
    e1:SetRange(LOCATION_ALL)
    e1:SetCondition(vgd.RideZeroCondition)
    e1:SetOperation(vgd.RideZeroOperation)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e2:SetRange(LOCATION_ALL)
    e2:SetCountLimit(1,vgID+1)
    e2:SetCondition(vgd.RideUpCondition)
    e2:SetOperation(vgd.RideUpOperation)
	c:RegisterEffect(e2)
end
function vgd.RideUpFilter1(c,e,lv,code,rc)
    local tp=c:GetControler()
    if rc:IsAttribute(SKILL_SELF_RIDE) and c:IsCode(code) then
        return false
    end
    return ((c:IsLevel(lv,lv+1) and c:IsLocation(LOCATION_HAND)) or (c:IsLevel(lv+1) and c:IsLocation(LOCATION_RIDE))) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RIDE,tp,false,false,POS_FACEUP_ATTACK)
end
function vgd.DisCardRideUpFilter(c,e,lv,code,rc)
    local tp=c:GetControler()
    return c:IsDiscardable() and Duel.IsExistingMatchingCard(vgd.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,1,c,e,lv,code,rc)
end
function vgd.RideUpFilter2(c,e,lv,code,rc)
    return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsCode(code) and rc:IsAttribute(SKILL_SELF_RIDE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RIDE,tp,false,false,POS_FACEUP_ATTACK)
end
function vgd.RideUpCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return false end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(vgd.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,e,lv,code,rc)
    local rg2=Duel.GetMatchingGroup(vgd.RideUpFilter2,tp,LOCATION_HAND,0,nil,e,lv,code,rc)
    local a=rg1:GetCount()>0
    local b=rg2:GetCount()>0
    return Duel.GetTurnPlayer()==tp and vgf.RuleCardCondtion(e) and (a or b)
end
function vgd.RideUpOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(vgd.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,e,lv,code,rc)
    local rg2=Duel.GetMatchingGroup(vgd.RideUpFilter2,tp,LOCATION_HAND,0,nil,e,lv,code,rc)
    local a=rg1:GetCount()>0
    local b=rg2:GetCount()>0
    local off=1
    local ops={}
    if a then
        ops[off]=vgf.Stringid(vgID,3)
        off=off+1
    end
    if b then
        ops[off]=vgf.Stringid(vgID,4)
        off=off+1
    end
    ops[off]=vgf.Stringid(vgID,5)
    local sel=Duel.SelectOption(tp,table.unpack(ops))
    if sel==0 and a then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,vgd.DisCardRideUpFilter,tp,LOCATION_HAND,0,1,1,nil,e,lv,code,rc)
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
        vgf.Call(sc,SUMMON_TYPE_RIDE,tp,0x20)
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
        vgf.Call(sc,SUMMON_TYPE_RIDE,tp,0x20)
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
function vgd.RideZeroCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if rc then return false end
    local ct=Duel.GetMatchingGroupCount(vgd.RideZeroFilter,tp,LOCATION_RIDE,0,nil,e,tp)
    return vgf.RuleTurnCondtion(e) and ct>0 and vgf.RuleCardCondtion(e)
end
function vgd.RideZeroOperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(vgd.RideZeroFilter,tp,LOCATION_RIDE,0,nil,e,tp)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CALL)
        g=g:Select(tp,1,1,nil)
    end
    vgf.Call(g,SUMMON_TYPE_RIDE,tp,0x20)
end
function vgd.RideZeroFilter(c,e,tp)
    return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RIDE,tp,false,false,POS_FACEUP_ATTACK)
end

--Call到R位
function vgd.CallToR(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,0)
    e1:SetValue(SUMMON_TYPE_CALL)
    e1:SetCondition(vgd.CallCondition)
    e1:SetOperation(vgd.CallOperation)
    c:RegisterEffect(e1)
end
function vgd.CallVal(zone)
    if zone>0 then
        return function (e,c)
            return 0,zone
        end
    else
        return function (e,c)
            return 0,0x3f
        end
    end
end
function vgd.CallCondition(e,c)
    if c==nil then return true end
    return vgf.LvCondition(e) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_CALL,tp,false,false,POS_FACEUP_ATTACK)
end
function vgd.CallOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=0
    if Duel.IsExistingMatchingCard(vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,vgf.Stringid(vgID,7)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
        local tc=Duel.SelectMatchingCard(tp,vgf.RMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
        if tc then
            zone=vgf.SequenceToGlobal(tp,tc:GetLocation(),tc:GetSequence())
            Duel.SendtoGrave(tc,REASON_COST)
        end
    end
    e:SetValue(vgd.CallVal(zone))
end

--战斗阶段
function vgd.MonsterBattle(c)
    --攻击转守备
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetOperation(vgd.MonsterPosDefenseOperation)
    c:RegisterEffect(e1)
    --回合开始转攻
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetCondition(vgd.MonsterPosAttackCondition)
    e2:SetOperation(vgd.MonsterPosAttackOperation)
    c:RegisterEffect(e2)
    --扣血
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(vgd.MonsterBattleDamageCondition)
    e3:SetOperation(vgd.MonsterBattleDamageOperation)
    c:RegisterEffect(e3)
    --攻击判定
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_F)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e4:SetCondition(vgd.MonsterAttackCondition)
    e4:SetCost(vgd.MonsterAttackCost)
    e4:SetOperation(vgd.TriggerCard)
    c:RegisterEffect(e4)
    --多次判定
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_CUSTOM+EVENT_TRIGGER)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(vgd.MonsterNextTrigger)
    e5:SetOperation(vgd.TriggerCard)
    c:RegisterEffect(e5)
    --支援
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e6:SetCondition(vgd.SupportCondition)
    e6:SetOperation(vgd.SupportOperation)
    c:RegisterEffect(e6)
    --防御
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_ATTACK_ANNOUNCE)
    e7:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(vgd.SendToGCondition)
    e7:SetOperation(vgd.SendToGOperation)
    c:RegisterEffect(e7)
    --其他永续
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_DEFENSE_ATTACK)
    e10:SetValue(1)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e11:SetCondition(vgd.MonsterAttackAnnounceCondition)
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
    e14:SetCondition(vgf.VMonsterCondition)
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
    e16:SetCondition(vgd.MonsterCannotBeAttackedCondition)
    e16:SetValue(vgf.True)
    c:RegisterEffect(e16)
end
function vgd.TriggerCard(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetDecktopGroup(tp,1)
    Duel.DisableShuffleCheck()
    Duel.MoveToField(tg:GetFirst(),tp,tp,LOCATION_TRIGGER,POS_FACEUP,true)
end
function vgd.MonsterPosDefenseOperation(e,tp,eg,ep,ev,re,r,rp)
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
function vgd.MonsterPosAttackCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetTurnPlayer()==tp and c:IsPosition(POS_DEFENSE) and (vgf.RMonsterFilter(c) or vgf.VMonsterFilter(c))
end
function vgd.MonsterPosAttackOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.ChangePosition(c,POS_FACEUP_ATTACK)
    Duel.Hint(HINT_LINES,tp,vgf.Stringid(vgID,0))
end
function vgd.MonsterBattleDamageCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not bc or not bc:IsRelateToBattle() then return false end
    local atk=bc:GetAttack()
    local def=c:GetAttack()
    return vgf.VMonsterFilter(c) and c==Duel.GetAttackTarget() and atk>=def and bc:GetLeftScale()>0
end
function vgd.MonsterBattleDamageOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local label=bc:GetLeftScale()-1
    bc:RegisterFlagEffect(DamageTriggerFlag,RESET_EVENT+RESETS_STANDARD+EVENT_PRE_BATTLE_DAMAGE,0,1,label)
    vgd.TriggerCard(e,tp,eg,ep,ev,re,r,rp)
end
function vgd.MonsterNextTrigger(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return eg:GetFirst():GetControler()==tp and vgf.VMonsterFilter(c)
end
function vgd.SupportCondition(e,tp,eg,ep,ev,re,r,rp)
    return vgf.GetColumnGroup(Duel.GetAttacker()):IsContains(e:GetHandler()) and Duel.GetTurnPlayer()==tp and e:GetHandler():IsAttribute(SKILL_SUPPORT)
end
function vgd.SupportOperation(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.SelectYesNo(tp,vgf.Stringid(vgID,8)) then return end
    local c=e:GetHandler()
    Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_DAMAGE_STEP_END)
    e1:SetValue(c:GetAttack())
    Duel.GetAttacker():RegisterEffect(e1)
end
function vgd.SendToGCost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsPublic() and (not Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_SendtoG) or Duel.IsExistingMatchingCard(vgf.Not(Card.IsPublic),tp,LOCATION_HAND,0,1,c)) end
    local g=Group.FromCards(c)
    if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_SendtoG) then
        local sg=Duel.SelectMatchingCard(tp,vgf.Not(Card.IsPublic),tp,LOCATION_HAND,0,1,1,c)
        g:Merge(sg)
    end
    for tc in vgf.Next(g) do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PUBLIC)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_CHAIN_SOLVED)
        tc:RegisterEffect(e1)
    end
end
function vgd.SendToGCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=Duel.GetAttackTarget()
    return bc and bc:IsControler(tp) and bc~=c and vgf.IsAbleToGZone(c)
end
function vgd.SendToGOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=Duel.GetAttackTarget()
    if not bc or not vgf.IsAbleToGZone(c) or not c:IsRelateToEffect(e) then return false end
    Duel.Sendto(c,tp,LOCATION_GZONE,POS_FACEUP,REASON_EFFECT)
    local def=c:GetDefense()
    vgf.AtkUp(c,bc,def,nil)
end
function vgd.MonsterAttackAnnounceCondition(e,c)
    return e:GetHandler():IsPosition(POS_DEFENSE) or vgf.IsSequence(e:GetHandler(),1,2,3)
end
function vgd.MonsterAttackCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and Duel.GetAttackTarget()==bc and vgf.VMonsterFilter(c)
end
function vgd.MonsterAttackCost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(CountTriggerFlag)==0 end
    c:RegisterFlagEffect(CountTriggerFlag,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function vgd.MonsterCannotBeAttackedCondition(e,c)
    return vgf.IsSequence(e:GetHandler(),1,2,3)
end

--判定
function vgd.CardTrigger(c,f)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_MOVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(vgd.CardTriggerCondtion(0))
    e1:SetOperation(vgd.CardTriggerOperation(0,f))
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCondition(vgd.CardTriggerCondtion(1))
    e2:SetOperation(vgd.CardTriggerOperation(1,f))
    c:RegisterEffect(e2)
end
function vgd.CardTriggerCondtion(chkcon)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local cp=tp
        if chkcon==0 then cp=1-tp end
        return Duel.GetTurnPlayer()==cp and c:IsLocation(LOCATION_TRIGGER)
    end
end
function vgd.CardTriggerOperation(chkop,f)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsRace(TRRIGGER_CRITICAL_STRIKE) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CRITICAL_STRIKE)
            local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g1)
            vgf.StarUp(c,g1,1,nil)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
            local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g2)
            vgf.AtkUp(c,g2,10000,nil)
        elseif c:IsRace(TRRIGGER_DRAW) then
            Duel.Draw(tp,1,REASON_TRIGGER)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
            local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g)
            vgf.AtkUp(c,g,10000,nil)
        elseif c:IsRace(TRRIGGER_HEAL) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODROP)
            local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DAMAGE,0,1,1,nil):GetFirst()
            if tc then
                Duel.SendtoGrave(tc,REASON_TRIGGER)
            end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
            local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.HintSelection(g)
            vgf.AtkUp(c,g,10000,nil)
        elseif c:IsRace(TRRIGGER_ADVANCE) then
            local g=Duel.GetMatchingGroup(vgf.IsSequence,tp,LOCATION_MZONE,0,nil,0,4,5)
            for tc in vgf.Next(g) do
                vgf.AtkUp(c,tc,10000,nil)
            end
        end
        if chkop==0 then
            if c:IsRace(TRRIGGER_SUPER) then
                Duel.Exile(c,REASON_TRIGGER)
                Duel.Draw(tp,1,REASON_TRIGGER)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKUP)
                local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
                Duel.HintSelection(g)
                vgf.AtkUp(c,g,100000000,nil)
            else
                Duel.Sendto(c,tp,LOCATION_DAMAGE,POS_FACEUP,REASON_EFFECT)
                Duel.Damage(tp,1,REASON_TRIGGER)
            end
            local rc=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
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
                vgf.AtkUp(c,g,100000000,nil)
                if f then f(e,tp,eg,ep,ev,re,r,rp) end
                Duel.Exile(c,REASON_TRIGGER)
            else
                Duel.SendtoHand(c,nil,REASON_TRIGGER)
                Duel.ConfirmCards(1-tp,c)
            end
            local rc=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
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
function vgd.Rule(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_DRAW)
    e1:SetRange(LOCATION_ALL)
    e1:SetCountLimit(1,vgID+2)
    e1:SetCondition(vgd.RuelDrawCondition)
    e1:SetOperation(vgd.RuelDrawOperation)
	c:RegisterEffect(e1)
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_HAND_LIMIT)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e10:SetRange(LOCATION_ALL)
    e10:SetTargetRange(1,0)
    e10:SetValue(100)
    e10:SetCondition(vgf.RuleCardCondtion)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_ADJUST)
    e11:SetRange(LOCATION_ALL)
    e11:SetCondition(vgf.RuleCardCondtion)
    e11:SetOperation(vgd.RuleWin)
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
function vgd.RuleWin(e,tp,eg,ep,ev,re,r,rp)
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
function vgd.RuelDrawCondition(e,tp,eg,ep,ev,re,r,rp)
    return vgf.RuleTurnCondtion(e) and vgf.RuleCardCondtion(e)
end
function vgd.RuelDrawOperation(e,tp,eg,ep,ev,re,r,rp)
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
function vgd.SpellActivate(c,m,op,con,specialchk,num1,num2,num3,num4,num5)
    if not specialchk then specialchk=0 end
    if not num1 then num1=0 end
    if not num2 then num2=0 end
    if not num3 then num3=0 end
    if not num4 then num4=0 end
    if not num5 then num5=0 end
    vgd.SpellCostCategory(m,specialchk,num1,num2,num3,num4,num5)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,vgID+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(vgd.SpellCost(num1,num2,num3,num4,num5))
    if con then e1:SetCondition(con) end
    e1:SetOperation(vgd.SpellOperation(op))
    c:RegisterEffect(e1)
end
function vgd.SpellCost(num1,num2,num3,num4,num5)
    return function (e,tp,eg,ep,ev,re,r,rp,chk)
            local c=e:GetHandler()
            local mg=Group.FromCards(c)
            local g
            if chk==0 then
            local b1,b2,b3,b4,b5=true,true,true,true,true
            local b6=false
            if c.vg_SpecialCost>0 then g=vgd.SpellSpecialChk(c,mg) else g=mg end
            if g:GetCount()>0 or c.vg_SpecialCost==0 then
                if g then mg:Merge(g) end
                b6=true
            end
            if num1>0 then b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,num1,mg) end
            if num2>0 then b2=Duel.IsCanRemoveCounter(tp,1,0,COUNTER_ENERGE,num2,REASON_COST) end
            if num3>0 then b3=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,mg):GetFirst():GetOverlayGroup():FilterCount(vgf.True,mg)>=num3 end
            if num4>0 then b4=Duel.GetFieldGroupCount(tp,LOCATION_DECK,num4)>0 end
            if num5>0 then b5=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,num5,mg) end
            return b1 and b2 and b3 and b4 and b5 and b6
        end
        local rc=nil
        if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_MIX) and Duel.IsExistingMatchingCard(vgd.SpellMixFilter,tp,LOCATION_DROP,0,1,nil,c,num1,num2,num3,num4,num5)
            and Duel.SelectYesNo(tp,vgf.Stringid(vgID,6)) then
            rc=Duel.SelectMatchingCard(tp,vgd.SpellMixFilter,tp,LOCATION_DROP,0,1,1,nil,c,num1,num2,num3,num4,num5):GetFirst()
        end
        vgd.SpellCostOp(e,tp,eg,ep,ev,re,r,rp,chk,c,rc,num1,num2,num3,num4,num5)
    end
end
function vgd.SpellCostCategory(m,specialchk,num1,num2,num3,num4,num5)
    local cm=_G["c"..m]
    cm.vg_SpecialCost=specialchk
    cm.vg_DisCard=num1
    cm.vg_Counter=num2
    cm.vg_OverLay=num3
    cm.vg_OverLayFill=num4
    cm.vg_Damage=num5
end
function vgd.SpellMixFilter(c,mc,num1,num2,num3,num4,num5)
    local mg=Group.FromCards(c,mc)
    local tp=c:GetControler()
    local b1,b2,b3,b4,b5=true,true,true,true,true
    local b6,b7=false,false
    local g1=Group.CreateGroup()
    local g2=Group.CreateGroup()
    if c.vg_DisCard>0 then num1=num1+c.vg_DisCard end
    if c.vg_Counter>0 then num2=num2+c.vg_Counter end
    if c.vg_OverLay>0 then num3=num3+c.vg_OverLay end
    if c.vg_OverLayFill>0 then num4=num4+c.vg_OverLayFill end
    if c.vg_Damage>0 then num5=num5+c.vg_Damage end
    if c.vg_SpecialCost>0 then g1=vgd.SpellSpecialChk(c,mg) end
    if g1:GetCount()>0 or c.vg_SpecialCost==0 then
        if g1 then mg:Merge(g1) end
        b6=true
    end
    if mc.vg_SpecialCost>0 then g2=vgd.SpellSpecialChk(c,mg) end
    if g2:GetCount()>0 or mc.vg_SpecialCost==0 then
        if g2 then mg:Merge(g2) end
        b7=true
    end
    if num1>0 then b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,num1,mg) end
    if num2>0 then b2=Duel.IsCanRemoveCounter(tp,1,0,COUNTER_ENERGE,num2,REASON_COST) end
    if num3>0 then b3=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil,mg):GetFirst():GetOverlayGroup():FilterCount(Card.IsAbleToGraveAsCost,mg)>=num3 end
    if num4>0 then b4=Duel.GetFieldGroupCount(tp,LOCATION_DECK,num4)>0 end
    if num5>0 then b5=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,num5,mg) end
    return b1 and b2 and b3 and b4 and b5 and b6 and b7
end
function vgd.SpellSpecialChk(c,mg)
    local t={}
    local g
    for i, v in ipairs(t) do
        if c.vg_SpecialCost==v then
            local a
        end
    end
    return mg
end
function vgd.SpellCostOp(e,tp,eg,ep,ev,re,r,rp,chk,c,mc,num1,num2,num3,num4,num5)
    local mg=Group.FromCards(c)
    if mc then
        Duel.Remove(mc,POS_FACEUP,REASON_COST)
        e:SetLabelObject(mc)
        mg:AddCard(mc)
        if mc.vg_DisCard>0 then num1=num1+mc.vg_DisCard end
        if mc.vg_Counter>0 then num2=num2+mc.vg_Counter end
        if mc.vg_OverLay>0 then num3=num3+mc.vg_OverLay end
        if mc.vg_OverLayFill>0 then num4=num4+mc.vg_OverLayFill end
        if mc.vg_Damage>0 then num5=num5+mc.vg_Damage end
        local t={}
        for i, v in ipairs(t) do
            if mc.vg_SpecialCost==v then
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
        Duel.RemoveCounter(tp,1,0,COUNTER_ENERGE,num2,REASON_COST)
    end
    if num3>0 then
        local g=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst():GetOverlayGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,num3,num3,mg)
        Duel.SendtoGrave(g,REASON_COST)
    end
    if num4>0 then
        local rc=Duel.GetMatchingGroup(vgf.VMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
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
function vgd.SpellOperation(op)
    return function (e,tp,eg,ep,ev,re,r,rp,bool)
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
        local mc=e:GetLabelObject()
        if bool or not mc then return end
        local te=mc:GetActivateEffect()
        local op2=te:GetOperation()
        if op2 then op2(e,tp,eg,ep,ev,re,r,rp,true) end
    end 
end