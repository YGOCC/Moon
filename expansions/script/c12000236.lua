--Tera Gaia the Game Master
function c12000236.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000236,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c12000236.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--reduce level to search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000236,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12000236.thtg)
	e2:SetOperation(c12000236.thop)
	c:RegisterEffect(e2)
	--excavate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12000236,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12000236)
	e3:SetCondition(c12000236.excon1)
	e3:SetTarget(c12000236.extg)
	e3:SetOperation(c12000236.exop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RELEASE)
	e4:SetCondition(c12000236.excon2)
	c:RegisterEffect(e4)
	--register level before leaving the field
	local reg=Effect.CreateEffect(c)
	reg:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	reg:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	reg:SetCode(EVENT_LEAVE_FIELD_P)
	reg:SetLabelObject(e3)
	reg:SetCondition(c12000236.regcon)
	reg:SetOperation(c12000236.register)
	c:RegisterEffect(reg)
	--reset labels
	local res=Effect.CreateEffect(c)
	res:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	res:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	res:SetCode(EVENT_SUMMON)
	res:SetLabelObject(e3)
	res:SetCondition(c12000236.resetcon)
	res:SetOperation(c12000236.reset)
	c:RegisterEffect(res)
	local r2=res:Clone()
	r2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(r2)
	local r3=res:Clone()
	r3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(r3)
	local r4=res:Clone()
	r4:SetCode(EVENT_MSET)
	c:RegisterEffect(r4)
	local r5=res:Clone()
	r5:SetCode(EVENT_TO_GRAVE)
	r5:SetCondition(c12000236.exception)
	c:RegisterEffect(r5)
	local r6=res:Clone()
	r6:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(r6)
	local r7=res:Clone()
	r7:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(r7)
	local r8=res:Clone()
	r8:SetCode(EVENT_TURN_END)
	c:RegisterEffect(r8)
end
--register level
--In case the eff doesn't work, try putting out this "regcon" and "reg:SetCondition(c1.regcon)"
function c12000236.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_LINK)
end
function c12000236.register(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabelObject()
	lab:SetLabel(c:GetLevel())
end
--reset
function c12000236.resetcon(e)
	local effect=e:GetLabelObject()
	return effect:GetLabel()>0
end
function c12000236.exception(e,re)
	local c=e:GetHandler()
	local effect=e:GetLabelObject()
    return re and effect:GetLabel()>0
        and not (c:IsReason(REASON_LINK) or
        (c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x856)
        and re:GetHandler():IsType(TYPE_LINK)))
end
function c12000236.reset(e)
	local effect=e:GetLabelObject()
	effect:SetLabel(0)
end
--effects
function c12000236.cfilter(c)
	return c:IsFaceup() and c:IsCode(12000242)
end
function c12000236.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12000236.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c12000236.thfilter(c,lv)
	return c:IsSetCard(0x856) and c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c12000236.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()-1
	if chk==0 then return Duel.IsExistingMatchingCard(c12000236.thfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000236.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelBelow(1) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local lv=c:GetLevel()
	local g=Duel.SelectMatchingCard(tp,c12000236.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12000236.excon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x856)
		and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000236.excon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x856)
		and re:GetHandler():IsType(TYPE_LINK) and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
		and e:GetLabel()>0
end
function c12000236.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59305593) end
end
function c12000236.exop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.ConfirmDecktop(tp,lv)
	local g=Duel.GetDecktopGroup(tp,lv)
	if g:GetCount()>0 then
		if g:IsExists(Card.IsSetCard,1,nil,0x856) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x856)
			if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
		end
		Duel.ShuffleDeck(tp)
	end
	e:SetLabel(0)
end
