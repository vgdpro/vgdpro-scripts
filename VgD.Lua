VgD={}
vg=VgD

--函数装封
--单位卡
function VgD.VgMonster(c)
    VgD.Rule(c)
    VgD.RideUp(c)
    VgD.CallToV(c)
    VgD.MonsterBattle(c)
    VgD.MonsterTrigger(c)
end

--骑升
function VgD.RideUp(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_RIDE)
    e1:SetCondition(VgD.RideZeroCondition)
    e1:SetOperation(VgD.RideZeroOperation)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_ALL)
    e2:SetCountLimit(1,VgID)
    e2:SetCondition(VgD.RideUpCondition)
    e2:SetOperation(VgD.RideUpOperation)
	c:RegisterEffect(e2)
end
function VgD.RideUpFilter1(c,lv)
    local tp=c:GetControler()
    return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c)
end
function VgD.RideUpFilter2(c,lv,code)
    return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAttribute(SKILL_SELF_RIDE)
end
function VgD.RideUpCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return false end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,lv+1)
    local rg2=Duel.GetMatchingGroup(VgD.RideUpFilter2,tp,LOCATION_HAND,0,nil,lv,code)
    local a=rg1:GetCount()>0
    local b=rg2:GetCount()>0
    return Duel.GetTurnPlayer()==tp and VgD.RuleCardCondtion(e) and (a or b)
end
function VgD.RideUpOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return false end
    local lv=rc:GetLevel()
    local code=rc:GetCode()
    local rg1=Duel.GetMatchingGroup(VgD.RideUpFilter1,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,lv+1)
    local rg2=Duel.GetMatchingGroup(VgD.RideUpFilter2,tp,LOCATION_HAND,0,nil,lv,code)
    local a=rg1:GetCount()>0
    local b=rg2:GetCount()>0
    local off=1
    local ops,opval={},{}
    if a then
        ops[off]=VgF.Stringid(VgID,3)
        opval[off]=0
        off=off+1
    end
    if b then
        ops[off]=VgF.Stringid(VgID,4)
        opval[off]=0
        off=off+1
    end
    ops[off]=VgF.Stringid(VgID,5)
    local sel=Duel.SelectOption(tp,table.unpack(ops))
    if sel==0 and a then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RIDEUP)
        local sg=rg1:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_HAND+LOCATION_RIDE)
        local sc=sg:GetFirst()
        local mg=rc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(rc))
        Duel.Overlay(sc,Group.FromCards(rc))
        VgF.Call(sc,SUMMON_TYPE_RIDE,tp,0x20)
    elseif sel==0 or (sel==1 and a and b) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RIDEUP)
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
    local c=e:GetHandler()
    local rc=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if rc then return false end
    return Duel.GetTurnCount(tp)+Duel.GetTurnCount(1-tp)==1 and c:IsLevel(1)
end
function VgD.RideZeroOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
        VgF.Call(c,SUMMON_TYPE_RIDE,tp,0x20)
end

--Call到v位
function VgD.CallToV(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,0)
    e1:SetCondition(VgD.CallCondition)
    e1:SetOperation(VgD.CallOperation)
    c:RegisterEffect(e1)
end
function VgD.CallVal(zone)
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
function VgD.CallCondition(e,c)
    if c==nil then return true end
    return VgF.LvCondition(e)
end
function VgD.CallOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=0
    if Duel.IsExistingMatchingCard(VgD.VMonsterFilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,VgF.Stringid(VgID,7)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LEAVEONFIELD)
        local tc=Duel.SelectMatchingCard(tp,VgD.VMonsterFilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
        if tc then
            zone=VgF.SequenceToGlobal(tp,tc:GetLocation(),tc:GetSequence())
            Duel.SendtoGrave(tc,REASON_COST)
        end
    end
    e:SetValue(VgD.CallVal(zone))
end

--战斗阶段
function VgD.MonsterBattle(c)
    --攻击转守备
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetOperation(VgD.MonsterPosDefenseOperation)
    c:RegisterEffect(e1)
    --回合开始转攻
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_POSITION)
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
    e4:SetOperation(VgD.TriggerMonster)
    c:RegisterEffect(e4)
    --多次判定
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_CUSTOM+Trigger)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(VgD.MonsterNextTrigger)
    e5:SetOperation(VgD.TriggerMonster)
    c:RegisterEffect(e5)
    --支援
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e6:SetCondition(VgD.SupportCondition)
    e6:SetOperation(VgD.SupportOperation)
    c:RegisterEffect(e6)
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
    e14:SetCondition(VgF.RMonsterCondition)
    e14:SetValue(1)
    c:RegisterEffect(e14)
    local e15=Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_SINGLE)
    e15:SetCode(EFFECT_SET_DEFENSE_FINAL)
    e15:SetValue(VgD.MonsterDefVal)
    c:RegisterEffect(e15)
    local e16=e15:Clone()
    e16:SetCode(EFFECT_EXTRA_ATTACK)
    e16:SetValue(100)
    c:RegisterEffect(e16)
    local e17=e15:Clone()
    e17:SetType(EFFECT_TYPE_SINGLE)
    e17:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e17:SetCondition(VgD.MonsterCannotBeAttackedCondition)
    e17:SetValue(VgF.True)
    c:RegisterEffect(e17)
end
function VgD.TriggerMonster(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetDecktopGroup(tp,1)
    Duel.DisableShuffleCheck()
    Duel.MoveToField(tg:GetFirst(),tp,tp,LOCATION_TRIGGER,POS_FACEUP,true)
    Duel.RaiseEvent(tg,ToTrigger,e,0,tp,tp,0)
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
    return Duel.GetTurnPlayer()==tp and c:IsPosition(POS_DEFENSE) and (VgD.VMonsterFilter(c) or VgF.RMonsterFilter(c))
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
    return c:GetSequence()==2 and c==Duel.GetAttackTarget() and VgF.RMonsterFilter(c)
end
function VgD.MonsterBattleDamageOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not bc or not bc:IsRelateToBattle() then return end
    local atk=bc:GetAttack()
    local def=c:GetAttack()
    if atk>=def then VgD.TriggerMonster(e,tp,eg,ep,ev,re,r,rp) end
end
function VgD.MonsterNextTrigger(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return eg:GetFirst():GetControler()==tp and VgF.RMonsterFilter(c)
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
function VgD.MonsterAttackAnnounceCondition(e,c)
    return e:GetHandler():IsPosition(POS_DEFENSE) or VgF.IsSequence(e:GetHandler(),1,2,3)
end
function VgD.MonsterAttackCondition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and Duel.GetAttackTarget()==bc and VgF.RMonsterFilter(c)
end
function VgD.MonsterAttackCost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(CountTriggerFlag)==0 end
    c:RegisterFlagEffect(CountTriggerFlag,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function VgD.MonsterDefVal(e,c)
    return e:GetHandler():GetAttack()
end
function VgD.MonsterCannotBeAttackedCondition(e,c)
    return VgF.IsSequence(e:GetHandler(),1,2,3)
end

--判定
function VgD.MonsterTrigger(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_TRIGGER)
    e1:SetCode(EVENT_CUSTOM+ToTrigger)
    e1:SetCondition(VgD.MonsterTriggerCondtion(0))
    e1:SetOperation(VgD.MonsterTriggerOperation(0))
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCondition(VgD.MonsterTriggerCondtion(1))
    e2:SetOperation(VgD.MonsterTriggerOperation(1))
    c:RegisterEffect(e2)
end
function VgD.MonsterTriggerCondtion(chkcon)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local rp=tp
        if chkcon==0 then rp=1-tp end
        return Duel.GetTurnPlayer()==rp
    end
end
function VgD.MonsterTriggerOperation(chkop)
    return function (e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if chkop==0 then
            Duel.SendtoDamage(c)
            Duel.Damage(tp,1,REASON_EFFECT)
            local rc=re:GetHandler()
            local bc=rc:GetBattleTarget()
            local label=bc:GetFlagEffectLabel(DamageTriggerFlag)
            if not label then return end
            if label>0 then
                label=label-1
                Duel.RaiseEvent(c,EVENT_CUSTOM+Trigger,e,0,tp,tp,0)
                bc:ResetFlagEffect(DamageTriggerFlag)
                bc:RegisterFlagEffect(DamageTriggerFlag,RESET_EVENT+RESETS_STANDARD+EVENT_DAMAGE_STEP_END,0,1,label)
            elseif label==0 then
                bc:ResetFlagEffect(DamageTriggerFlag)
            end
        else
            Duel.SendtoHand(c,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,c)
            local rc=re:GetHandler()
            local label=rc:GetFlagEffectLabel(AttackTriggerFlag)
            if not label then return end
            if label>0 then
                label=label-1
                Duel.RaiseEvent(c,EVENT_CUSTOM+Trigger,e,0,tp,tp,0)
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
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_ALL)
    e1:SetCountLimit(1)
    e1:SetCondition(VgD.RuelGCondition)
    e1:SetOperation(VgD.RuleGOperation)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_PREDRAW)
    e2:SetCondition(VgD.RuelDrawCondition)
    e2:SetOperation(VgD.RuelDrawOperation)
	c:RegisterEffect(e2)
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_HAND_LIMIT)
    e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e10:SetRange(LOCATION_ALL)
    e10:SetTargetRange(1,0)
    e10:SetValue(100)
    e10:SetCondition(VgD.RuleCardCondtion)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_ADJUST)
    e11:SetRange(LOCATION_ALL)
    e11:SetCondition(VgD.RuleCardCondtion)
    e11:SetOperation(VgD.RuleWin)
    c:RegisterEffect(e11)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e12:SetCode(EFFECT_SKIP_M2)
    e12:SetRange(LOCATION_ALL)
    e12:SetTargetRange(1,0)
    e12:SetCondition(VgD.RuleCardCondtion)
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
function VgD.RuleCardCondtion(e)
    local tp=e:GetHandlerPlayer()
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ALL,0,nil)
    return e:GetHandler()==g:GetFirst()
end
function VgD.RuleTurnCondtion(e)
    local tp=e:GetHandlerPlayer()
    local a=Duel.GetTurnCount(tp)
    local b=Duel.GetTurnCount(1-tp)
    return a+b==1
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
function VgD.RuelGCondition(e,tp,eg,ep,ev,re,r,rp)
    local rc=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not rc then return false end
    local lv=rc:GetLevel()+1
    local rg=Duel.GetMatchingGroup(Card.IsLevel,tp,LOCATION_HAND+LOCATION_RIDE,0,nil,lv):Filter(Card.IsType,nil,TYPE_MONSTER)
    return Duel.GetTurnPlayer()==tp and rc:IsLevelBelow(2) and rg:GetCount()==0 and VgD.RuleCardCondtion(e)
end
function VgD.RuleGOperation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,VgF.Stringid(VgID,1)) then
        local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
        if g:GetCount()>0 then
            Duel.ConfirmCards(1-tp,g)
            if Duel.SelectOption(1-tp,VgF.Stringid(VgID,2)) then
                local tg=Duel.GetDecktopGroup(tp,5)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local sg=tg:Select(tp,0,1,nil)
                if sg:GetCount()>0 then
                    Duel.SendtoHand(sg,nil,REASON_PHASEG)
                    Duel.ConfirmCards(1-tp,sg)
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                    local rg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,2,2,nil)
                    Duel.Exile(rg)
                end
                Duel.ShuffleDeck(tp)
            end
        end
    end
end
function VgD.RuelDrawCondition(e,tp,eg,ep,ev,re,r,rp)
    return VgD.RuleTurnCondtion(e) and VgD.RuleCardCondtion(e)
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
function VgD.SpellActivate(c,m,con,op,specialchk,num1,num2,num3,num4,num5)
    VgD.SpellCostCategory(m,specialchk,num1,num2,num3,num4,num5)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCost(VgD.SpellCost(num1,num2,num3,num4,num5))
    e1:SetCondition(con)
    e1:SetOperation(op)
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
            if num2>0 then b2=Duel.IsCanRemoveCounter(tp,1,0,COUNTER_ENERGE,num2,REASON_COST) end
            if num3>0 then b3=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,nil,mg):GetFirst():GetOverlayGroup():FilterCount(VgF.True,mg)>=num3 end
            if num4>0 then b4=Duel.GetFieldGroupCount(tp,LOCATION_DECK,num4)>0 end
            if num5>0 then b5=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,num5,mg) end
            return b1 and b2 and b3 and b4 and b5 and g:GetCount()>0
        end
        local rc=nil
        if Duel.IsPlayerAffectedByEffect(tp,AFFECT_CODE_MIX) and Duel.IsExistingMatchingCard(VgD.SpellMixFilter,tp,LOCATION_DROP,0,1,nil,c,num1,num2,num3,num4,num5)
            and Duel.SelectYesNo(VgF.Stringid(VgID,6)) then
            rc=Duel.SelectMatchingCard(tp,VgD.SpellMixFilter,tp,LOCATION_DROP,0,1,1,nil,c,num1,num2,num3,num4,num5)
        end
        VgD.SpellCostOp(e,tp,eg,ep,ev,re,r,rp,chk,c,rc,num1,num2,num3,num4,num5)
    end
end
function VgD.SpellCostCategory(m,specialchk,num1,num2,num3,num4,num5)
    local cm="c"..m
    if specialchk>0 then cm.Vg_SpecialCost=specialchk end
    if num1>0 then cm.Vg_DisCard=num1 end
    if num2>0 then cm.Vg_Counter=num2 end
    if num3>0 then cm.Vg_OverLay=num3 end
    if num4>0 then cm.Vg_OverLayFill=num4 end
    if num5>0 then cm.Vg_Damage=num5 end
end
function VgD.SpellMixFilter(c,mc,num1,num2,num3,num4,num5)
    local mg=Group.FromCards(c,mc)
    local tp=c:GetControler()
    local b1,b2,b3,b4,b5=true,true,true,true,true
    local b6,b7=false,false
    local g1,g2
    if c.Vg_DisCard>0 then num1=num1+c.Vg_DisCard end
    if c.Vg_Counter>0 then num2=num2+c.Vg_Counter end
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
    if num2>0 then b2=Duel.IsCanRemoveCounter(tp,1,0,COUNTER_ENERGE,num2,REASON_COST) end
    if num3>0 then b3=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,nil,mg):GetFirst():GetOverlayGroup():FilterCount(Card.IsAbleToGraveAsCost,mg)>=num3 end
    if num4>0 then b4=Duel.GetFieldGroupCount(tp,LOCATION_DECK,num4)>0 end
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
        mg:AddCard(mc)
        if mc.Vg_DisCard>0 then num1=num1+mc.Vg_DisCard end
        if mc.Vg_Counter>0 then num2=num2+mc.Vg_Counter end
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
        local g=Duel.SelectMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,num1,num1,mg)
        Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    end
    if num2>0 then
        Duel.RemoveCounter(tp,1,0,COUNTER_ENERGE,num2,REASON_COST)
    end
    if num3>0 then
        local g=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,mg,c):GetFirst():Filter(Card.IsAbleToGraveAsCost,mg)
        Duel.SendtoGrave(g,REASON_COST)
    end
    if num4>0 then
        local rc=Duel.GetMatchingGroup(VgF.RMonsterFilter,tp,LOCATION_MZONE,0,mg,c):GetFirst()
        local g=Duel.GetDecktopGroup(tp,num4)
        Duel.DisableShuffleCheck()
        Duel.Overlay(rc,g)
    end
    if num5>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DAMAGE)
        local g=Duel.SelectMatchingCard(Card.IsFaceup,tp,LOCATION_DAMAGE,0,num5,num5,mg)
        Duel.ChangePosition(g,POS_FACEDOWN)
    end
end