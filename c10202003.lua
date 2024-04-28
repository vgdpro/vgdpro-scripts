--珠宝核龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位被「魔石龙 珠艾尼尔」骑升时，将这张卡召唤到RC上。
	vgd.BeRidedByCard(c,m,10202002,cm.operation,nil,cm.condition)
	--【自】【R】：这个单位攻击或支援时，这次战斗中，这个单位的力量+5000。这次战斗结束时，将这个单位放置到灵魂里。（这个效果为强制执行。）
	--没有找到支援时点，仅实现攻击时点
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,nil,cm.condition2)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation2,nil,cm.condition3)
	--vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_BATTLED,cm.operation3,nil,cm.condition2)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	vgf.Call(e:GetHandler():GetMaterial(),0,tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	--这里应该有一条检测被ride的珠宝核龙存在于灵魂之中的判断条件
	return true
end

function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	--无法设置重置时点于战斗结束时
	local c=e:GetHandler()
	VgF.AtkUp(c,c,5000,EVENT_BATTLED)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_BATTLED,cm.operation3)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return VgF.RMonsterFilter(e:GetHandler()) and Duel.GetAttacker()==e:GetHandler()
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Overlay(VgF.GetVMonster(tp),e:GetHandler())
end
