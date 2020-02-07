--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	if not PENDULUM_CHECKLIST then
		PENDULUM_CHECKLIST=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(aux.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local ge2=Effect.CreateEffect(c)
	ge2:SetDescription(1160)
	ge2:SetType(EFFECT_TYPE_ACTIVATE)
	ge2:SetCode(EVENT_FREE_CHAIN)
	ge2:SetRange(LOCATION_HAND)
	c:RegisterEffect(ge2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cid.splimit)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cid.PendCondition)
	e1:SetOperation(cid.PendOperation)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,id)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetTarget(cid.tg)
	e3:SetOperation(cid.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetTarget(cid.target)
	e5:SetOperation(cid.operation)
	c:RegisterEffect(e5)
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc97) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cid.PConditionFilter(c,e,tp,tc,eset)
	local seq=tc:GetSequence()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,seq==4 and 0 or 1)
	local lscale=seq==0 and tc:GetLeftScale() or tc:GetLeftScale()
	local rscale=1-seq==1 and rpz:GetRightScale() or rpz:GetLeftScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	return c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() and c:IsSetCard(0xc97)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) or aux.PConditionFilter(c,e,tp,lscale,rscale,eset)
end
function cid.PendCondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if PENDULUM_CHECKLIST&(0x1<<tp)~=0 and #eset==0 then return false end
	local seq=c:GetSequence()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,seq==4 and 0 or 1)
	if rpz==nil then return false end
	local lscale=seq==0 and c:GetLeftScale() or c:GetLeftScale()
	local rscale=1-seq==1 and rpz:GetRightScale() or rpz:GetLeftScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then loc=loc+LOCATION_REMOVED end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	if aux.PendCondition()(e,c,og) then return true end
	return g:IsExists(cid.PConditionFilter,1,nil,e,tp,c,{})
end
function cid.PendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local seq=c:GetSequence()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,seq==4 and 0 or 1)
	local lscale=seq==0 and c:GetLeftScale() or c:GetLeftScale()
	local rscale=1-seq==1 and rpz:GetRightScale() or rpz:GetLeftScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local tg=nil
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=cid and Duel.IsPlayerAffectedByEffect(tp,id) and cid[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,id) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	if ft1>0 then loc=loc|LOCATION_HAND end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then loc=loc|LOCATION_REMOVED end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(cid.PConditionFilter,nil,e,tp,c,eset)
	else
		tg=Duel.GetMatchingGroup(cid.PConditionFilter,tp,loc,0,nil,e,tp,c,eset)
	end
	local ce=nil
	local b1=PENDULUM_CHECKLIST&(0x1<<tp)==0
	local b2=#eset>0
	if b1 and b2 then
		local options={1163}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		if op>0 then
			ce=eset[op]
		end
	elseif b2 and not b1 then
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		ce=eset[op+1]
	end
	if ce then
		tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
	aux.GCheckAdditional=nil
	if not g then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:Reset()
	else
		PENDULUM_CHECKLIST=PENDULUM_CHECKLIST|(0x1<<tp)
	end
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
function cid.filter(c)
	return c:IsSetCard(0xc97) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsType(TYPE_PENDULUM+TYPE_PANDEMONIUM) and c:IsAbleToHand()
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,2,2,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden() end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsForbidden() then return end
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if b1 and Duel.SelectOption(tp,1160,1105)==0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SelectOption(tp,1105)
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
	end
end
