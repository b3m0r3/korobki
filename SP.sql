
CREATE PROCEDURE KOROBKI @nomernedeli int
AS
begin
DECLARE @tv TABLE 
    (week INT,
     operations INT,
	 ost_2 INT,
	 ost_doc_1 INT,
	 ost_1 INT,
	 ost_doc INT,
	 kor INT
    );

INSERT @tv
SELECT [week],
       SUM([operations]) 'документов за неделю'
	  ,200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC) 'остаток недели -2'
	  ,(LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC))   as 'ОСТАЛОСЬ РАЗМЕСТИТЬ ДОКУМЕНТОВ -1'
	  ,200 - ((LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC)))%200 'остаток недели -1 прав'
	  ,SUM([operations]) - (200 - ((LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC)))%200 ) as 'ОСТАЛОСЬ РАЗМЕСТИТЬ ДОКУМЕНТОВ Х'
	  ,CEILING((SUM([operations]) - (200 - ((LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC)))%200 ) +0.0 )/200 )  'коробок за неделю'
  FROM [SHESHKO].[dbo].[alpha] 
  GROUP BY [WEEK] ORDER BY [week] DESC; 



SELECT [kor] FROM @tv WHERE [week] = @nomernedeli
end