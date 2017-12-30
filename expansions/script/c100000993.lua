 --Created and coded by Rising Phoenix
function c100000993.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,41578483,64631466,63519819,false,false)
	--spsummon condition
		--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(63519819)
	c:RegisterEffect(e1)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_SPSUMMON_CONDITION)
	e10:SetValue(aux.fuslimit)
	c:RegisterEffect(e10)
		--battle indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
		--reflect battle dam
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
		--Equip
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(100000993,0))
	e13:SetCategory(CATEGORY_EQUIP)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetCountLimit(1)
	e13:SetTarget(c100000993.eqtg)
	e13:SetOperation(c100000993.eqop)
	c:RegisterEffect(e13)
	--atk
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_SINGLE)
	e23:SetCode(EFFECT_UPDATE_ATTACK)
	e23:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e23:SetRange(LOCATION_MZONE)
	e23:SetValue(c100000993.atkval)
	c:RegisterEffect(e23)
	-- def
	local e24=e23:Clone()
	e24:SetCode(EFFECT_UPDATE_DEFENSE)
	e24:SetValue(c100000993.defval)
	c:RegisterEffect(e24)
		--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000993,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100000993.cbcon)
	e2:SetTarget(c100000993.cbtg)
	e2:SetOperation(c100000993.cbop)
	c:RegisterEffect(e2)
end
function c100000993.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return r~=REASON_REPLACE and c~=bt and bt:GetControler()==c:GetControler()
end
function c100000993.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():GetAttackableTarget():IsContains(e:GetHandler()) end
end
function c100000993.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeAttackTarget(c)
	end
end
function c100000993.eqfilter(c)
	return c:IsAbleToChangeControler() and c:IsType(TYPE_MONSTER)
end
function c100000993.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c100000993.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100000993.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100000993.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100000993.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c100000993.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then end
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(100000993,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c100000993.eqlimit)
			tc:RegisterEffect(e1)
	end
end
function c100000993.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(100000993)~=0 and tc:IsFaceup() and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()
		end
		tc=g:GetNext()
	end
	return atk
end
function c100000993.defval(e,c)
	local def=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(100000993)~=0 and tc:IsFaceup() and tc:GetDefense()>=0 then
			def=def+tc:GetDefense()
		end
		tc=g:GetNext()
	end
	return def
end