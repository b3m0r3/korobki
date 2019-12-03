
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
       SUM([operations]) '���������� �� ������'
	  ,200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC) '������� ������ -2'
	  ,(LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC))   as '�������� ���������� ���������� -1'
	  ,200 - ((LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC)))%200 '������� ������ -1 ����'
	  ,SUM([operations]) - (200 - ((LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC)))%200 ) as '�������� ���������� ���������� �'
	  ,CEILING((SUM([operations]) - (200 - ((LEAD(SUM([operations])) OVER(ORDER BY [week] DESC)) - (200 - LEAD(SUM([operations])%200,2) OVER(ORDER BY [week] DESC)))%200 ) +0.0 )/200 )  '������� �� ������'
  FROM [SHESHKO].[dbo].[alpha] 
  GROUP BY [WEEK] ORDER BY [week] DESC; 



SELECT [kor] FROM @tv WHERE [week] = @nomernedeli
end