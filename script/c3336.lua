--Girl Of The Skies: Alpha
function c3336.initial_effect(c)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3336,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c3336.sycon)
	e2:SetTarget(c3336.detg)
	e2:SetOperation(c3336.deop)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c3336.detg)
	e4:SetOperation(c3336.deop)
	c:RegisterEffect(e4)
end

function c3336.sycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==(REASON_SYNCHRO)
end
function c3336.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c3336.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,3330,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,3330)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.SpecialSummonComplete()
		ft=ft-1
	end
	if ft>0 and Duel.SelectYesNo(tp,aux.Stringid(3336,1)) then
		local token=Duel.CreateToken(tp,3330)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end