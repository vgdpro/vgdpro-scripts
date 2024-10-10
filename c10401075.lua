--深度音速
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
--【自】：这个单位登场到V时，灵魂填充1
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_SPSUMMON_SUCCESS,vgf.OverlayFill(1),nil,vgf.VSummonCondition)
--【永】【R】：你的回合中，你的灵魂在10张以上的话，这个单位的力量+10000。
	vgd.EffectTypeContinuousChangeAttack(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,10000,cm.con2)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterCondition(e) and vgf.GetVMonster(tp):GetOverlayCount()>=10
end
