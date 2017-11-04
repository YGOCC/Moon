--Accelerate
--Design and code by Kindrindra
local ref=_G['c'..28915502]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(ref.chk)
		Duel.RegisterEffect(ge1,0)
	end

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)

end
ref.blink=true
function ref.material1(c,e,tp,eg,ep,ev,re,r,rp)
	local ae=c:GetActivateEffect()
	local ftg=ae:GetTarget()
	return c:GetType()==TYPE_SPELL and c:CheckActivateEffect(false,true,false)~=nil
		and (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,0))
end
function ref.material2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,555)
	Duel.CreateToken(1-tp,555)
end

function ref.acttg(e,tp,eg,ep,ev,re,r,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=c:GetMaterial():Filter(ref.material1,nil)
	local mc=nil
	if mg:GetCount()>1 then
		mc=mg:Select(tp,1,1,nil):GetFirst()
	else
		mc=mg:GetFirst()
	end
	e:SetLabelObject(mc)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	end
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local mc=e:GetLabelObject()
	local ae=mc:GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end

--[[ref.ODDcount=9
ref.ODDcategory=CATEGORY_DESTROY
function ref.ODDcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function ref.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown()
		and c:IsDestructable()
end
function ref.ODDtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(ref.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function ref.ODDop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end]]
