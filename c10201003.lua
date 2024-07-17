-- 【自】：这个单位被「华美的旋律 蕾奎缇娜」RIDE时，你可以将这张卡CALL到R上。
-- 【永】【R】：这个单位支援先导者的战斗中，这个单位的力量+5000。

local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)

	vgd.BeRidedByCard(c,m,10201002,cm.operation,nil)
	vgd.EffectTypeTrigger(c,m,LOCATION_MZONE,EFFECT_TYPE_FIELD,EVENT_CUSTOM+EVENT_SUPPORT,cm.operation2,nil,cm.condition3)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	vgf.Call(c,0,tp)

end

function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- if c:IsRelateToEffect() then
		VgF.AtkUp(c,c,5000,EVENT_BATTLED)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetOperation(cm.operation3)
		c:RegisterEffect(e1)
	-- end
end

function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end