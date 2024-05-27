--诚意真心的领队 克拉莉萨

local cm,m,o=GetID()

function cm.initial_effect(c)--这个函数下面用于注册效果
         vgf.VgCard(c)
        --【自】：通过在「正确的音程 克拉莉萨」上RIDE的方式将这个单位登场到V时
        -- 通过【费用】[计数爆发1]，
        -- 从你的牌堆里探寻至多1张「目标！最强的偶像！」，公开后加入手牌，然后牌堆洗切。
        -- vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.SearchCard(LOCATION_DECK,cm.filter),VgF.DamageCost(1),cm.con2,nil,1) 封装函数存在问题，先废话代替
        vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,cm.operation2,VgF.DamageCost(1),cm.con2,nil,1)

        -- 【自】【V】：这个单位的攻击击中时，抽1张卡，选择你的1张含有「诚意真心」的后防者，这个回合中，力量+5000。
        vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.operation1,nil,cm.con1)
end

function cm.con2(e)
        local c = e:GetHandler()
        local g = c:GetMaterial()
        return VgF.VMonsterCondition(e) and c:IsSummonType(SUMMON_TYPE_RIDE) and g:IsExists(Card.IsCode,1,nil,10501036)
end

function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
        local g=Duel.GetDecktopGroup(tp,50)
        --确认卡组
        -- Duel.ConfirmCards(tp,g)
        Duel.DisableShuffleCheck()
        
        local sg=g:FilterSelect(tp,cm.filter,0,1,nil)
        Duel.DisableShuffleCheck()
            if #sg > 0 then
                    Duel.SendtoHand(sg,nil,REASON_EFFECT)
                    Duel.ConfirmCards(1-tp,sg)
                    Duel.ShuffleHand(tp)
                    g:RemoveCard(vgf.ReturnCard(sg))
            end
        Duel.ShuffleDeck(tp)
end

function cm.filter(c)
        return c:IsCode(10501021)  
end
function cm.con1(e)
	local c=e:GetHandler()
	return VgF.VMonsterCondition(e)
end

function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
        local c = e:GetHandler()
        Duel.Draw(tp,1,REASON_EFFECT)
        Duel.Hint(HINT_MESSAGE,tp,HINTMSG_ATKUP)
        local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
        vgf.AtkUp(c,g,5000)  

        -- vgf.RMonsterFilter
end

function cm.filter(c)
	return c:IsSetCard(0xb6) and c:GetSequence()<5
end

