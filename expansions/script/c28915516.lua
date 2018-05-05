--Guardian of the Forests,
--Design and code by Kindrindra
local ref=_G['c'..28915516]
function ref.initial_effect(c)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetRange(0xff)
	ge1:SetCountLimit(1,555+EFFECT_COUNT_CODE_DUEL)
	ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	ge1:SetOperation(ref.chk)
	c:RegisterEffect(ge1,tp)
	
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_ADJUST)
	ge2:SetRange(0xff)
	ge2:SetCountLimit(1,28915516+EFFECT_COUNT_CODE_DUEL)
	ge2:SetOperation(ref.tokenrulereg)
	c:RegisterEffect(ge2)
	
	--Xyz Monster
	aux.AddXyzProcedure(c,nil,1,2)
	--c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28915516)
	e1:SetCondition(ref.sscon1)
	e1:SetTarget(ref.regtg)
	e1:SetOperation(ref.regop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(ref.sscon2)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(ref.drtg)
	e3:SetOperation(ref.drop)
	c:RegisterEffect(e3)
end
ref.burst=true
ref.USummonLevel=1
function ref.trapmaterial(c)
	return true
end
function ref.monmaterial(c)
	return true
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,555,nil,nil,nil,nil,nil,nil)		
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Remove(token,POS_FACEUP,REASON_RULE)
end

--Special Summon
function ref.tokenrulereg(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(0)
	e1:SetCondition(ref.tokencon)
	e1:SetTarget(ref.atktg)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_DEFENSE)
	e2:SetCondition(ref.tokencon)
	e2:SetTarget(ref.postg)
	Duel.RegisterEffect(e2,tp)
end
function ref.sscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA --e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+0x555
end
function ref.sscon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function ref.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function ref.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(ref.sscon)
	e1:SetOperation(ref.ssop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,28915517,0,0x4011,0,0,3,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,28915517)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function ref.tokencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,28915517)
end
function ref.postg(e,c)
	return not (c:IsDefensePos() or c:GetLevel()>unlock_level)
end
function ref.getfieldlevel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lv=0
	local c=g:GetFirst()
	while c do
		lv = c:GetLevel()+lv
		c = g:GetNext()
	end
	return lv
end
function ref.atktg(e,c)
	return not (c:GetLevel()>4)
end

--Draw
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(28915516,1)) then
			e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
