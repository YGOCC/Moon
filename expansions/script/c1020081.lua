--Hellscape Beast Urr
function c1020081.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c1020081.fscon)
	e0:SetOperation(c1020081.fsop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c1020081.operation)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1020081,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c1020081.thtg)
	e3:SetOperation(c1020081.thop)
	c:RegisterEffect(e3)
end
function c1020081.filter(c,fc)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsHasEffect(6205579) and c:GetLevel()>=4 and c:IsCanBeFusionMaterial(fc)
end
function c1020081.spfilter(c,mg)
	return mg:IsExists(c1020081.spfilter2,1,c,c)
end
function c1020081.spfilter2(c,mc)
	return not c:IsFusionCode(mc:GetFusionCode())
end
function c1020081.fscon(e,g,gc)
	if g==nil then return true end
	local mg=g:Filter(c1020081.filter,gc,e:GetHandler())
	if gc then return c1020081.filter(gc,e:GetHandler()) and c1020081.spfilter(gc,mg) end
	return mg:IsExists(c1020081.spfilter,1,nil,mg)
end
function c1020081.fsop(e,tp,eg,ep,ev,re,r,rp,gc)
	local mg=eg:Filter(c1020081.filter,gc,e:GetHandler())
	local g1=nil
	local mc=gc
	if not gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g1=mg:FilterSelect(tp,c1020081.spfilter,1,1,nil,mg)
		mc=g1:GetFirst()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(tp,c1020081.spfilter2,1,1,mc,mc)
	if g1 then g2:Merge(g1) end
	Duel.SetFusionMaterial(g2)
end
function c1020081.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=e:GetHandler():GetControler()
	if d==nil then return end
	local tc=nil
	if a:GetControler()==p and a:IsRace(RACE_FIEND) and d:IsStatus(STATUS_BATTLE_DESTROYED) then tc=d
	elseif d:GetControler()==p and d:IsRace(RACE_FIEND) and a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=a end
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e2)
end
function c1020081.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(2073) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1020081.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c1020081.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1020081.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1020081.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c1020081.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsStatus(STATUS_NO_LEVEL) then lv=tc:GetOriginalRank()
		else lv=tc:GetOriginalLevel() end
		Duel.Recover(tp,lv*100,REASON_EFFECT)
	end
end
