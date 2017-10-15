--Digimon Black Gears
function c47000038.initial_effect(c)
	aux.AddEquipProcedure(c,1,Card.IsControlerCanBeChanged,c47000038.eqlimit,nil,c47000038.target)
		--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c47000038.descon)
	c:RegisterEffect(e3)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_SET_CONTROL)
	e5:SetValue(c47000038.ctval)
	c:RegisterEffect(e5)
end
function c47000038.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end
function c47000038.target(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,Duel.GetFirstTarget(),1,0,0)
end
function c47000038.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6E7) and c:IsType(TYPE_MONSTER) 
end
function c47000038.descon(e)
	return not Duel.IsExistingMatchingCard(c47000038.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c47000038.ctval(e,c)
	return e:GetHandlerPlayer()
end

