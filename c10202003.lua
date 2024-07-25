--珠宝核龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】：这个单位被「魔石龙 珠艾尼尔」骑升时，将这张卡召唤到R上。
	vgd.BeRidedByCard(c,m,10202002,cm.operation)
	--【自】【R】：这个单位攻击或支援时，这次战斗中，这个单位的力量+5000。这次战斗结束时，将这个单位放置到灵魂里。（这个效果为强制执行。）
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation2,nil,cm.condition2)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation2,nil,cm.condition3)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:IsRelateToEffect(e) and vgf.IsCanBeCalled(c,e,tp) then
		vgf.Sendto(LOCATION_MZONE,c,0,tp)
	end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=vgf.AtkUp(c,c,5000)
		vgf.EffectReset(c,e2,EVENT_BATTLED)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetOperation(cm.operation3)
		c:RegisterEffect(e1)
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return vgf.RMonsterFilter(e:GetHandler()) and Duel.GetAttacker()==e:GetHandler()
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	vgf.Sendto(LOCATION_OVERLAY,e:GetHandler(),vgf.GetVMonster(tp))
	e:Reset()
end
