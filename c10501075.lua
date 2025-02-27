-- 注视爱吧 缇尔丝耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
    -- 黑翼（你的封锁区中的卡只有偶数的等级的场合才有效）-
	-- 【自】：这个单位被放置到G时，选择后列的对手的1张后防者，横置。
	vgd.action.AbilityAuto(c, m,nil,nil,EVENT_TO_G_CIRCLE,cm.op,nil,vgf.BlackWings)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=vgf.SelectMatchingCard(HINTMSG_OPPO,e,tp,cm.filter,tp,0,LOCATION_CIRCLE,1,1,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end

function cm.filter(c)
    return c:IsPosition(POS_FACEUP_ATTACK) and vgf.filter.Back(c)
end
