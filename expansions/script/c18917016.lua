--Magikitten
local ref=_G['c'..18917016]
function ref.initial_effect(c)
	c:SetUniqueOnField(1,0,18917016)
	--SpSummon Proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(ref.spcon)
	c:RegisterEffect(e1)
	--Top Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(ref.drcon)
	e3:SetTarget(ref.drtg)
	e3:SetOperation(ref.drop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	
	--Salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,18917016)
	e2:SetCondition(ref.thcon)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
end
function ref.spfilter(c)
	return c:IsFaceup() and c.bloom
end
function ref.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(ref.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function ref.drfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function ref.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return false end
		local g=Duel.GetDecktopGroup(tp,1)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=tp
	Duel.ConfirmDecktop(p,1)
	local tc=Duel.GetDecktopGroup(p,1):GetFirst()
	if ref.drfilter(tc) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.ShuffleDeck(tp)
	end
end

function ref.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
		and e:GetHandler():GetReasonCard():IsRace(RACE_SPELLCASTER)
end
function ref.filter(c)
	return c:IsType(TYPE_MONSTER) and c.seedling and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end