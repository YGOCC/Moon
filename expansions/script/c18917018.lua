--Supersonic Epee
local ref=_G['c'..18917018]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
	
	--Banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(ref.rmtg)
	e1:SetOperation(ref.rmop)
	c:RegisterEffect(e1)
end

ref.bloom = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end
function ref.material(c)
	return true
end

function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if chk==0 then return c==a and t~=nil and t:IsAbleToRemove() end
	e:SetLabel(0)
	if t:IsStatus(STATUS_BATTLE_DESTROYED) then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,t,1,0,0)
end
function ref.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if tc:IsRelateToBattle() and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0
	and e:GetLabel()==1 and Duel.IsExistingMatchingCard(ref.rmfilter,tp,0,LOCATION_MZONE,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(18917018,0)) then
		local g=Duel.SelectMatchingCard(tp,ref.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
