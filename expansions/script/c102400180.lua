--created & coded by Lyris, art at
--フェイツ・デスガイ
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.PandSSetCon(c,0))
	e1:SetOperation(cid.ssetop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetOperation(function(e)
		local c=e:GetHandler()
		if c:GetOriginalType()==TYPE_TRAP then
			c:AddMonsterAttribute(TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
			c:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(0)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCode(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(cid.rlevel)
	c:RegisterEffect(e3)
end
function cid.ssetop(e,tp,eg,ep,ev,re,r,rp,c)
	c:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
	Duel.SSet(c:GetControler(),c)
end
function cid.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if e:GetHandler():IsLocation(LOCATION_SZONE) then lv=e:GetHandler():GetOriginalLevel() end
	if c:IsSetCard(0xf7a) and not c:IsCode(id) then
		local clv=c:GetLevel()
		return lv*(0x1<<16)+clv
	else return lv end
end
function cid.filter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and (aux.PandSSetCon(c,-1)(c,e,tp,eg,ep,ev,re,r,rp) or c:IsAbleToHand())
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	if not tc then return end
	local b1,b2=tc:IsAbleToHand(),aux.PandSSetCon(tc,-1)(tc,e,tp,eg,ep,ev,re,r,rp)
	if b1 and (not b2 or Duel.SelectOption(tp,1190,1159)==0) then Duel.SendtoHand(tc,nil,REASON_EFFECT)
	elseif b2 then
		tc:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
		Duel.SSet(tp,tc)
	else return end
	Duel.ConfirmCards(1-tp,tc)
end
