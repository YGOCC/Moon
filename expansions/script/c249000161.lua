--Defender Mecha - Solar Striker
function c249000161.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7572887,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(c249000161.target)
	e2:SetOperation(c249000161.operation)
	c:RegisterEffect(e2)
	--summon with 1 tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(58554959,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c249000161.otcon)
	e3:SetOperation(c249000161.otop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
end
function c249000161.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c249000161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToBattle() then return false end
	if not e:GetHandler()==Duel.GetAttacker() then return false end
	if chkc then return chkc:IsOnField() and c249000161.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000161.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c249000161.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000161.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end	
end
function c249000161.otcon(e,c,minc)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>1
		and c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1)
end
function c249000161.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectTribute(tp,c,1,1)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end