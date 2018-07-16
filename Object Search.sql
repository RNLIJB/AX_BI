--Declare @Location VarChar(100)
--SET @Location = 
--Filter out the reuslts by getting the user to select the parent location in another table
--More thought needs to go into the Parent Object (or consider having an Object Name and Parent Location), this is because the Tractor is a Parent Object but would be used for a boat

Select Tmp.ObjectRecID, Tmp.OID as ObjectID, Tmp.ParentObjectName, FunctionalLocationName, ParentFunctionalLocation
From
(	select
		OT2.RecID as ObjectRecID,
		OT2.ObjectID as OID,
		OT2.Name as ParentObjectName,
		FL.NAME as FunctionalLocationName,
		FL2.NAME as AllocatedFunctionalLocationName,
		FL3.Name as ParentFunctionalLocation,
		POT.NAME as ObjectTypeName,
		OT.*
	from mroobjecttable OT
		left outer join mrofunctionallocation fl on fl.recid = OT.FUNCTIONALLOCATION
		left outer join mrofunctionallocation fl2 on fl2.recid = OT.ALLOCATEDFUNCTIONALLOCATION
		left outer join mrofunctionallocation fl3 on fl.PARENTFUNCTIONALLOCATION = FL3.recID
		left outer join MROPARMFUNCTIONALLOCATIONTYPE LT on LT.RECID = FL.RECID 
		left outer join mroobjecttable OT2 on OT.PARENTOBJECT = OT2.RECID
		left outer join MROPARMOBJECTTYPE POT on POT.RecID = OT.ObjectType
	where OT2.PARENTOBJECT IS NOT NULL --AND ParentFunctionalLocation = @Location
) as Tmp
WHERE ParentFunctionalLocation IS NOT NULL
Group By ObjectRecID, OID, ParentObjectName, FunctionalLocationName, ParentFunctionalLocation
Order By ParentFunctionalLocation