--Bad Goblin Mess
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local sscard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return sscard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(scard.seqtg)
	e1:SetOperation(scard.seqop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--While in GY
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetValue(9744376)
	c:RegisterEffect(e3)
end
function scard.filter(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function scard.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and scard.filter(chkc,1-tp) end
	if chk==0 then return Duel.IsExistingTarget(scard.filter,1-tp,LOCATION_MZONE,0,1,nil,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(s_id,1))
	Duel.SelectTarget(tp,scard.filter,1-tp,LOCATION_MZONE,0,1,1,nil,1-tp)
end
function scard.seqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsControler(1-tp) then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	if (seq>0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq+1)) then
		local flag=0
		if seq>0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
		flag=bit.lshift(bit.bxor(flag,0xff),16)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=bit.rshift(Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag),16)
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(tc,nseq)
	end
end
