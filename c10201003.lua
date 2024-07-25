
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	vgd.BeRidedByCard(c,m,10201002,cm.operation)
	vgd.EffectTypeContinuousChangeAttack(c,EFFECT_TYPE_SINGLE,5000,cm.con)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	vgf.Call(c,0,tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.VMonsterFilter(Duel.GetAttacker()) and c:GetFlagEffect(FLAG_SUPPORT)>0 and vgf.RMonsterCondition(e)
end