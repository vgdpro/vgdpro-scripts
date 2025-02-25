--野蛮侵袭
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】【R】：这个单位攻击时，你有含有「道拉珠艾尔德」的先导者的话，通过【费用】[计数爆发1]，这次战斗中，这个单位的力量+10000。这次战斗结束时，将这个单位放置到灵魂里。
	vgd.AbilityAuto(c,m,LOCATION_CIRCLE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.cost.CounterBlast(1),cm.condition)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=vgf.AtkUp(c,c,10000)
		vgf.EffectReset(c,e2,EVENT_BATTLED)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_SET)
		e1:SetCode(EVENT_BATTLED)
		e1:SetRange(LOCATION_CIRCLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetOperation(cm.operation2)
		c:RegisterEffect(e1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterFilter(e:GetHandler()) and vgf.GetVMonster(tp):IsSetCard(0xe8)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	vgf.Sendto(LOCATION_SOUL,e:GetHandler(),vgf.GetVMonster(tp))
	e:Reset()
end
