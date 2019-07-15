--coded by Lyris
--リレー召喚
--Not yet finalized values
--Custom constants
EFFECT_POINT	=481
TYPE_RELAY		=0x20000000000
TYPE_CUSTOM		=TYPE_CUSTOM|TYPE_RELAY
CTYPE_RELAY		=0x200
CTYPE_CUSTOM	=CTYPE_CUSTOM|CTYPE_RELAY

--Custom Type Table
Auxiliary.Relays={} --number as index = card

--overwrite functions
local get_type, get_orig_type, get_prev_type_field =
Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField

Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Relays[c] then
		tpe=tpe|TYPE_RELAY
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Relays[c] then
		tpe=tpe|TYPE_RELAY
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Relays[c] then
		tpe=tpe|TYPE_RELAY
	end
	return tpe
end

--Custom Functions
function Card.GetPoint(c)
	if not Auxiliary.Relays[c] then return 0 end
	local te=c:IsHasEffect(EFFECT_POINT)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.DisposePoint(c,ct)
	if not Auxiliary.Relays[c] then return 0 end
	local te=c:IsHasEffect(EFFECT_POINT)
	local pt
	if type(te:GetValue())=='function' then
		pt=te:GetValue()(te,c)
	else
		pt=te:GetValue()
	end
	te:SetValue(pt-ct)
end
function Card.CollectPoint(c,ct)
	if not Auxiliary.Relays[c] then return 0 end
	local te=c:IsHasEffect(EFFECT_POINT)
	local pt
	if type(te:GetValue())=='function' then
		pt=te:GetValue()(te,c)
	else
		pt=te:GetValue()
	end
	te:SetValue(pt+ct)
end
function Auxiliary.AddOrigRelayType(c)
	table.insert(Auxiliary.Relays,c)
	Auxiliary.Customs[c]=true
	Auxiliary.Relays[c]=function() return true end
end
function Auxiliary.AddRelayProc(c,point)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_SINGLE)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge1:SetCode(EFFECT_POINT)
	ge1:SetValue(Auxiliary.PointVal(point))
	c:RegisterEffect(ge1)
	local ge4=Effect.CreateEffect(c)
	ge4:SetDescription(aux.Stringid(481,3))
	ge4:SetType(EFFECT_TYPE_FIELD)
	ge4:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge4:SetCountLimit(1,10001000)
	ge4:SetCondition(Auxiliary.RelayCondition())
	ge4:SetOperation(Auxiliary.RelayOperation())
	ge4:SetValue(13)
	Duel.RegisterEffect(ge4,0)
	local ge5=Effect.CreateEffect(c)
	ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge5:SetCode(EVENT_ADJUST)
	ge5:SetRange(LOCATION_MZONE)
	ge5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge5:SetOperation(Auxiliary.RelayPointView)
	c:RegisterEffect(ge5)
	local ge6=ge5:Clone()
	ge6:SetCode(EVENT_CHAIN_SOLVING)
	c:RegisterEffect(ge6)
	local ge7=Effect.CreateEffect(c)
	ge7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge7:SetCode(EFFECT_SEND_REPLACE)
	ge7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge7:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(0)
		local c=e:GetHandler()
		if chk==0 then return c:IsOnField() and c:GetDestination()==LOCATION_DECK end
		if Duel.SelectYesNo(tp,aux.Stringid(c:GetOriginalCode(),0)) then
			e:SetLabel(1)
		end
		return false
	end)
	c:RegisterEffect(ge7)
	if c:IsLocation(LOCATION_EXTRA) then
		local ge8=Effect.CreateEffect(c)
		ge8:SetType(EFFECT_TYPE_SINGLE)
		ge8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge8:SetCode(EFFECT_CANNOT_TO_DECK)
		ge8:SetCondition(function(e) return e:GetHandler():GetDestination()==LOCATION_GRAVE end)
		c:RegisterEffect(ge8)
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EFFECT_SEND_REPLACE)
		ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge0:SetLabelObject(ge7)
		ge0:SetTarget(Auxiliary.RelayEnableExtra)
		ge0:SetOperation(function(e,tp,eg,ep,ev,er,r,rp) Duel.SendtoExtraP(e:GetHandler(),nil,r) end)
		c:RegisterEffect(ge0)
	else
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_TO_DECK)
		ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge0:SetLabel(0)
		ge0:SetLabelObject(ge7)
		ge0:SetTarget(Auxiliary.RelayEnableMain)
		c:RegisterEffect(ge0)
	end
end
function Auxiliary.PointVal(pt)
	return	function(e,c)
				local pt=pt
				--insert modifications here
				return pt
			end
end
function Auxiliary.RelayPointView(e)
	local c=e:GetHandler()
	c:SetHint(CHINT_NUMBER,c:GetPoint())
end
function Auxiliary.RelayEnableExtra(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_DECK
	if mIsExtra(c) then loc=loc+LOCATION_HAND end
	if chk==0 then return c:IsOnField() and c:GetDestination()&loc~=0 and e:GetLabelObject():GetLabel()~=0 end
	return true
end
function Auxiliary.RelayEnableMain(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_ONFIELD) or e:GetLabelObject():GetLabel()==0 then return end
	c:ReverseInDeck()
end
function Auxiliary.ReMatFilter(c)
	return c:GetAttackAnnouncedCount()>0 and c:IsAbleToDeck()
end
function Auxiliary.ReSumFilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_RELAY) and not c:IsForbidden() and c:IsCanBeSpecialSummoned(e,0xd,tp,false,false)
end
function Auxiliary.RelayCondition()
	return  function(e,c)
				local tp=c:GetControler()
				local g=Duel.GetMatchingGroup(Auxiliary.ReMatFilter,tp,LOCATION_MZONE,0,nil,tp)
				if #g==0 then return false end
				local loc=0
				local cg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
				if ft<=-cg then loc=loc+LOCATION_DECK end
				if Duel.GetLocationCountFromEx(tp,tp,cg:Filter(function(c) return c:GetSequence()>5 end,nil))>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				return Duel.IsExistingMatchingCard(Auxiliary.ReSumFilter,tp,loc,0,1,nil,e,tp)
			end
end
function Auxiliary.RelayOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg)
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp)
				local ft=Duel.GetUsableMZoneCount(tp)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				local loc=0
				if ft1>0 then loc=loc+LOCATION_HAND end
				if ft2>0 then loc=loc+LOCATION_EXTRA end
				local ptb={}
				local tg=Duel.GetMatchingGroup(Auxiliary.ReSumFilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
				ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK))
				ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				while true do
					local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
					local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
					local ct=ft
					if ct1>ft1 then ct=math.min(ct,ft1) end
					if ct2>ft2 then ct=math.min(ct,ft2) end
					if ct<=0 then break end
					if #sg>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=tg:Select(tp,1,ct,nil)
					tg=tg-g
					sg=sg+g
					if #g<ct then ft=0 break end
					table.insert(ptb,{[0]=tc,[1]=0})
					sg=sg+tc
					if tc:IsLocation(LOCATION_DECK) then
						ft1=ft1-1
					else
						ft2=ft2-1
					end
					ft=ft-1
				end
				local mg=Duel.GetMatchingGroup(Auxiliary.ReMatFilter,tp,LOCATION_MZONE,0,nil,tp)
				local fg=mg:Filter(Card.IsFacedown,nil)
				if #fg>0 then Duel.ConfirmCards(1-tp,fg) end
				local ptc=Duel.SendtoGrave(mg,REASON_MATERIAL+0x20000000)
				local sc=nil
				local pg=sg:Clone()
				if ptc>=#sg then
					for l=1,#ptb do
						ptb[l][1]=ptb[l][1]+1
					end
					ptc=ptc-#sg
				end
				if ptc>0 then
					for i=1,ptc do
						sc=pg:Select(tp,1,1,nil):GetFirst()
						for j=1,#ptb do
							if ptb[j][0]==sc then ptb[j][1]=ptb[j][1]+1 end
						end
						if #sg>ptc then pg=pg-sc end
					end
				end
				sc=sg:GetFirst()
				while sc do
					local pt=0
					for k=1,#ptb do
						if ptb[k][0]==sc then pt=ptb[k][1] end
					end
					local e2=Effect.CreateEffect(sc)
					e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_SPSUMMON_SUCCESS)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetLabel(pt)
					e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local pt=e:GetLabel()
						if pt==0 then return end
						e:GetHandler():CollectPoint(pt)
					end)
					e2:SetReset(RESET_EVENT+0xfe0000)
					sc:RegisterEffect(e2)
					sc=sg:GetNext()
				end
			end
end
