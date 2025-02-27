--书写记录的思绪 罗玛娜
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 【永】【R】：这个回合中你施放了「不移之绯红」和「无尽之苍蓝」的话，这个单位的力量+10000。
    vgd.GlobalCheckEffect(c,m,EVENT_CHAIN_SOLVING,cm.checkcon1)
    vgd.GlobalCheckEffect(c,m,EVENT_CHAIN_SOLVING,cm.checkcon2,cm.checkop)
	vgd.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 10000, cm.con)
end

function cm.con(e)
    local tp=e:GetHandlerPlayer()
    return vgf.con.IsR(e) and Duel.GetFlagEffect(tp,m)>0 and Duel.GetFlagEffect(tp,m+1)>0
end

function cm.checkcon1(e,tp,eg,ep,ev,re,r,rp)
    local rc = re:GetHandler()
    return rc:IsCode(10501116) and rp==tp
end

function cm.checkcon2(e,tp,eg,ep,ev,re,r,rp)
    local rc = re:GetHandler()
    return rc:IsCode(10501055) and rp==tp
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m+1,PHASE_END,0,1)
end
