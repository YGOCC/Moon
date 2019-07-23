--Cosmic Wing Emperor Neo Nebula by TKNight

function c911.initial_effect(c) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c911.ffilter,5,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	
		--move to main monster zone from EZM (NOTE: It can move itself to another free MMZ while it is Special Summoned to a MMZ)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7093411,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c911.mcon,c911.filter)
	e2:SetTarget(c911.mtg)
	e2:SetOperation(c911.mop)
	c:RegisterEffect(e2) 
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74586817,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c911.tgcon)
	e2:SetTarget(c911.eqtg)
	e2:SetOperation(c911.eqop)
	c:RegisterEffect(e2)
	end
	function c911.ffilter(c)
	return c:IsFusionSetCard(0xB3F) 
end
--move effect
function c911.filter(c)
	return c:GetSequence()>5 and c:IsLocation(LOCATION_MZONE)
end
--move to main monster zone from EZM condition, target and operation
function c911.mcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)-- and e:GetHandler():GetSequence()>5 
    or e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)-- and e:GetHandler():GetSequence()>5
end

function c911.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c911.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			nseq=math.log(s,2)
			Duel.MoveSequence(c,nseq)
	end
end

--equip effect
function c911.eqfilter(c)
	return c:IsType(TYPE_UNION) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c911.cfilter(c)
	return c:GetSequence()>=5
end
function c911.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and not Duel.IsExistingMatchingCard(c911.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c911.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c911.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c911.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c911.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c911.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c911.eqlimit(e,c)
	return e:GetOwner()==c
end