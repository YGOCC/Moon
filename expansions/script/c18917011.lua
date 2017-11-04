--Silencia
local ref=_G['c'..18917011]
function ref.initial_effect(c)
	--ATK Gain
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(ref.atktg)
	e1:SetOperation(ref.atkop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
	--Material Grant
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(ref.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function ref.exfilter(c)
	return c.transform and Duel.IsExistingMatchingCard(ref.matfilter1,c:GetControler(),LOCATION_GRAVE,0,1,nil,c)
end
function ref.matfilter1(c,rc)
	return rc.material1 and rc.material1(c) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(ref.matfilter2,c:GetControler(),LOCATION_GRAVE,0,1,c,c)
end
function ref.matfilter2(c,rc)
	return rc.material2 and rc.material2(c)
		and c:IsAbleToRemoveAsCost()
end
function ref.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,ref.exfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mc1=Duel.SelectMatchingCard(tp,ref.matfilter1,tp,LOCATION_GRAVE,0,1,1,nil,g:GetFirst()):GetFirst()
	local mc2=Duel.SelectMatchingCard(tp,ref.matfilter2,tp,LOCATION_GRAVE,0,1,1,mc1,g:GetFirst()):GetFirst()
	local mg=Group.FromCards(mc1,mc2)
	e:SetLabel(Duel.Remove(mg,POS_FACEUP,REASON_COST))
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local val=e:GetLabel()*600
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end

function ref.thfilter(c)
	return (c:IsCode(18917005) or c:IsCode(18917008))
		and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function ref.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc.transform and tc:GetFlagEffect(18917011)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetCondition(ref.codecon)
			e1:SetValue(ref.atkval)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetCondition(ref.codecon)
			e2:SetValue(ATTRIBUTE_DARK)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e3,true)
			tc:RegisterFlagEffect(18917011,0,0,1)
		end
		tc=eg:GetNext()
	end
end
function ref.codecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,18917011)
end
function ref.atkval(e,c)
	return e:GetHandler():GetOverlayCount()*500
end