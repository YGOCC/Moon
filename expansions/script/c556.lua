--Auxiliary (Charge Effect Number)
local ref=_G['c'..556]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
	end
end

function ref.Charge(tc,rc,tp,e,reset,reason)
	Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+556,e,reason,tp,0,0)
	tc:RegisterFlagEffect(556,RESET_EVENT+0xfe0000+reset,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(556,0))
	--tc:RegisterFlagEffect(556,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function ref.RemoveCharge(tc,c,tp,e,reason)
	Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+557,e,reason,tp,0,0)
end
function ref.IsCharged(tc)
	return not (Card.GetFlagEffect(tc,556)==0)
end
function ref.IsNotCharged(tc)
	return Card.GetFlagEffect(tc,556)==0
end
function ref.chargedcon(e,tp,eg,ep,ev,re,r,rp)
	return ref.IsCharged(e:GetHandler())
end
function ref.CanBeCharged(tc)
	return tc:IsFaceup()
end

function ref.Freeze(tc,c,reason,rp,e)
	local p=tc:GetControler()
	if not (Duel.GetLocationCount(p,LOCATION_SZONE)>0) then return end
	Duel.MoveToField(tc,rp,p,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(558)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
	tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(556,1))
	Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+558,e,reason,rp,0,0)
end
function ref.IsFreezable(tc)
	local p=tc:GetControler()
	return Duel.GetLocationCount(p,LOCATION_SZONE)>0
end
function ref.IsFrozen(tc)
	return tc:IsHasEffect(558)
end

function ref.selfrmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
