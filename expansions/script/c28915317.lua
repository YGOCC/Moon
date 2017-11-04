--Rostella
--Design and Code by Kindrindra--
local ref=_G['c'..28915317]
function ref.initial_effect(c)
	--Summon Other+Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28915317,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(ref.sptg)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--Level Alter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915317,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.lvtg)
	e2:SetOperation(ref.lvop)
	c:RegisterEffect(e2)
	--Summon Self
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,28915317)
	e4:SetCondition(ref.sscon)
	e4:SetTarget(ref.sstg)
	e4:SetOperation(ref.ssop)
	c:RegisterEffect(e4)
end

function ref.ssfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x72C) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.ssfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function ref.lvfilter(c)
	return c:IsFaceup() and not c:IsCode(28915317) and c:GetLevel()>0
end
function ref.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,ref.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local t={}
	local i=4
	local p=1
	local lv=g:GetFirst():GetLevel()
	for i=4,6 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function ref.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function ref.sscfilter(c)
	return c:IsSetCard(0x72D) and c:IsType(TYPE_MONSTER)
end
function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.sscfilter,1,nil)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	--[[local t={}
	local i=1
	local p=1
	local lv=c:GetLevel()
	for i=1,5 do
		t[p]=i p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))]]
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		--[[local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)]]
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x47e0000)
		e2:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e2)
	end
end
