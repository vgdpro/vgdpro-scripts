--微小的和平 普拉耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    vgd.VgCard(c)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）-【永】【R/G】：这个单位的力量+2000、盾护+5000。
    vgd.AbilityContChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,2000,cm.con)
    vgd.AbilityContChangeDefense(c,m,EFFECT_TYPE_SINGLE,5000,vgf.WhiteWing)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return vgf.WhiteWing(e) and vgf.RMonsterCondition(e)
end