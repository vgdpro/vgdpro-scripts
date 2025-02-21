-- 广袤的世界 维莉丝塔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	-- 【自】【V】【1回合1次】：你施放宝石卡时，抽1张卡。
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CHAINING,vgf.Draw,nil,cm.con1,nil,1)
-- 【永】【G】：你的弃牌区中的宝石卡每有2张，这个单位的盾护+5000。
	vgd.EffectTypeContinuousChangeDefense(c,m,EFFECT_TYPE_SINGLE,cm.val,nil)
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and vgf.VMonsterCondition(e)
end

function cm.val(e)
	local tp=e:GetHandlerPlayer()
	local ct=vgf.GetMatchingGroupCount(cm.filter,tp,LOCATION_GRAVE,0,nil)
	local val=math.floor(ct/2)*5000
	return val
end

function cm.filter(c)
	return c:IsSetCard(0xc040)
end