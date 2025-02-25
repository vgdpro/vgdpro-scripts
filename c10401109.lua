local cm,m,o=GetID()
--液压撞击龙
function cm.initial_effect(c)
	vgd.VgCard(c)
	--【自】【R】：这个单位攻击先导者时，你的封锁区中有指令卡的话，
	--这次战斗中，这个单位的力量+5000。
	vgd.AbilityAuto(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,EVENT_ATTACK_ANNOUNCE,cm.operation,vgf.DamageCost(1),cm.condition)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return vgf.RMonsterCondition and vgf.VMonsterFilter(Duel.GetAttackTarget()) and vgf.IsExistingMatchingCard(cm.filter,tp,LOCATION_LOCK,0,1,nil,TYPE_SPELL)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=vgf.AtkUp(c,c,5000,EVENT_BATTLED)
    vgf.EffectReset(c,e1,EVENT_BATTLED)
end
function cm.filter(c,typ)
	return c:IsType(typ) and c:IsFaceup()
end