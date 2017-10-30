--Royal Raid Railway
function c90000037.initial_effect(c)
	--Copy Level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,90000037)
	e1:SetTarget(c90000037.target1)
	e1:SetOperation(c90000037.operation1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,90000037)
	e3:SetCondition(c90000037.condition3)
	e3:SetTarget(c90000037.target1)
	e3:SetOperation(c90000037.operation1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Attach
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(90000037,0))
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c90000037.condition5)
	e5:SetTarget(c90000037.target5)
	e5:SetOperation(c90000037.operation5)
	c:RegisterEffect(e5)
end
function c90000037.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1c) and c:IsLevelAbove(1)
end
function c90000037.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000037.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c90000037.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90000037.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c90000037.filter1,tp,LOCATION_MZONE,0,tc)
		local lv=g:GetFirst()
		while lv~=nil do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetLevel())
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			lv:RegisterEffect(e1)
			lv=g:GetNext()
		end
	end
end
function c90000037.filter3(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1c) and c:IsControler(tp)
end
function c90000037.condition3(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c90000037.filter3,1,nil,tp)
end
function c90000037.condition5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c90000037.filter5(c)
	return c:IsSetCard(0x1c) and c:IsType(TYPE_MONSTER)
end
function c90000037.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000037.filter5,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c90000037.operation5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c90000037.filter5,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
	end
end