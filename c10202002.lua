--魔石龙 珠艾尼尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	vgf.VgCard(c)
	--【自】【V/R】：这个单位的攻击击中先导者时，灵魂填充1。
	vgd.EffectTypeTriggerWhenHitting(c,m,LOCATION_MZONE,EFFECT_TYPE_SINGLE,cm.operation,nil,cm.condition)
	--【自】：这个单位被含有「道拉珠艾尔德」的单位RIDE时，灵魂填充1，你的灵魂里有3张以上的相互不同等级的卡的话，抽1张卡。
	--目前条件设置为被「拥宝之龙牙 道拉珠艾尔德」Ride时发动
	vgd.BeRidedByCard(c,m,10202001,cm.operation2,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.Overlay(e:GetHandler(),Duel.GetDecktopGroup(tp,1))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return vgf.VMonsterFilter(Duel.GetAttackTarget())
end

function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DisableShuffleCheck()
	Duel.Overlay(c,Duel.GetDecktopGroup(tp,1))
	if(Drajewlcheck(c,3))
	then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function Drajewlcheck(c,target)
	local g = c:GetOverlayGroup()
	local levelnum = {0,0,0,0,0}
	if g:GetCount()>0 then
		for tc in VgF.Next(g) do
    		if tc:IsLevel(0) and levelnum[0]==0
    		then
    			levelnum[0]=1
    		elseif tc:IsLevel(1) and levelnum[1]==0
    		then
 		   		levelnum[1]=1
	    	elseif tc:IsLevel(2) and levelnum[2]==0
	    	then
	    		levelnum[2]=1
	    	elseif tc:IsLevel(3) and levelnum[3]==0
	    	then
	    		levelnum[3]=1
	    	elseif tc:IsLevel(4) and levelnum[4]==0
	    	then
	    		levelnum[4]=1
	    	end
		end
	end
	local sum=0
	for i2,value in ipairs(levelnum) do
		sum=sum+value
	end
	return sum>=target
end
