--微小的和平 普拉耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 白翼（你的封锁区中的卡只有奇数的等级的场合才有效）-【永】【R/G】：这个单位的力量+2000、盾护+5000。
	vgd.action.AbilityCont(c, m, LOCATION_CIRCLE, EFFECT_TYPE_SINGLE, EFFECT_UPDATE_ATTACK, 2000, cm.con)
	vgd.action.AbilityCont(c, m, LOCATION_G_CIRCLE, EFFECT_TYPE_SINGLE, 5000, EFFECT_UPDATE_DEFENSE, vgf.WhiteWings)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return vgf.WhiteWings(e) and vgf.con.IsR(e)
end