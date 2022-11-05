DROP PROCEDURE
    IF EXISTS PFOCEDURE_NAME;
DELIMITER;;
CREATE PROCEDURE PFOCEDURE_NAME ()
BEGIN
	DECLARE n INT DEFAULT 0;
	WHILE ( n < 10 ) DO
	    -- 循环的内容
			-- INSERT INTO `student` ( `id`, `name`, `age`, `create_time`, `update_time`, `score` ) VALUES ( n, 'stu', FLOOR( 10 + RAND()* 21 ), LOCALTIME (), LOCALTIME (), FLOOR( 60 + RAND()* 41 ) + 0.567 );
	        select now();
		SET n = n + 1;
    END WHILE;
END;;
CALL PFOCEDURE_NAME ();