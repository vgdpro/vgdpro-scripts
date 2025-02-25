-- 天上独唱会 艾玛耶尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 黑翼（你的封锁区中的卡只有偶数的等级的场合才有效）
	-- 【自】【R】：被支援的这个单位攻击的战斗结束时，你可以选择你的后防者中或灵魂里的1张卡，返回手牌。从灵魂里选择了的话，将这个单位放置到灵魂里。(FLAG_SUPPORTED)
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_BATTLED,cm.op,nil,cm.con)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(FLAG_SUPPORTED)>0 and c:IsRelateToEffect(e) and Duel.GetAttacker() == c and vgf.DarkWing(e)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=vgf.SelectMatchingCard(HINTMSG_ATOHAND,e,tp,nil,tp,LOCATION_R_CIRCLE+LOCATION_OVERLAY,0,0,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		vgf.Sendto(LOCATION_HAND,tc,tp)
		if not tc:IsPreviousLocation(LOCATION_MZONE) then
			vgf.Sendto(LOCATION_OVERLAY,c)
		end
	end
end