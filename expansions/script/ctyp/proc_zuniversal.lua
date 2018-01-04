--Not yet finalized values
--Custom constants
TYPE_CUSTOM								=TYPE_EVOLUTE+TYPE_PANDEMONIUM+TYPE_POLARITY+TYPE_SPATIAL

CTYPE_CUSTOM							=CTYPE_EVOLUTE+CTYPE_PANDEMONIUM+CTYPE_POLARITY+CTYPE_SPATIAL

--Custom Type Tables
Auxiliary.Customs={} --check if card uses custom type, indexing card

--overwrite constants
TYPE_EXTRA=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_EVOLUTE+TYPE_POLARITY+TYPE_SPATIAL

--Custom Functions
function Card.IsCustomType(c,tpe,scard,sumtype,p)
	return c:GetType(scard,sumtype,p)&tpe>0
end

--overwrite functions
local is_type = Card.IsType

Card.IsType=function(c,tpe,scard,sumtype,p)
	local custpe=tpe>>32
	local otpe=tpe&0xffffffff
	if (scard and is_type(c,otpe,scard,sumtype,p)) or (not scard and is_type(c,otpe)) then return true end
	if custpe<=0 then return false end
	return c:IsCustomType(custpe,scard,sumtype,p)
end
