mvpstudio.cdvkl5vm8weq.ap-southeast-2.rds.amazonaws.com 
USE Keys
GO

--A) Given owner Id, build a stored procedure to find properties info for that owner on dashboard

CREATE PROCEDURE spPropertyInfo @OwnerId1 AS INT
AS

BEGIN

SELECT P.[Name] AS Property, P1.FirstName AS 'Tenant First Name', P1.Lastname AS 'Tenent Last Name', PRP.Amount, TRT.[Name] AS 'Payment Frequency'
FROM Property AS P
INNER JOIN OwnerProperty AS OP ON P.Id = OP.PropertyId
INNER JOIN PropertyRentalPayment AS PRP ON PRP.PropertyId = OP.PropertyId
Inner JOIN TargetRentType AS TRT ON PRP.FrequencyType = TRT.Id
INNER JOIN TenantProperty AS TP ON P.Id =TP.PropertyId 
INNER JOIN Person AS PS ON T2.TenantId=PS.Id
WHERE OP.OwnerId=@OwnerId1

END;



--B) Given owner Id, build a stored procedure to find rental applications info for owner’s rental listing on dashboard.

CREATE PROCEDURE [dbo].[spRentalApplicationInfo] (@OwnerId2 AS INT)

AS

BEGIN

SELECT PS.FirstName, PS.LastName, RA.ApplicationStatusId, RA.CreatedBy 
FROM OwnerProperty AS OP
INNER JOIN Person AS PS ON PS.Id=OP.OwnerId
INNER JOIN RentalApplication AS RA ON PS.Id=RA.PersonId
WHERE OP.OwnerId=@OwnerId2

END;


--(C) Given owner Id, build a stored procedure to find maintenance info for owner’s rental listing on dashboard

CREATE PROCEDURE spMaintenanceInfo @OwnerId3 INT

AS

BEGIN

SELECT PEXP.Description as Description, PEXP.Amount AS Expense, PEXP.DATE  
FROM Property P
INNER JOIN PropertyExpense AS PEXP ON P.Id = PEXP.PropertyId
iNNER JOIN OwnerProperty AS OP ON P.Id=OP.PropertyId
WHERE OP.OwnerId=@OwnerId3

END;

--(D) Given owner Id build a stored procedure to find info for owner’s tenant requests on dashboard

CREATE PROCEDURE spOwnersTenantRequest	@OwnerId4 INT
AS
BEGIN
SELECT OP.OwnerId, TJR.PropertyId, TJR.JobDescription, TJR.JobStatusId, TJR.CreatedBy, TJR.MaxBudget
from Property P
INNER JOIN OwnerProperty AS OP ON P.Id=OP.OwnerId
INNER JOIN TenantJobRequest AS TJR ON property.Id=tjr.PropertyIdF
WHERE OP.OwnerId=@OwnerId4
END;

--(E) Given owner Id build stored procedure to find jobs quotes info for owner’s market jobs on dashboard.
--Rough Work
SELECT * FROM [dbo].[JobQuote]
SELECT * FROM [dbo].[Job];

SELECT jq.amount, jq.status,jq.CreatedBy, jq.note
FROM JobQuote JQ
INNER JOIN Job AS J ON j.Id = jq.Id
WHERE j.PropertyId = ANY (SELECT PropertyId FROM OwnerProperty WHERE OwnerId=352)
--Query Dataset
Amount	Status	  CreatedBy	            Note
99.99	opening	  preethigopi@gmail.com	Please Come Quickly, URGENT
99.99	opening	  preethigopi@gmail.com	Please Come Quickly, URGENT

--Stored Procedure:
CREATE PROCEDURE spMarketJobQuotes @OwnerId5 INT
AS
BEGIN
SET NOCOUNT ON;
SELECT jq.amount, jq.status,jq.CreatedBy, jq.note
FROM JobQuote JQ
INNER JOIN Job AS J ON j.Id = jq.Id
WHERE j.PropertyId = ANY (SELECT PropertyId FROM OwnerProperty WHERE OwnerId=@OwnerId5)
END ;

--(F) Given TENANT ID, build stored procedure to find rental info (payments due, landlord info) for that TENANT on dashboard.

--Rough Work
SELECT  tp.TenantId, op.OwnerId,  tp.PropertyId, tp.PaymentDueDate FROM TenantProperty tp
INNER JOIN OwnerProperty AS op ON (op.PropertyId = tp.PropertyId and tp.TenantId=352)

TenantId	OwnerId	PropertyId	PaymentDueDate
352	        350	    3426	    2
352	        350	    3427	    2
352	        350	    3428	    2
352	        4128	10377	    NULL

--Stored Procedure:

CREATE PROCEDURE spTenantRentalInfo @tenantId INT
AS
BEGIN
SELECT  tp.TenantId, op.OwnerId,  tp.PropertyId, tp.PaymentDueDate FROM TenantProperty tp
INNER JOIN OwnerProperty AS op ON (op.PropertyId = tp.PropertyId and tp.TenantId=@tenantId)
END

--(G) Given TENANT Id, build stored procedure to find rental applications info for that TENANT on dashboard

--Rough Work:
SELECT * FROM Person
SELECT * FROM Tenant

SELECT T.Id, ApplicationStatusId, RA.CreatedBy FROM RentalApplication RA
INNER JOIN Person AS PS ON PS.Id=RA.PersonId
INNER JOIN Tenant AS T ON PS.Id=T.Id
WHERE T.Id=1425

--Dataset fetched

Id	    ApplicationStatusId	CreatedBy
1425	3	                njoh797@aucklanduni.ac.nz
1425	2	                njoh797@aucklanduni.ac.nz
1425	1	                njoh797@aucklanduni.ac.nz
1425	1	                njoh797@aucklanduni.ac.nz

--Stored Procedure:

CREATE PROCEDURE spTenantRentalApplicationInfo2G @TenantId2 INT
AS
BEGIN
SELECT T.Id, ApplicationStatusId, RA.CreatedBy 
FROM RentalApplication RA
INNER JOIN Person AS PS ON PS.Id=RA.PersonId
INNER JOIN Tenant AS T ON PS.Id=T.Id
WHERE T.Id=@TenantId2
END


--(H) Given tenant id, build stored procedure to find info for landlord requests to that tenant on dashboard.

--Rough Work: 

SELECT * FROM PropertyRequest
--WHERE PropertyId=2828
SELECT * FROM TenantProperty

SELECT PR.RequestTypeId, PR.PropertyId, PR.RequestMessage, PR.CreatedOn
FROM PropertyRequest PR
INNER JOIN TenantProperty AS TP ON TP.PropertyId=PR.PropertyId
WHERE TP.TenantId=348 AND PR.PropertyId=2801;

--Fetched dataset:

RequestTypeId	PropertyId	 RequestMessage	    CreatedOn
3	            2801	     dfdfgsdfsdfsdfsd	2009-12-12 00:00:00.000
1	            2801	     CHECKING as	    2009-12-12 00:00:00.000
1	            2801	     NEW POPO	        2010-12-12 00:00:00.000
1	            2801	     Checking1 added	2017-06-08 00:00:00.000


CREATE PROCEDURE spLandlordRequestInfo @tenantId3 INT
AS
BEGIN
SELECT  PR.RequestTypeId, PR.PropertyId, PR.RequestMessage, PR.CreatedOn 
from PropertyRequest PR
INNER JOIN TenantProperty AS tp ON (TP.PropertyId=PR.PropertyId and TP.TenantId =@tenantId3)
END;

--(I) Given service supplier id, build stored procedure to find jobs info for user on dashboard

--Rough work:

SELECT * FROM RentalListing
SELECT * FROM Property
SELECT * FROM OwnerProperty

SELECT RL.PropertyId, RL.TargetRent, RL.AvailableDate, RL.PetsAllowed 
FROM RentalListing RL
INNER JOIN Property P ON (RL.PropertyId = P.Id)
INNER JOIN OwnerProperty OP ON (OP.PropertyId=P.Id and OwnerId =2507)

--Stored Procedure:
CREATE PROCEDURE spOwnerRentalListing @ownerID INT
AS
BEGIN
SELECT RL.PropertyId, RL.TargetRent, RL.AvailableDate, RL.PetsAllowed 
FROM RentalListing RL
INNER JOIN Property P ON (RL.PropertyId = P.Id)
INNER JOIN OwnerProperty OP ON (P.Id=OP.PropertyId and OwnerId =@ownerID)
END

--(J) Given service Supplier ID, build stored procedure to find quotes info for user, on dashboard

--Rough work
SELECT * FROM [dbo].[RentalListing]
SELECT * FROM Property
SELECT * FROM OwnerProperty

SELECT RL.PropertyId, RL.[Description], RL.AvailableDate, RL.TargetRent FROM RentalListing RL
INNER JOIN Property P ON (RL.PropertyId = P.Id)
INNER JOIN OwnerProperty AS op ON (OP.PropertyId = P.Id AND OP.OwnerId=374) 

--Fetched dataset:
PropertyId	Description	AvailableDate	TargetRent
5887	Ready to stay	2018-10-11	2300.00
5887	Ready to move	2018-10-11	1200.00
5887	kjjdkjsd sdhk	2018-10-17	333.00
5887	for rent from 20th october 	2018-10-20	1000.00
5887	for rent from 20th october	2018-10-22	1000.00
5887	2bedroom spacious tile house	2018-11-09	150.00
5887	kjrg;rg;erge;ogreorgoe	2018-11-10	500.00

--Stored procedure:
CREATE PROCEDURE  @OwnerId6 INT
AS
BEGIN
select RL.PropertyId, RL.[Description], RL.AvailableDate, RL.TargetRent FROM RentalListing RL
INNER JOIN Property P ON (RL.PropertyId = P.Id)
INNER JOIN OwnerProperty AS op ON (OP.PropertyId = P.Id AND OP.OwnerId=@OwnerId6) 
END


--(K) Given Owner Id, search string, sort order string and page number, build Stored Procedure to find his properties with search, sort, and pagination.

CREATE PROCEDURE spPropertyInfoSearchSortPagination
@OwnerId7 INT, 
@SortString VARCHAR(50) = 'ASC',
@Search_By_PropertyName NVARCHAR(50)= '',
@PageNo INT = 1

AS
BEGIN
SET NOCOUNT ON;
SELECT OwnerId, PropertyId, PurchaseDate, Name AS "Property Name", Description AS "Property Description"  
FROM OwnerProperty OP
INNER JOIN Property P ON (OP.PropertyId=P.Id and OP.OwnerId= @OwnerId7 AND P.Name LIKE '%' + Search_BY_PropertyName + '%')
ORDER BY
	    CASE 
		WHEN @SortString = 'PropertyId' THEN 'PropertyId'
        WHEN @SortString = 'PurchaseDate' THEN 'PurchaseDate'
END
OFFSET (@PageNo - 1) * 10 ROW
FETCH NEXT 10 ROWS ONLY


--(L) Given Owner Id, search string, sort order string, page size, page number, build stored procedure to find all rental listing owned by this Owner including any media (photo).

CREATE PROCEDURE spRentallistingSearchSortPagination
@OwnerId8 INT, 
@SortString VARCHAR(50) = 'ASC',
@Search_By_Description NVARCHAR(50)= '',
@PageNo INT = 1

AS
BEGIN
SET NOCOUNT ON;
SELECT OP.PropertyId, RL.AvailableDate, RL.[Description], RL.MovingCost,  RL.IdealTenant, RL.Title 
FROM RentalListing AS RL
INNER JOIN OwnerProperty OP ON (OP.PropertyId=RL.PropertyId AND OP.OwnerId = @OwnerId8 AND RL.[Description] LIKE '%' + @Search_By_Description +'%')
ORDER BY
	    CASE 
		WHEN @SortString = 'PropertyId' then 'PropertyId'
        WHEN @SortString = 'AvailableDate' then 'AvailableDate'
END
OFFSET (@PageNo - 1) * 10 ROW
FETCH NEXT 10 ROWS ONLY
END

--(M) Given Owner Id, search string, sort order string, page size, page number, build stored procedure to find all requests from this owner to tenants including any media (photo, documents).

CREATE PROCEDURE spOwnerRequestTenantSearchSortPagination

 @OwnerId9 INT, 
 @SortString VARCHAR(50) = 'asc',
 @Search_By_RequestMessage NVARCHAR(50)= '',
 @PageNo INT = 1

AS
BEGIN
SET NOCOUNT ON;
SELECT PR.PropertyId, OP.OwnerId, P.[Name], PR.RequestMessage, PR.ToTenant, PR.Reason, PR.CreatedOn 
FROM PropertyRequest PR
INNER JOIN Property AS P ON P.Id =PR.PropertyId 
INNER JOIN OwnerProperty AS OP ON (OP.PropertyId=P.Id AND OP.OwnerId= @OwnerId9  AND PR.RequestMessage LIKE '%' + @Search_by_RequestMessage +'%')
WHERE PR.ToTenant = 1
ORDER BY
	    CASE 
		WHEN @SortString = 'PropertyId' THEN 'PropertyId'
        WHEN @SortString = 'CreatedOn' THEN 'CreatedOn'
END
OFFSET (@PageNo - 1) * 10 ROW
FETCH NEXT 10 ROWS ONLY
END;

--(N) Given owner Id, search string, sort order string, page size, page number, build stored procedure to jobs in marketplace that belong to this owner including any media (photo, documents).

CREATE PROCEDURE spOwnerJobsSearchSortPagination
 @OwnerId10 INT, 
 @SortString VARCHAR(50) = 'asc',
 @Search_By_Jobdescription NVARCHAR(50)= '',
 @PageNo INT = 1
 AS
BEGIN
SET NOCOUNT ON;
SELECT j.OwnerId, J.PaymentAmount, J.JobStartDate, J.JobDescription, J.MaxBudget 
FROM Job J
INNER JOIN OwnerProperty AS OP ON (OP.PropertyId=J.PropertyId AND OP.OwnerId = @OwnerId10 AND J.JobDescription LIKE '%' +  @Search_By_Jobdescription +'%')
WHERE J.JobStartDate IS NOT NULL AND J.MaxBudget IS NOT NULL
ORDER BY
	   CASE 
	   WHEN @SortString = 'OwnerId' THEN 'OwnerId'
       WHEN @SortString = 'JobstartDate' THEN 'JobstartDate'
END
OFFSET (@PageNo - 1) * 10 ROW
FETCH NEXT 10 ROWS ONLY
END

--(O) Given owner Id, search string, sort order string, page size, page number, build stored procedure to find current maintenance (jobs) for all properties that belong to this owner including any media (photo, documents).

CREATE PROCEDURE spCurrentJobMantenanceSearchSortPagination

 @OwnerId11 INT, 
 @SortString VARCHAR(50) = 'ASC',
 @Search_By_Jobdescription NVARCHAR(50)= '',
 @PageNo INT = 1

AS
BEGIN


SELECT J.Id, J.CreatedBy, J.JobDescription, J.JobStartDate, "JobStatus"=
        CASE
        WHEN J.JobStatusId = 1 THEN 'Open'
        WHEN J.JobStatusId = 2 THEN 'Accepted'
        WHEN J.JobStatusId = 3 THEN 'Removed'
        WHEN J.JobStatusId = 4 THEN 'Pending'
        WHEN J.JobStatusId = 5 THEN 'Closed'
        ELSE 'not specified'
        END
FROM Job J
INNER JOIN ServiceProvider SP
ON ( J.ProviderId = SP.Id  AND J.OwnerId=@OwnerId11 AND j.JobDescription LIKE '%' +  @Search_By_Jobdescription +'%')
WHERE J.JobStartDate IS NOT NULL
ORDER BY
	    CASE
		WHEN @SortString = 'OwnerId' THEN 'OwnerId'
        WHEN @SortString = 'Jobsstart' THEN 'JobstartDate'
        END
OFFSET (@PageNo - 1) * 10 ROW
FETCH NEXT 10 ROWS ONLY
END

--(P) Given owner Id, search string, sort order string, status string, page size, page number, build stored procedure to find all requests from tenants to this owner including any media (photo, documents).

CREATE PROCEDURE spTenantReqOwnerSearchSortPagination

 @OwnerId12 INT, 
 @SortString VARCHAR(50) = 'ASC',
 @Search_by_RequestMessage NVARCHAR(50)= '',
 @PageNo INT = 1

AS
BEGIN
SET NOCOUNT ON;
SELECT PR.PropertyId, OP.OwnerId, P.[Name], PR.RequestMessage, PR.ToTenant, PR.Reason, PR.CreatedOn 
FROM PropertyRequest pr
INNER JOIN Property AS P ON P.Id = PR.PropertyId 
INNER JOIN OwnerProperty AS OP ON (OP.PropertyId = P.Id AND OP.OwnerId = @OwnerId12  AND PR.RequestMessage LIKE '%' + @Search_by_RequestMessage + '%')
WHERE PR.ToOwner= 1
OEDER BY
	    CASE
		WHEN @SortString = 'PropertyId' THEN 'PropertyId'
        WHEN @SortString = 'CreatedOn' THEN 'CreatedOn'
        END
OFFSET (@PageNo - 1) * 10 ROW
FETCH NEXT 10 ROWS ONLY
END

--(Q) Build Stored Procedure: Tenant my request with search, sort, and pagination.

CREATE PROCEDURE spTenantJobRequestSearchSortPagination

 @TenantId INT, 
 @SortString VARCHAR(50) = 'ASC',
 @Search_By_JobDescription NVARCHAR(50)= '',
 @PageNo INT = 1
AS
BEGIN
SET NOCOUNT ON;
SELECT tjr.PropertyId, tjr.JobDescription, tjr.CreatedBy, tjr.CreatedOn 
FROM TenantJobRequest TJR
INNER JOIN TenantProperty AS TP ON (TP.PropertyId = TJR.PropertyId AND TP.TenantId= @TenantId  AND tjr.JobDescription LIKE '%' + @Search_by_JobDescription +'%')
ORDER BY
	CASE
	WHEN @SortString = 'PropertyId' THEN 'PropertyId'
    WHEN @SortString = 'CreatedOn' THEN 'CreatedOn'
    END
OFFSET (@PageNo - 1)* 10 ROW
FETCH NEXT 10 ROWS ONLY
END