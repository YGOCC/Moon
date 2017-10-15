--Mysterious Dragon
function c533116.initial_effect(c)
	--Protect myserty
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(533116,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c533116.destg3)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--effect change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(533116,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c533116.remtg)
	e2:SetOperation(c533116.remop)
	c:RegisterEffect(e2)
	if not c533116.global_check then
		c533116.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(326)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c533116.chk)
		Duel.RegisterEffect(ge2,0)
	end
		--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(533116,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c533116.lvtg)
	e3:SetOperation(c533116.lvop)
	c:RegisterEffect(e3)
end
c533116.pandemonium=true
c533116.pandemonium_lscale=9
function c533116.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c533116.destg3(e,c)
	return c:IsFaceup() and c:IsSetCard(0xCF6) and c:IsReason(REASON_EFFECT)
end
function c533116.rfilter(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsLocation(LOCATION_EXTRA) 
		or c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToRemove()
end
function c533116.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x16) and chkc:IsType(TYPE_MONSTER) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingMatchingCard(c533116.rfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c533116.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c533116.rfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		c:CopyEffect(g:GetFirst():GetCode(),RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
end
end
function c533116.filter(c)
	return c:IsFaceup()
end
function c533116.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c533116.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c533116.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c533116.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local t={}
	local i=1
	local p=1
	local lv=g:GetFirst():GetLevel()
	for i=1,7 do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c533116.lvop(e,tp,eg,ep,ev,re,r,rp)
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